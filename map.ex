car = %{make: "Ford", type: "coupe", cc: 2000}

IO.puts(car.cc)

new_car = %{car | cc: 2600}

IO.puts(new_car.cc)

car = %{car | cc: 3000}

IO.puts(car.cc)

car = Map.put(car, :color, "blue")

IO.puts(car.color)

IO.inspect(car)
