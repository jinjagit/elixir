defmodule TestPrivate do
  def double(a) do
    sum(a, a)
  end

  defp sum(a, b) do
    a + b
  end
end

import IO

# double can be called as is not private

result = TestPrivate.double(7)

puts(result) #=> 14

# calling sum throws error:
result = TestPrivate.sum(1, 2) #=> TestPrivate.sum/2 is undefined or private

# puts(result)
