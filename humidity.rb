require_relative "weather_man.rb"
require "date"
# This is a class for Temprature related stuff
class Humidity < WeatherMan
  def initialize
    @max_hum = -9999
    @min_temp = 9999
    @max_hum_day = ""
    @min_day = ""
    super
  end

  def get_max_humidity
    for totalfiles in 0..2
      totalfiles == 0 ? limit = 1 : limit = 0
      for totalmonths in 0..11
        filename = "#{FILES[totalfiles]}_#{@year}_#{Date::MONTHNAMES[totalmonths + 1].slice(0, 3)}.txt"
        data = []
        data = File.readlines("./#{FILES[totalfiles]}/#{filename}") if File.exist?("./#{FILES[totalfiles]}/#{filename}")
        for i in 0..data&.size
          if (i > limit && data[i])
            row_data = data[i].split ","
            if row_data[7]&.size.to_i.positive? && row_data[7]&.to_i >= @max_hum.to_i
              @max_hum = row_data[7]
              @max_hum_day = row_data[0]
            end
          end
        end
      end
    end
    display("Max Humidity: #{@max_hum} and Day is: #{@max_hum_day}") if @max_hum != -9999
    display("No humidity related data exists for the given year") if @max_hum == -9999
  end

  def get_avg_humidity
    hum_data_count = 0
    hum_sum = 0
    for totalfiles in 0..2
      totalfiles == 0 ? limit = 1 : limit = 0
      filename = "#{FILES[totalfiles]}_#{@year}_#{Date::MONTHNAMES[@month.to_i].slice(0, 3)}.txt"
      data = []
      data = File.readlines("./#{FILES[totalfiles]}/#{filename}") if File.exist?("./#{FILES[totalfiles]}/#{filename}")
      for i in 0..data&.size
        if (i > limit && data[i])
          row_data = data[i].split ","
          if row_data[8]&.size.to_i.positive?
            hum_sum += row_data[8].to_i
            hum_data_count += 1
          end
        end
      end
    end
    hum_avg = hum_sum / hum_data_count if hum_data_count > 0
    display("Avg Humidity: #{hum_avg}%") if hum_data_count > 0
    display("No humidity related data exists for the given year") if hum_data_count == 0
  end

  def select_humidity_action(user_choice)
    get_max_humidity if user_choice == 1
    get_avg_humidity if user_choice == 2
  end
end
