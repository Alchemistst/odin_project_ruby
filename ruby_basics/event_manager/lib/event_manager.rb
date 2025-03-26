require 'csv'
require 'fileutils'
require 'erb'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip
  begin
    civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue Google::Apis::ClientError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def create_file_letter(id, template)
  output_dir = 'output'
  filename = "#{output_dir}/letter_#{id}.html"
  FileUtils.mkdir_p(output_dir)
  file = nil
  begin
    file = File.open(filename, 'w') { |f| f.puts template }
  rescue StandardError
    file.close
  end
end

def show_progress_bar(progress, total)
  current_progress = (10 * progress / total)
  progress_bar = "[#{('=' * current_progress).ljust(10, ' ')}]"
  puts progress_bar
end
puts 'Event Manager Initialized!'

input_file = 'event_attendees.csv'
input_template = 'form_letter.erb'
template_letter = File.read(input_template)
erb_template = ERB.new template_letter

contents = CSV.open(input_file, headers: true, header_converters: :symbol)
contents_length = CSV.read(input_file, headers: true).length
contents.each_with_index do |row, index|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  create_file_letter(id, erb_template.result(binding))
  show_progress_bar(index + 1, contents_length)
end
