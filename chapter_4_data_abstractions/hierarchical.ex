# working with hierarchical data

# Example here extends the simple_todo.ex example to brovide basic CRUD support.
# (C & R already exist, but will be developed)

# Updating and deleting entries requires ability to uniquely identify entries.

# generating IDs:

# need to transform the to-do list into a struct, as the data structure now
# needs to hold 2 pieces of info: the entries collection and the ID value for
# the next entry. This will facilitate quick insertion, update and read of
# individual entries:

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

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) ->
        entry.date == date
      end)
    |> Enum.map(fn({_, entry}) ->
        entry
      end)
  end

  def update_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id,
    updater_fn
  ) do
    case entries[entry_id] do
      nil -> todo_list

    old_entry ->
      new_entry = updater_fn.(old_entry)
      new_entries = Map.put(entries, new_entry.id, new_entry)
      %TodoList{todo_list | entries: new_entries}
    end
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

# filtering entries by date - TodoList.entries/2 now requires iteration
# through all the entries, rather than simply using Map.get to match a key.

IO.inspect(
  TodoList.entries(todo_list, {2020, 6, 20})
)
#=> [
#=>   %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>   %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=> ]

# Note that this refactoring (of add_entry/2 & entries/2) has also added
# runtime type checks that use pattern matching to explicity check that the
# first argument is an instance of the TodoList struct.

# updating an entry - update.entry/3:

# 2 options: accept an entry map and replace an entry if the same ID exists OR
# accept an ID value and an updater lamda, where the lambda receives the
# original entry and returns the modified version.
# This example uses the latter approach. It also does not raise an error if an
# entry with a given ID doesn't exist.

todo_list = TodoList.update_entry(
  todo_list,
  1,
  &Map.put(&1, :date, {2020, 6, 30})
)

IO.inspect(todo_list)
#=> %TodoList{
#=>   auto_id: 4,
#=>   entries: %{
#=>     1 => %{date: {2020, 6, 30}, id: 1, title: "Dentist"},
#=>     2 => %{date: {2020, 6, 21}, id: 2, title: "Shopping"},
#=>     3 => %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=>   }
#=> }

# Note, entry with id 1 now has new date.
