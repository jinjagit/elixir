# Polymorphism is a runtime decision about which code to execute, based on the
# nature of the input data. In Elixir, the basic (but not the only) way of doing
# this is by using the language feature called protocols.

Enum.each([1, 2, 3], &IO.puts/1)
Enum.each(1..3, &IO.puts/1)
map = %{a: 1, b: 2, c: 3}
Enum.each(map, &IO.inspect/1)

# Enum.each/2 is generic and relies on a protocol to know how to walk through
# different data structures.

# A protocol is a module in which you declare functions without implementing
# them, using defprotocol similarly to defmodule.
# If the protocol isn’t implemented for the given data type, an error is raised:

todo_list = TodoList.new_from_file("todos.csv") # uses module from compiled beam file

# IO.puts(todo_list) #=> ** (Protocol.UndefinedError) protocol String.Chars not implemented for %TodoList{ ... }

# Implementing a protocol:

# String.Chars is a defined protocol (but not for our %TodoList{} struct)
#
# Here is the implementation of String.Chars for integers:
#   defimpl String.Chars, for: Integer do
#     def to_string(thing) do
#       Integer.to_string(thing)
#     end
#   end

defimpl String.Chars, for: TodoList do
  def to_string(_) do
    "#TodoList" # OR some more sophisticated processing of the struct
  end
end

IO.puts(todo_list) #=> #TodoList

# It’s important to notice that the protocol implementation doesn’t need to be
# part of any module. This has powerful consequences: you can implement a
# protocol for a type even if you can’t modify the type’s source code.
# You can place the protocol implementation anywhere in your own code, and the
# runtime will be able to take advantage of it.

# a protocol dispatch may in some cases be significantly slower than a direct
# function call. A protocol consolidation will speed things up (Chapter 14).

# See 4.3.3 for information on built-in protocols, (e.g. Access, Enumerable),
# and some advice on how to implement for non-standard structures (e.g. structs)


# Collectable to-do list:

# A collectable structure is one that you can repeatedly add elements to.
# A collectable can be used with comprehensions to collect results or with
# Enum.into/2 to transfer elements of one structure (enumerable) to another
# (collectable).

# Making TodoList abstraction a collectable, by implementing Collectable for it:

defimpl Collectable, for: TodoList do
  def into(original) do # returns the appender lambda
    {original, &into_callback/2}
  end

  # appender implementation (all 3 defp functions)
  defp into_callback(todo_list, {:cont, entry}) do
    IO.puts("DEBUG: I am defp into_callback/2")
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok
end


defimpl Enumerable, for: TodoList do
  def count(todo_list \\ %{}) do
    # IO.puts("DEBUG: I am count/1")
    count_next(todo_list.entries, 0)
  end

  defp count_step(_entries, nil, count), do: {:ok, count}
  defp count_step(entries, pair, count) do
    {first_key, _val} = pair
    entries = Map.delete(entries, first_key)
    count = count + 1
    # IO.puts(count)
    count_next(entries, count)
  end

  defp count_next(entries, count) do
    pair = Enum.at(entries, 0, nil)
    count_step(entries, pair, count)
  end


  def member?(todo_list, element) do
    if Map.has_key?(todo_list.entries, element) === true do
      {:ok, true}
    else
      {:ok, false}
    end
  end


  def slice(todo_list) do
    size = count(todo_list)
    {:ok, size, fn(x) -> Enum.at(todo_list.entries, x) end}
  end

  def reduce(todo_list, acc \\ 0, acc_fn) do
    Enum.reduce(todo_list.entries, acc, acc_fn)
  end
end

# The exported function into/1 is called by the generic code (comprehensions,
# for example). Here you provide the implementation that returns the appender
# lambda. This appender lambda is then repeatedly invoked by the generic code
# to append each element to your data structure.
# The appender function receives a to-do list and an instruction hint. If you
# receive {:cont, entry}, then you must add a new entry. If you receive :done,
# then you return the list, which at this point contains all appended elements.
# Finally, :halt indicates that the operation has been canceled, and the return
# value is ignored.

imported_data = TodoList.CsvImporter.parse!("todos.csv")

IO.inspect(imported_data)
#=> [
#=>  %{date: {2020, 6, 20}, title: "Dentist"},
#=>  %{date: {2020, 6, 19}, title: "Shopping"},
#=>  %{date: {2020, 6, 20}, title: "Movies"}
#=> ]

todo_list = for entry <- imported_data, into: TodoList.new, do: entry
IO.inspect(todo_list)
#=> %TodoList{
#=>   auto_id: 4,
#=>   entries: %{
#=>     1 => %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>     2 => %{date: {2020, 6, 19}, id: 2, title: "Shopping"},
#=>     3 => %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=>   }
#=> }

# By implementing the Collectable protocol, you essentially adapt the TodoList
# abstraction to any generic code that relies on the that protocol, such as
# comprehensions and Enum.into/2.
# Note that this does not mean that a call to Enum will now work, for example,
# since an implementation of Enumerable for TodoList has not been implemented.

#list = Enum.into(todo_list, []) #=> ** (Protocol.UndefinedError) protocol Enumerable not implemented for %TodoList{...}

# Enumerable protocol needs (minimum): count/1, member?/2, reduce/3, slice/1

# I have tried implementing the Enumerable protocol for TodoList, but this
# attempt has revealed I need to learn much more about how protocols are
# implemented, and how to understand documentation, before I can do this.

# These now work (and didn't before I implemented Enumerable protocol)
Enum.each(todo_list, fn(x) -> IO.inspect(x) end)
#=> {1, %{date: {2020, 6, 20}, id: 1, title: "Dentist"}}
#=> {2, %{date: {2020, 6, 19}, id: 2, title: "Shopping"}}
#=> {3, %{date: {2020, 6, 20}, id: 3, title: "Movies"}}

#IO.puts(Enum.count(todo_list)) #=> 3

# These still don't work:
# IO.inspect(Enum.slice(todo_list, 2, 1)) #=> ** (ArithmeticError) bad argument in arithmetic expression: {:ok, 3} - 2
# IO.inspect(Enum.at(todo_list, 2)) #=> ** (ArithmeticError) bad argument in arithmetic expression: {:ok, 3} - 2
# list = Enum.into(todo_list, []) #=> ** (FunctionClauseError) no function clause matching in :lists.reverse/1

# To see the pure data structure:
IO.puts(inspect(todo_list, structs: false))
