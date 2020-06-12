# Note: Book uses HasDict in a basic example, but HashDict is deprecated in the
# elixir version I am using. I will use Map instead.

defmodule TodoList do
  def new, do: Map.new

  def add_entry(todo_list, date, title) do
    Map.update(
      todo_list,
      date,
      [title], # initial value
      fn(titles)-> [title | titles] end # updater lamda
    )
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end

todo_list =
  TodoList.new
  |> TodoList.add_entry({2020, 6, 20}, "Dentist")
  |> TodoList.add_entry({2020, 6, 21}, "Shopping")

todo_list = TodoList.add_entry(todo_list, {2020, 6, 20}, "Movies")

IO.inspect(
  todo_list
) #=> %{{2020, 6, 20} => ["Movies", "Dentist"], {2020, 6, 21} => ["Shopping"]}

IO.inspect(
  TodoList.entries(todo_list, {2020, 6, 20})
) #=> ["Movies", "Dentist"]


# Implementing a layer of abstraction:

defmodule MultiMap do
  def new, do: Map.new

  def add(map, key, value) do
    Map.update(
      map,
      key,
      [value],
      &[value | &1]
    )
  end

  def get(map, key) do
    Map.get(map, key, [])
  end
end

defmodule Todo do
  def new, do: MultiMap.new

  def add_entry(todo_list, date, title) do
    MultiMap.add(todo_list, date, title)
  end

  def entries(todo_list, date) do
    MultiMap.get(todo_list, date)
  end
end

todo_list =
  Todo.new
  |> Todo.add_entry({2020, 6, 20}, "Dentist")
  |> Todo.add_entry({2020, 6, 21}, "Shopping")

todo_list = Todo.add_entry(todo_list, {2020, 6, 20}, "Movies")

IO.inspect(
  todo_list
) #=> %{{2020, 6, 20} => ["Movies", "Dentist"], {2020, 6, 21} => ["Shopping"]}

IO.inspect(
  Todo.entries(todo_list, {2020, 6, 20})
) #=> ["Movies", "Dentist"]

# This is a classical separation of concerns, where you extract a distinct
# responsibility into a separate abstraction and then create another
# abstraction on top of it.

# BUT, if we wish to add a further field to our todo entries, we will need to
# rewrite the function signature(s), which will break the client. A solution is
# use a single map to represent a structure with named fields. We can do this
# by simply changing the .add_entry function:

defmodule Todo2 do
  def new, do: MultiMap.new

  def add_entry(todo_list, entry) do
    MultiMap.add(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiMap.get(todo_list, date)
  end
end

todo_list =
  Todo2.new
  |> Todo2.add_entry(%{date: {2020, 6, 20}, title: "Dentist"})

IO.inspect(todo_list) #=> %{{2020, 6, 20} => [%{date: {2020, 6, 20}, title: "Dentist"}]}

IO.inspect(
  Todo2.entries(todo_list, {2020, 6, 20})
) #=> [%{date: {2020, 6, 20}, title: "Dentist"}]

# This has the added advantage of returning the entire entry
