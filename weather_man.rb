# frozen_string_literal: true

$LOAD_PATH << '.'
require 'colorize'
require 'temperature'
require 'humidity'
# This is a class for Weather Data
class WeatherMan
  include Temperature
  include Humidity
  FILES = %w[lahore_weather Murree_weather Dubai_weather].freeze

  def display(output_data)
    puts output_data
  end

  def display_month_detail(hashes_arr)
    max_data_hash = hashes_arr[0]
    min_data_hash = hashes_arr[1]
    if min_data_hash.size.positive? && max_data_hash.size.positive?
      max_data_hash&.each do |key, val|
        index = 1
        print key, ' '
        while index <= val.to_i
          print '+'.colorize(:red)
          index += 1
        end
        print val, 'C', "\n"
        index = 1
        print key, ' '
        while index <= min_data_hash[key].to_i
          print '+'.colorize(:blue)
          index += 1
        end
        print min_data_hash[key], ' C', "\n"
      end
      # Bonus
      puts 'Bonus Below:'
      max_data_hash&.each do |key, val|
        index = 1
        print key, ' '
        while index <= val.to_i
          if index <= min_data_hash[key].to_i
            print '+'.colorize(:blue)
          else
            print '+'.colorize(:red)
          end
          index += 1
        end
        print val, ' C', "\n"
      end
    else
      puts 'No data for the given month is found'
    end
  end
end
if ARGV.length == 3
  weather_man = WeatherMan.new
  case ARGV[0]
  when '-e'
    weather_man.display(weather_man.get_yealy_temp_report(ARGV[1], ARGV[2]))
    weather_man.display(weather_man.get_max_humidity(ARGV[1], ARGV[2]))
  when '-a'
    data = ARGV[1].split '/'
    if data.length < 2
      display('Incorrect Month Provided')
    else
      weather_man.display(weather_man.get_month_avg_report(data[0].to_i, data[1].to_i, ARGV[2]))
      weather_man.display(weather_man.get_avg_humidity(data[0].to_i, data[1].to_i, ARGV[2]))
    end
  when '-c'
    data = ARGV[1].split '/'
    if data.length < 2
      puts 'Incorrect input! Month not Provided'
    else
      data = ARGV[1].split '/'
      weather_man.display_month_detail(weather_man.get_complete_month_detail(data[0].to_i, data[1].to_i, ARGV[2]))
    end
  end
else
  puts 'Incorrect input! Arguments are not complete!'
end
