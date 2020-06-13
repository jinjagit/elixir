# working with hierarchical data

# Example here extends the simple_todo.ex example to brovide basic CRUD support.
# (C & R already exist)

# Updating and deleting entries requires ability to uniquely identify entries.

# generating IDs:

# need to transform the to-do list into a struct, as the data structure now
# needs to hold 2 piecesof info: the entries collection and the ID value for the
# next entry. This will facilitate quick insertion, upsate and read of
# individual entries

defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new

  def new, do: %TodoList{}

  def add_entry(
    %TodoList{entries: entries, auto_id: auto_id} = todo_list, entry
  ) do
    entry = Map.put(entry, :id, auto_id) # sets new entry's id
    new_entries = Map.put(entries, auto_id, entry) # adds entry to entries list

    %TodoList{todo_list |
    entries: new_entries,
    auto_id: auto_id + 1
    } # updates the struct
  end

end

todo_list =
  TodoList.new
  |> TodoList.add_entry(%{date: {2020, 6, 20}, title: "Dentist"})
  |> TodoList.add_entry(%{date: {2020, 6, 21}, title: "Shopping"})

todo_list = TodoList.add_entry(
  todo_list, %{date: {2020, 6, 20}, title: "Movies"}
)

IO.inspect(
  todo_list
)
#=> %TodoList{
#=>   auto_id: 4,
#=>   entries: %{
#=>     1 => %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>     2 => %{date: {2020, 6, 21}, id: 2, title: "Shopping"},
#=>     3 => %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=>   }
#=> }
