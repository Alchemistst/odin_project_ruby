class Vehicle
  @@number_of_vehicles = 0
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @@number_of_vehicles += 1
    @speed = 0
    @year = year
    @color = color
    @model = model
  end

  def self.total_number_of_vehicles
    puts "There are #{@@number_of_vehicles} vehicles so far"
  end

  def speed_up(speed_increase)
    self.speed += speed_increase
  end

  def break(speed_decrease)
    self.speed -= speed_decrease
  end

  def shut_off
    self.speed = 0
  end

  def self.gas_mileage(galons, miles)
    miles / galons
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def age
    puts "This vehicle is #{current_age} year old"
  end

  private

  def current_age
    Time.new.year - year
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4

  def to_s
    "Car info: model #{model}, year #{year}, color #{color}, current speed #{speed}"
  end
end

module Honkable
  def honk
    puts 'Hooooooooooonk!'
  end
end

class MyTruck < Vehicle
  include Honkable
  NUMBER_OF_DOORS = 2
end

clio = MyCar.new(2015, 'white', 'Clio')
truck = MyTruck.new(2024, 'black', 'Man')

# Class variables examples
Vehicle.total_number_of_vehicles

# Modules examples
truck.honk

# Method lookups
puts 'Car ancestors > '
puts MyCar.ancestors
puts '-----------'
puts 'Truckl ancestors > '
puts MyTruck.ancestors

puts clio.age
puts truck.age
