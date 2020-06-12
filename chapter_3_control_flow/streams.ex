# Streams are a special kind of enumerables that can be useful for doing
# lazy composable operations over anything enumerable.

# Example. Given the following list

employees = ["Alice", "Bob", "John"]

# we wish to produce:
#   1. Alice
#   2. Bob
#   3. John

IO.inspect(Enum.with_index(employees)) #=> [{"Alice", 0}, {"Bob", 1}, {"John", 2}]

employees
|> Enum.with_index
|> Enum.each(
  fn({employee, index}) ->
    IO.puts "#{index + 1}. #{employee}"
  end)  #=> 1. Alice
        #=> 2. Bob
        #=> 3. John

# Note, in the iex shell, the pipeline operator should be placed at the end of
# preceding line(s), to let the shell know that more is to follow.

# So what’s the problem with this code? Essentially, it iterates too much.
# The Enum.with_index/1 function goes through the entire list to produce
# another list with tuples, and Enum.each then performs another iteration
# through the new list. Obviously, it would be better if you could do both
# operations in a single pass. Stream functions take any enumerable as an input
# and give back a stream: an enumerable with some special powers.

 # A stream is a lazy enumerable, which means it produces the actual result
 # on demand.

stream = [1, 2, 3]
|> Stream.map(fn(x) -> 2 * x end)

IO.inspect(stream) #=> #Stream<[enum: [1, 2, 3], funs: [#Function<48.35876588/1 in Stream.map/2>]]>

# The result of Stream.map is a stream
# To make the iteration happen, you have to send the stream to an Enum function,
# such as each, map, or filter.

IO.inspect(
  Enum.to_list(stream)
) #=> [2, 4, 6]

# Stream.with_index can be used for the original employye list example:

employees
|> Stream.with_index
|> Enum.each(
  fn ({employee, index}) ->
    IO.puts "#{index + 1}. #{employee}"
  end)  #=> 1. Alice
        #=> 2. Bob
        #=> 3. John

# The output is the same, but the list iteration is done only once.


# The following example takes the input list and prints the square root of only
# those elements that represent a non-negative number, adding an indexed prefix
# at the beginning:

[9, -1, "foo", 25, 49]
|> Stream.filter(&(is_number(&1) and &1 > 0)) #=> filter only positive numbers
|> Stream.map(&{&1, :math.sqrt(&1)}) #=> create {input_number, square_root} tuples
|> Stream.with_index                 #=> index resulting tuples
|> Enum.each(                        #=> iterate through stream to print results
    fn({{input, result}, index}) ->
      IO.puts "#{index + 1}. sqrt(#{input}) = #{result}"
    end
  ) #=> 1. sqrt(9) = 3.0
    #=> 2. sqrt(25) = 5.0
    #=> 3. sqrt(49) = 7.0

# Even though multiple transformations are stacked, everything is performed in
# a single pass when Enum.each is called. This can be significantly faster and
# less memory demanding than using multiple Enum functions to do the same.


# Using streams makes it possible to read and immediately parse one line of a
# file at a time. For example, the following function takes a filename and
# returns a list of all lines from that file that are longer than 80 characters:

defmodule LineLen do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end
end

IO.inspect(LineLen.large_lines!("streams.ex"))
#=> ["IO.inspect(Enum.with_index(employees)) #=> [{\"Alice\", 0}, {\"Bob\", 1},
#     {\"John\", 2}]",
#=> "IO.inspect(stream) #=> #Stream<[enum: [1, 2, 3], funs:
#     [#Function<48.35876588/1 in Stream.map/2>]]>",
#=> "|> Stream.map(&{&1, :math.sqrt(&1)}) #=> create {input_number,
#     square_root} tuples"]
#=> "# THIS IS THE EXAMPLE LONGEST LINE - xxxxxxxxxxxxxxxx ..."

# Here you rely on the File.stream!/1 function, which takes a path of the file
# and returns a stream of its lines. Because the result is a stream,
# the iteration through the file happens only when you request it.
# So after File.stream! returns, no byte from the file has been read yet.
# Then you remove the trailing newline character from each line, again in the
# lazy manner.
# Finally, you eagerly take only long lines, using Enum.filter/2. It’s at this
# point that iteration happens. The consequence is that you never read the
# entire file in memory; instead, you work on each line individually.

# rewrite of above module, using full lambda syntax (for practice):

defmodule LineLen2 do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(fn(x) -> String.replace(x, "\n", "") end)
    |> Enum.filter(fn(x) -> String.length(x) > 80 end)
  end
end

IO.inspect(LineLen2.large_lines!("streams.ex"))
#=> ["IO.inspect(Enum.with_index(employees)) #=> [{\"Alice\", 0}, {\"Bob\", 1},
#     {\"John\", 2}]",
#=> "IO.inspect(stream) #=> #Stream<[enum: [1, 2, 3], funs:
#     [#Function<48.35876588/1 in Stream.map/2>]]>",
#=> "|> Stream.map(&{&1, :math.sqrt(&1)}) #=> create {input_number,
#     square_root} tuples"]
#=> "# THIS IS THE EXAMPLE LONGEST LINE - xxxxxxxxxxxxxxxx ..."


# Practice exercises:

# Using large_lines!/1 as a model, write the following function(s):

# 1. lines_lengths!/1 that takes a file path and returns a list of numbers,
# with each number representing the length of the corresponding line from the
# file.
# 2. longest_line_length!/1 that returns the length of the longest line in a
# file.
# 3. longest_line!/1 that returns the contents of the longest line in a file.
# 4. words_per_line!/1 that returns a list of numbers, with each number
# representing the word count in a file. Hint: to get the word count of a line,
# use length(String.split(line)).

# THIS IS THE EXAMPLE LONGEST LINE - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

defmodule FileStuff do
  defp lines_stream!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end


  def lines_lengths!(path) do
    lines_stream!(path)
    |> Enum.map(&String.length(&1))
  end

  def longest_line_length!(path) do
    lines_stream!(path)
    |> Stream.map(&String.length(&1))
    |> Enum.max()
  end

  def longest_line!(path) do
    lines_stream!(path)
    |> Enum.max_by(&String.length(&1)) # I cheated here. Did not know the .max_by command
  end

  def words_per_line!(path) do
    lines_stream!(path)
    |> Enum.map(&length(String.split(&1)))
  end

  def total_words!(path) do
    lines_stream!(path)
    |> Stream.map(&length(String.split(&1)))
    |> Enum.sum()
  end

  def print_total(path) do
    IO.puts "Total words: #{total_words!(path)}"
  end
end

IO.inspect(FileStuff.lines_lengths!("streams.ex")) #=> [72, 54, 0, 35, 0, ...]
IO.inspect(FileStuff.longest_line_length!("streams.ex")) #=> 108
IO.inspect(FileStuff.longest_line!("streams.ex"))
#=> "#THIS IS THE EXAMPLE LONGEST LINE - xxxxxxxxxxxxxxxx ..."
IO.inspect(FileStuff.words_per_line!("streams.ex")) #=> [14, 7, 0, 6, 0, ...]
IO.inspect(FileStuff.total_words!("streams.ex")) #=> 954
FileStuff.print_total("streams.ex") #=> Total words: 954
