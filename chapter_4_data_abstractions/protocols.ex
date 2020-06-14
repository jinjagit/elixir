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
IO.inspect(todo_list)

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
