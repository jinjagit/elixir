car = %{make: "Ford", type: "coupe", cc: 2000}

IO.puts(car.cc) #=> 2000

new_car = %{car | cc: 2600}

IO.puts(new_car.cc) #=> 2600

car = %{car | cc: 3000}

IO.puts(car.cc) #=> 3000

car = Map.put(car, :color, "blue")

IO.puts(car.color) #=> blue

IO.inspect(car) #=> %{cc: 3000, color: "blue", make: "Ford", type: "coupe"}
