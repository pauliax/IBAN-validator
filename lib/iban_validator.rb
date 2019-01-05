# Validates IBAN number
class IbanValidator

  # Maps country code to the length of IBAN
  # Source: https://www.iban.com/structure
  def countries_length
    { 
      "AL" => 28,
      "AD" => 24,
      "AT" => 20,
      "AZ" => 28,
      "BH" => 22,
      "BY" => 28,
      "BE" => 16,
      "BA" => 20,
      "BR" => 29,
      "BG" => 22,
      "CR" => 22,
      "HR" => 21,
      "CY" => 28,
      "CZ" => 24,
      "DK" => 18,
      "DO" => 28,
      "SV" => 28,
      "EE" => 20,
      "FO" => 18,
      "FI" => 18,
      "FR" => 27,
      "GE" => 22,
      "DE" => 22,
      "GI" => 23,
      "GR" => 27,
      "GL" => 18,
      "GT" => 28,
      "HU" => 28,
      "IS" => 26,
      "IQ" => 23,
      "IE" => 22,
      "IL" => 23,
      "IT" => 27,
      "JO" => 30,
      "KZ" => 20,
      "XK" => 20,
      "KW" => 30,
      "LV" => 21,
      "LB" => 28,
      "LI" => 21,
      "LT" => 20,
      "LU" => 20,
      "MK" => 19,
      "MT" => 31,
      "MR" => 27,
      "MU" => 30,
      "MD" => 24,
      "MC" => 27,
      "ME" => 22,
      "NL" => 18,
      "NO" => 15,
      "PK" => 24,
      "PS" => 29,
      "PL" => 28,
      "PT" => 25,
      "QA" => 29,
      "RO" => 24,
      "LC" => 32,
      "SM" => 27,
      "ST" => 25,
      "SA" => 24,
      "RS" => 22,
      "SC" => 31,
      "SK" => 24,
      "SI" => 19,
      "ES" => 24,
      "SE" => 24,
      "CH" => 21,
      "TL" => 23,
      "TN" => 24,
      "TR" => 26,
      "UA" => 29,
      "AE" => 23,
      "GB" => 22,
      "VG" => 24
    }
  end

  # Returns if IBAN number is valid or not
  def is_valid_iban?(iban)
    iban = iban.strip

    return false unless iban =~ /^[A-Z0-9]+$/
    return false unless valid_country_code?(iban)
    return false unless valid_length?(iban)
    return false unless valid_mod_97?(iban)

    true
  end

  # Validates an array of IBAN numbers
  def validate_batch(ibans)
    ibans.map { |iban| iban.strip << ';' << is_valid_iban?(iban).to_s }
  end

  private

  # Returns country code
  def country_code(iban)
    iban[0..1]
  end

  # Returns check digits
  def check_digits(iban)
    iban[2..3]
  end

  # returns BBAN code
  def bban(iban)
    iban[4..-1]
  end

  # Returns if country code exists or not
  def valid_country_code?(iban)
    country = country_code(iban)
    countries_length.key?(country)
  end

  # Returns if IBAN length is valid
  def valid_length?(iban)
    length = iban.length
    country = country_code(iban)
    country_length = countries_length.fetch(country, nil)
    country_length && country_length == length
  end

  # Converts IBAN to the specified format and checks if the remainder on division by 97 is 1
  def valid_mod_97?(iban)
    modified_iban = bban(iban) << country_code(iban) << check_digits(iban)

    modified_iban = modified_iban.chars.map do |element|
      if element >= 'A' && element <= 'Z'
        element.ord - 'A'.ord + 10
      else
        element
      end
    end

    modified_iban.join.to_i % 97 == 1
  end
end
