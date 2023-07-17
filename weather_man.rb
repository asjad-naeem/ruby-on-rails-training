require "colorize"
# This is a class for Weather Data
class WeatherMan
  attr_accessor :user_input, :year, :month
  FILES = %w[lahore_weather Murree_weather Dubai_weather]

  def initialize
    @user_input = -1
    @year = ""
    @month = ""
  end

  def menu
    print <<MENU
      1- For a given year display the highest temperature and day, lowest temperature and day, most humid day and humidity.
      2- For a given month display the average highest temperature, average lowest temperature, average humidity.
      3- For a given month draw two horizontal bar charts on the console for the highest and lowest temperature on each day.
MENU
    @user_input = gets
    @user_input = @user_input.to_i
    puts "Incorrect input! Please input from the given choices(1-3)" if @user_input > 3 || @user_input < 1
  end

  def display(output_data)
    puts output_data
  end

  def display_month_detail(max_data_hash, min_data_hash)
    max_data_hash&.each do |key, val|
      index = 1
      print key, " "
      while index <= val.to_i
        print "+".colorize(:red)
        index += 1
      end
      print val, "C", "\n"
      index = 1
      print key, " "
      while index <= min_data_hash[key].to_i
        print "+".colorize(:blue)
        index += 1
      end
      print min_data_hash[key], " C", "\n"
    end
    # Bonus
    puts "Bonus Below:"
    max_data_hash&.each do |key, val|
      index = 1
      print key, " "
      while index <= val.to_i
        if index <= min_data_hash[key].to_i
          print "+".colorize(:blue)
        else
          print "+".colorize(:red)
        end
        index += 1
      end
      print val, " C", "\n"
    end
  end
end
