require "date"
require_relative "temperature"
require_relative "humidity"
require_relative "weather_man"
#main
temperature = Temperature.new
temperature.menu
temperature.select_temperature_action(temperature.user_input)
humidity = Humidity.new
humidity.year = temperature.year
humidity.month = temperature.month
humidity.select_humidity_action(temperature.user_input)
