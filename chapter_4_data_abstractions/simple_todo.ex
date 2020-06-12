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
  |> TodoList.add_entry({2020, 6, 20}, "Movies")

IO.inspect(
  todo_list
) #=> %{{2020, 6, 20} => ["Movies", "Dentist"], {2020, 6, 21} => ["Shopping"]}

IO.inspect(
  TodoList.entries(todo_list, {2020, 6, 20})
) #=> ["Movies", "Dentist"]
