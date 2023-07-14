require "colorize"
# This is a class for Weather Data
class WeatherMan
  $choice = -1
  $year = ""
  $month = ""
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec] 
  LAHORE = "lahore_weather_"
  MURREE = "Murree_weather_"
  DUBAI = "Dubai_weather_"
  FILES = %w[lahore_weather Murree_weather Dubai_weather]

  def menu
    print <<MENU
      1- For a given year display the highest temperature and day, lowest temperature and day, most humid day and humidity.
      2- For a given month display the average highest temperature, average lowest temperature, average humidity.
      3- For a given month draw two horizontal bar charts on the console for the highest and lowest temperature on each day.
MENU
    $choice = gets
    $choice = $choice.to_i
    choice_one_temp if $choice == 1
    choice_two_temp if $choice == 2
    choice_three_temp if $choice == 3
  end

  def display(para)
    puts para
  end

  def display_choice3(max_data_hash, min_data_hash)
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
      print min_data_hash[key], "C", "\n"
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
      print val, "C", "\n"
    end
  end
end

# This is a class for Temprature related stuff
class Temperature < WeatherMan
  def initialize
    @max_temp = -9999
    @max_hum = -9999
    @min_temp = 9999
    @max_day = ""
    @min_day = ""
    @max_hum_day = ""
    super
  end

  def choice_one_temp
    puts "Enter Year:"
    $year = gets.chomp
    for totalfiles in 0..2 
      totalfiles == 0 ? limit = 1 : limit = 0 
      for totalmonths in 0..11 
        tt = "#{FILES[totalfiles]}_#{$year}_#{MONTHS[totalmonths]}.txt"
        tempdata = []
        tempdata = File.readlines("./#{FILES[totalfiles]}/#{tt}") if File.exist?("./#{FILES[totalfiles]}/#{tt}")
        for i in 0..tempdata&.size
          if (i > limit && tempdata[i])
            data1 = tempdata[i].split ","
            if data1[1]&.size.to_i.positive? && data1[1]&.to_i >= @max_temp.to_i 
              @max_temp = data1[1]
              @max_day = data1[0]
            end
            if data1[3]&.size.to_i.positive? && data1[3]&.to_i <= @min_temp.to_i
              @min_temp = data1[3]
              @min_day = data1[0]
            end
          end
        end
      end
    end
    display("Max Temperature: #{@max_temp} and Day is: #{@max_day}\nMin Temperature: #{@min_temp} and Day is: #{@min_day}\n")
  end

  def choice_two_temp
    puts "Enter Month:"
    input = gets.chomp
    input = input.split "/"
    $year = input[0]
    $month = input[1].to_i - 1
    max_data_count = 0
    max_sum = 0
    min_data_count = 0
    min_sum = 0
    for totalfiles in 0..2 
      totalfiles == 0 ? limit = 1 : limit = 0 
      tt = "#{FILES[totalfiles]}_#{$year}_#{MONTHS[$month.to_i]}.txt"
      tempdata = []
      tempdata = File.readlines("./#{FILES[totalfiles]}/#{tt}") if File.exist?("./#{FILES[totalfiles]}/#{tt}")
      for i in 0..tempdata&.size
        if (i > limit && tempdata[i])
          data1 = tempdata[i].split ","
          if data1[1]&.size.to_i.positive? 
            max_sum += data1[1].to_i
            max_data_count += 1
          end
          if data1[3]&.size.to_i.positive?
            min_sum += data1[3].to_i
            min_data_count += 1
          end
        end
      end
    end
    max_avg = max_sum / max_data_count
    min_avg = min_sum / min_data_count
    display("Avg Max Temperature: #{max_avg} C\nAvg Min Temperature: #{min_avg} C\n")
  end

  def choice_three_temp
    puts "Enter Month:"
    input = gets.chomp
    input = input.split "/"
    $year = input[0]
    $month = input[1].to_i - 1
    max_data_hash = Hash.new
    min_data_hash = Hash.new
    for totalfiles in 0..2 
      totalfiles == 0 ? limit = 1 : limit = 0
      tt = "#{FILES[totalfiles]}_#{$year}_#{MONTHS[$month.to_i]}.txt"
      tempdata = []
      tempdata = File.readlines("./#{FILES[totalfiles]}/#{tt}") if File.exist?("./#{FILES[totalfiles]}/#{tt}")
      for i in 0..tempdata&.size
        if (i > limit && tempdata[i])
          data1 = tempdata[i].split ","
          if data1[1]&.size.to_i.positive?
            key = data1[0].split "-"
            if max_data_hash[key[2]] == nil
              max_data_hash.store(key[2], data1[1])
            else
              max_data_hash[key[2]] = data1[1] if data1[1].to_i > max_data_hash[key[2]].to_i
            end
          end
          if data1[3]&.size.to_i.positive? 
            key = data1[0].split "-"
            if min_data_hash[key[2]] == nil
              min_data_hash.store(key[2], data1[3])
            else
              min_data_hash[key[2]] = data1[3] if data1[3].to_i < min_data_hash[key[2]].to_i
            end
          end
        end
      end
    end
    display_choice3(max_data_hash, min_data_hash)
  end
end

# This is a class for Temprature related stuff
class Humidity < WeatherMan
  def initialize
    @max_hum = -9999
    @min_temp = 9999
    @max_hum_day = ""
    @min_day = ""
    super
    choice_one_hum if $choice == 1
    choice_two_hum if $choice == 2
  end

  def choice_one_hum
    for totalfiles in 0..2 
      totalfiles == 0 ? limit = 1 : limit = 0 
      for totalmonths in 0..11 
        tt = "#{FILES[totalfiles]}_#{$year}_#{MONTHS[totalmonths]}.txt"
        tempdata = []
        tempdata = File.readlines("./#{FILES[totalfiles]}/#{tt}") if File.exist?("./#{FILES[totalfiles]}/#{tt}")
        for i in 0..tempdata&.size
          if (i > limit && tempdata[i])
            data1 = tempdata[i].split ","
            if data1[7]&.size.to_i.positive? && data1[7]&.to_i >= @max_hum.to_i
              @max_hum = data1[7]
              @max_hum_day = data1[0]
            end
          end
        end
      end
    end
    puts "Max Humidity: #{@max_hum} and Day is: #{@max_hum_day}"
  end

  def choice_two_hum
    hum_data_count = 0
    hum_sum = 0
    for totalfiles in 0..2
      totalfiles == 0 ? limit = 1 : limit = 0 
      tt = "#{FILES[totalfiles]}_#{$year}_#{MONTHS[$month.to_i]}.txt"
      tempdata = []
      tempdata = File.readlines("./#{FILES[totalfiles]}/#{tt}") if File.exist?("./#{FILES[totalfiles]}/#{tt}")
      for i in 0..tempdata&.size
        if (i > limit && tempdata[i])
          data1 = tempdata[i].split ","
          if data1[8]&.size.to_i.positive? 
            hum_sum += data1[8].to_i
            hum_data_count += 1
          end
        end
      end
    end
    hum_avg = hum_sum / hum_data_count
    puts "Avg Humidity: #{hum_avg}%"
  end
end

# main
Temperature.new.menu
Humidity.new
