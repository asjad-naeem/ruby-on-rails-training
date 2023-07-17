require_relative "weather_man.rb"
require "date"
# This is a class for Temprature related stuff
class Temperature < WeatherMan
  def initialize
    @max_temp = -9999
    @min_temp = 9999
    @max_day = ""
    @min_day = ""
    super
  end

  def get_yealy_temp_report
    puts "Enter Year:"
    @year = gets.chomp
    for totalfiles in 0..2
      totalfiles == 0 ? limit = 1 : limit = 0
      for totalmonths in 0..11
        filename = "#{FILES[totalfiles]}_#{@year}_#{Date::MONTHNAMES[totalmonths + 1].slice(0, 3)}.txt"
        data = []
        data = File.readlines("./#{FILES[totalfiles]}/#{filename}") if File.exist?("./#{FILES[totalfiles]}/#{filename}")
        for i in 0..data&.size
          if (i > limit && data[i])
            row_data = data[i].split ","
            if row_data[1]&.size.to_i.positive? && row_data[1]&.to_i >= @max_temp.to_i
              @max_temp = row_data[1]
              @max_day = row_data[0]
            end
            if row_data[3]&.size.to_i.positive? && row_data[3]&.to_i <= @min_temp.to_i
              @min_temp = row_data[3]
              @min_day = row_data[0]
            end
          end
        end
      end
    end
    display("No temperature related data exists for the given year") if @max_temp == -9999 && @min_temp == 9999
    display("Max Temperature: #{@max_temp} and Day is: #{@max_day}\nMin Temperature: #{@min_temp} and Day is: #{@min_day}\n") if @max_temp != -9999 && @min_temp != 9999
  end

  def get_month_avg_report
    puts "Enter Month(2003/1):"
    input = gets.chomp
    input = input.split "/"
    @year = input[0]
    @month = input[1].to_i - 1
    if @month < 1 || @month > 12 || 
      display("Incorrect Input months cannot be less than 0 or more than 12")
    else
      max_data_count = 0
      max_sum = 0
      min_data_count = 0
      min_sum = 0
      for totalfiles in 0..2
        totalfiles == 0 ? limit = 1 : limit = 0
        filename = "#{FILES[totalfiles]}_#{@year}_#{Date::MONTHNAMES[@month.to_i].slice(0, 3)}.txt"
        data = []
        data = File.readlines("./#{FILES[totalfiles]}/#{filename}") if File.exist?("./#{FILES[totalfiles]}/#{filename}")
        for i in 0..data&.size
          if (i > limit && data[i])
            row_data = data[i].split ","
            if row_data[1]&.size.to_i.positive?
              max_sum += row_data[1].to_i
              max_data_count += 1
            end
            if row_data[3]&.size.to_i.positive?
              min_sum += row_data[3].to_i
              min_data_count += 1
            end
          end
        end
      end
      max_avg = max_sum / max_data_count if max_data_count > 0
      min_avg = min_sum / min_data_count if min_data_count > 0
      display("No temperature related data exists for the given year") if max_data_count == 0 && min_data_count == 0
      display("Avg Max Temperature: #{max_avg} C\nAvg Min Temperature: #{min_avg} C\n") if max_data_count > 0 && min_data_count > 0
    end
  end

  def get_complete_month_detail
    puts "Enter Month(2003/1):"
    input = gets.chomp
    input = input.split "/"
    @year = input[0]
    @month = input[1].to_i - 1
    if @month < 1 || @month > 12
      display("Incorrect Input months cannot be less than 0 or more than 12")
    else
      max_data_hash = Hash.new
      min_data_hash = Hash.new
      for totalfiles in 0..2
        totalfiles == 0 ? limit = 1 : limit = 0
        filename = "#{FILES[totalfiles]}_#{@year}_#{Date::MONTHNAMES[@month.to_i].slice(0, 3)}.txt"
        data = []
        data = File.readlines("./#{FILES[totalfiles]}/#{filename}") if File.exist?("./#{FILES[totalfiles]}/#{filename}")
        for i in 0..data&.size
          if (i > limit && data[i])
            row_data = data[i].split ","
            if row_data[1]&.size.to_i.positive?
              key = row_data[0].split "-"
              if max_data_hash[key[2]] == nil
                max_data_hash.store(key[2], row_data[1])
              else
                max_data_hash[key[2]] = row_data[1] if row_data[1].to_i > max_data_hash[key[2]].to_i
              end
            end
            if row_data[3]&.size.to_i.positive?
              key = row_data[0].split "-"
              if min_data_hash[key[2]] == nil
                min_data_hash.store(key[2], row_data[3])
              else
                min_data_hash[key[2]] = row_data[3] if row_data[3].to_i < min_data_hash[key[2]].to_i
              end
            end
          end
        end
      end
    end
    display_month_detail(max_data_hash, min_data_hash)
  end

  def select_temperature_action(user_choice)
    get_yealy_temp_report if user_choice == 1
    get_month_avg_report if user_choice == 2
    get_complete_month_detail if user_choice == 3
  end
end
