defmodule Elements do
 def get_elem(tuple, index), do: elem(tuple, index)
 def replace(tuple, index, new_item) do
   put_elem(tuple, index, new_item)
 end
end

a_tuple = {22, "original", 47.6, true}

# this does not change the original tuple
result = Elements.replace(a_tuple, 1, "new")
IO.inspect(result) #=> {22, "new", 47.6, true}
IO.inspect(a_tuple) #=> {22, "original", 47.6, true}

# this creates a new version of 'a_tuple' (the old one becomes garbage for collection)
a_tuple = Elements.replace(a_tuple, 1, "new")
IO.inspect(a_tuple) #=> {22, "new", 47.6, true}

# Note need to use inspect, not puts, to show contents of tuple
