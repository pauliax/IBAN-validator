require_relative('../lib/files_service')
require_relative('../lib/iban_validator')

# App UI
class UI
  START_MENU_PROMPT = '
  0 - Exit
  1 - Enter IBAN number
  2 - Check IBAN numbers from file
  '.freeze

  def initialize
    puts 'Welcome to the IBAN Validator'

    @iban_validator = IbanValidator.new
    @files_service = FilesService.new
  end

  def start_menu
    puts START_MENU_PROMPT
    process_menu_choice
  end

  # 1 - check individual IBAN from stdin
  def check_iban
    puts 'Enter IBAN number:'
    iban_number = gets.strip
  
    if @iban_validator.is_valid_iban?(iban_number)
      puts 'IBAN number is valid'
    else
      puts 'IBAN number is not valid'
    end

    start_menu
  end

  # 2 - check IBANs from file
  def check_ibans_from_file
    puts 'Enter file name with the path:'
    file_path = gets.strip

    ibans = @files_service.read_file(file_path)

    if ibans
      ibans = @iban_validator.validate_batch(ibans)
      file_path = @files_service.results_file_path(file_path)
      @files_service.write_file(file_path, ibans)

      puts 'Results written to the file: ' << file_path
    else
      puts 'File not found'
    end

    start_menu
  end

  private

  def process_menu_choice
    choice = gets.strip

    case choice
    when '0'
      exit
    when '1'
      check_iban
    when '2'
      check_ibans_from_file
    else
      puts 'Invalid option'
      start_menu
    end
  end
end
