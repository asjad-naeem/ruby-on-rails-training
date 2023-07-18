# frozen_string_literal: true

require 'date'
module Temperature
  def get_yealy_temp_report(year, path)
    max_temp = -9999
    min_temp = 9999
    max_day = ''
    min_day = ''
    limit = path.include?('lahore') ? 1 : 0
    12.times do |totalmonths|
      filename = "#{path}/#{path}_#{year}_#{Date::MONTHNAMES[totalmonths + 1].slice(0, 3)}.txt"
      data = []
      data = File.readlines(filename.to_s) if File.exist?(filename.to_s)
      (0..data&.size).each do |i|
        next if i <= limit || !data[i]

        row_data = data[i].split ','
        if row_data[1]&.size.to_i.positive? && row_data[1].to_i >= max_temp.to_i
          max_temp = row_data[1].to_i
          max_day = row_data[0]
        end
        if row_data[3]&.size.to_i.positive? && row_data[3].to_i <= min_temp.to_i
          min_temp = row_data[3].to_i
          min_day = row_data[0]
        end
      end
    end
    return 'No temperature related data exists for the given year' if max_temp == -9999 && min_temp == 9999

    output = "Max Temperature: #{max_temp} on: #{max_day}\nMin Temperature: #{min_temp} on: #{min_day}\n"
    return output if max_temp != -9999 && min_temp != 9999
  end

  def get_month_avg_report(year, month, path)
    max_data_count = 0
    max_sum = 0
    min_data_count = 0
    min_sum = 0
    limit = path.include?('lahore') ? 1 : 0
    filename = "#{path}/#{path}_#{year}_#{Date::MONTHNAMES[month].slice(0, 3)}.txt"
    data = []
    data = File.readlines(filename.to_s) if File.exist?(filename.to_s)
    (0..data&.size).each do |i|
      next unless i > limit && data[i]

      row_data = data[i].split ','
      if row_data[1]&.size.to_i.positive?
        max_sum += row_data[1].to_i
        max_data_count += 1
      end
      if row_data[3]&.size.to_i.positive?
        min_sum += row_data[3].to_i
        min_data_count += 1
      end
    end
    max_avg = max_sum / max_data_count if max_data_count.positive?
    min_avg = min_sum / min_data_count if min_data_count.positive?
    return 'No temperature related data exists for the given year' if max_data_count.zero? && min_data_count.zero?

    output = "Avg Max Temperature: #{max_avg} C\nAvg Min Temperature: #{min_avg} C\n"
    return output if max_data_count.positive? && min_data_count.positive?
  end

  def get_complete_month_detail(year, month, path)
    max_data_hash = {}
    min_data_hash = {}
    limit = path.include?('lahore') ? 1 : 0
    filename = "#{path}/#{path}_#{year}_#{Date::MONTHNAMES[month].slice(0, 3)}.txt"
    data = []
    data = File.readlines(filename) if File.exist?(filename)
    (0..data&.size).each do |i|
      next unless i > limit && data[i]

      row_data = data[i].split ','
      next unless row_data[1]&.size.to_i.positive?

      key = row_data[0].split '-'
      if max_data_hash[key[2]].nil?
        max_data_hash.store(key[2], row_data[1])
      elsif row_data[1].to_i > max_data_hash[key[2]].to_i
        max_data_hash[key[2]] = row_data[1]
      end
      next unless row_data[3]&.size.to_i.positive?

      key = row_data[0].split '-'
      if min_data_hash[key[2]].nil?
        min_data_hash.store(key[2], row_data[3])
      elsif row_data[3].to_i < min_data_hash[key[2]].to_i
        min_data_hash[key[2]] = row_data[3]
      end
    end
    [max_data_hash, min_data_hash]
  end
end
