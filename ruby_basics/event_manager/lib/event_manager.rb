require 'csv'
require 'fileutils'
require 'erb'
require 'bigdecimal'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_number(phone)
  wrong_number = ''.rjust(10, '0')

  if phone.match?(/[-+]?\d*\.?\d+(e|E)[-+]?\d+/)
    begin
      parse_exponential(phone)
    rescue FloatDomainError
      wrong_number
    end
  end

  phone.gsub!(/\D/, '')
  phone_size = phone.to_s.size

  if phone_size < 10 || phone_size > 11
    wrong_number
  elsif phone_size == 10
    phone
  elsif phone_size == 11 && phone[0] == '1'
    phone[1..10]
  elsif phone_size == 11
    wrong_number
  end
end

def parse_exponential(number)
  BigDecimal(number).to_i
end

def parse_dates(string_dates)
  string_dates.map do |date_time|
    DateTime.strptime(date_time, '%m/%d/%y %k:%M')
  end
end

def most_repeated(list)
  list_count = list.each_with_object(Hash.new(0)) do |n, acc|
    acc[n] = acc[n] + 1
  end
  list_count.rassoc(list_count.values.max)[0]
end

def time_target(reg_dates)
  most_repeated(reg_dates.map(&:hour))
end

def week_target(reg_dates)
  most_repeated(reg_dates.map do |date_time|
    date_time.strftime('%A')
  end)
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

phone_numbers = []
registration_dates = []

contents.each_with_index do |row, index|
  id = row[0]
  name = row[:first_name]
  phone_number = row[:homephone]
  reg_date = row[:regdate]

  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  create_file_letter(id, erb_template.result(binding))
  show_progress_bar(index + 1, contents_length)
  phone_numbers.push(clean_phone_number(phone_number))
  registration_dates.push(reg_date)
end

puts 'List of phone numbers'
puts phone_numbers

parsed_dates = parse_dates(registration_dates)
puts "The most popular hour users register is #{time_target(parsed_dates)}"
puts "The most popular day of the week users register is #{week_target(parsed_dates)}"
