# Files service class
class FilesService
  # Reads file line by line and returns an aray
  def read_file(file_path)
    return nil unless File.file?(file_path)

    lines = []

    File.open(file_path, "r") do |file|
      file.each_line do |line|
        lines.push(line)
      end
    end

    lines
  end

  # Writes array line by line to the file
  def write_file(file_path, array)
    File.open(file_path, 'w') do |file|
      array.each { |line| file.puts(line) }
    end
  end

  # Replaces ending of the file with .out
  def results_file_path(old_path)
    old_path.split('.').first << '.out'
  end
end
