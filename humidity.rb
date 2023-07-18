# frozen_string_literal: true

require 'date'
module Humidity
  def get_max_humidity(year, path)
    max_hum = -9999
    max_hum_day = ''
    limit = path.include?('lahore') ? 1 : 0
    12.times do |totalmonths|
      filename = "#{path}/#{path}_#{year}_#{Date::MONTHNAMES[totalmonths + 1].slice(0, 3)}.txt"
      data = []
      data = File.readlines(filename) if File.exist?(filename)
      (0..data&.size).each do |i|
        next if i <= limit || !data[i]

        row_data = data[i].split ','
        if row_data[7]&.size.to_i.positive? && row_data[7].to_i >= max_hum.to_i
          max_hum = row_data[7]
          max_hum_day = row_data[0]
        end
      end
    end
    return "Max Humidity: #{max_hum} and Day is: #{max_hum_day}" if max_hum != -9999
    return 'No humidity related data exists for the given year' if max_hum == -9999
  end

  def get_avg_humidity(year, month, path)
    hum_data_count = 0
    hum_sum = 0
    limit = path.include?('lahore') ? 1 : 0
    filename = "#{path}/#{path}_#{year}_#{Date::MONTHNAMES[month].slice(0, 3)}.txt"
    data = []
    data = File.readlines(filename) if File.exist?(filename)
    (0..data&.size).each do |i|
      next if i <= limit || !data[i]

      row_data = data[i].split ','
      next unless row_data[8]&.size.to_i.positive?

      hum_sum += row_data[8].to_i
      hum_data_count += 1
    end
    hum_avg = hum_sum / hum_data_count if hum_data_count.positive?
    return "Avg Humidity: #{hum_avg}%" if hum_data_count.positive?

    return 'No humidity related data exists for the given year' if hum_data_count.zero?
  end

  def select_humidity_action(user_choice)
    get_max_humidity if user_choice == 1
    get_avg_humidity if user_choice == 2
  end
end
