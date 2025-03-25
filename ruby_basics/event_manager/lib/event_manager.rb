require 'csv'
require 'fileutils'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip
  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    )
    legislators.officials.map(&:name).join(', ')
  rescue Google::Apis::ClientError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def create_file_letter(name, content, template, index)
  result = template.gsub('FIRST_NAME', name)
  result = result.gsub('LEGISLATORS', content)
  FileUtils.mkdir_p('letters')
  file = nil
  begin
    file = File.open("letters/letter_#{index}.html", 'w') { |f| f.write(result) }
  rescue StandardError
    file.close
  end
end

puts 'Event Manager Initialized!'

template_letter = File.read('form_letter.html')

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
contents.each_with_index do |row, index|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators_string = legislators_by_zipcode(zipcode)
  create_file_letter(name, legislators_string, template_letter, index)
  puts "#{name} #{zipcode} #{legislators_string}"
end
