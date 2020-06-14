# Build a todo list by reading and parsing a CSV file, and iterating over the
# filtered contents of the file.

# This is a pactice exercise. See section 4.2.5 for details.

# 1. Copy/ paste TodoList from hierarchical.ex (devloped earlier in chapter 4)
# 2. Write TodoList.CsvImporter module to parse csv file to useable data format
# 3. Add iterative new/1 def, from 4.2.5 (listing 4.15), to TodoList module.

defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new

  def new, do: %TodoList{}

  def new(entries) do
    Enum.reduce(
      entries,
      %TodoList{}, # initial accumulator value
      fn(entry, todo_list_acc) ->
        add_entry(todo_list_acc, entry)
      end
    )
  end

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

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
  end

  def update_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id,
    updater_fn
  ) do
    case entries[entry_id] do
      nil -> todo_list # no entry returns unchanged list

    old_entry -> # entry exists, update and return modified list
      old_entry_id = old_entry.id
      new_entry = %{id: ^old_entry_id} = updater_fn.(old_entry) # nested match requires a map from result of updater lambda, which also contains the same id as the old entry
      new_entries = Map.put(entries, new_entry.id, new_entry)
      %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(%TodoList{entries: entries} = todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(entries, entry_id)}
  end

  defmodule CsvImporter do
    def parse!(path) do
      File.stream!(path)
      |> Stream.map(&String.replace(&1, "\n", ""))
      |> Stream.map(&String.replace(&1, ",", ""))
      |> Stream.map(&String.split(&1))
      |> Stream.map(
      fn([head | [hd | _tl]]) ->
        date = date_to_integers(head)
        %{date: date, title: hd}
      end
      )
      |> Enum.to_list()
    end

    def date_to_integers(string) do
      String.split(string, "/")
      |> Stream.map(&String.to_integer(&1))
      |> Enum.to_list
      |> List.to_tuple()
    end
  end

  def new_from_file(path) do
    CsvImporter.parse!(path)
    |> new()
  end
end

# Test it's all working as intended (no real error handling):

imported_data = TodoList.CsvImporter.parse!("todos.csv")

IO.inspect(imported_data)
#=> [
#=>  %{date: {2020, 6, 20}, title: "Dentist"},
#=>  %{date: {2020, 6, 19}, title: "Shopping"},
#=>  %{date: {2020, 6, 20}, title: "Movies"}
#=> ]

todo_list = TodoList.new(imported_data)
IO.inspect(todo_list)
#=> %TodoList{
#=>   auto_id: 4,
#=>   entries: %{
#=>     1 => %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>     2 => %{date: {2020, 6, 19}, id: 2, title: "Shopping"},
#=>     3 => %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=>   }
#=> }

todo_list = TodoList.new_from_file("todos.csv")
IO.inspect(todo_list)
#=> %TodoList{
#=>   auto_id: 4,
#=>   entries: %{
#=>     1 => %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>     2 => %{date: {2020, 6, 19}, id: 2, title: "Shopping"},
#=>     3 => %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=>   }
#=> }

todo_list = TodoList.new
IO.inspect(todo_list) #=> %TodoList{auto_id: 1, entries: %{}}

todo_list = TodoList.new_from_file("empty.csv")
IO.inspect(todo_list) #=> %TodoList{auto_id: 1, entries: %{}}


# My solution works. Below is the example solution from the book's github,
# with the TodoList module renamed to TodoList2, followed by an analysis of the
# differences (mostly; how the book solution is better).

defmodule TodoList2 do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)

    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end
end

defmodule TodoList2.CsvImporter do
  def import(file_name) do
    file_name
    |> read_lines
    |> create_entries
    |> TodoList.new()
  end

  defp read_lines(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp create_entries(lines) do
    lines
    |> Stream.map(&extract_fields/1)
    |> Stream.map(&create_entry/1)
  end

  defp extract_fields(line) do
    line
    |> String.split(",")
    |> convert_date
  end

  defp convert_date([date_string, title]) do
    {parse_date(date_string), title}
  end

  defp parse_date(date_string) do
    [year, month, day] =
      date_string
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    {:ok, date} = Date.new(year, month, day)
    date
  end

  defp create_entry({date, title}) do
    %{date: date, title: title}
  end
end


todo_list = TodoList2.CsvImporter.import("todos.csv")
IO.inspect(todo_list)
#=> %TodoList{
#=>   auto_id: 4,
#=>   entries: %{
#=>     1 => %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>     2 => %{date: {2020, 6, 19}, id: 2, title: "Shopping"},
#=>     3 => %{date: {2020, 6, 20}, id: 3, title: "Movies"}
#=>   }
#=> }


# CsvImporter module, differences:

# I included my CsvImporter module within the TodoList module, rather than at
# same level as TodoList, as the naming convention suggested this was what was
# intended. It seems either approach works. I guess, however, that total
# seperation is best practice, to enable seperation by file & by BEAM file per
# module.

# import/1 def included in this module, whereas I put a list_from_file/1 def
# in my TodoList module. This seems an arbitrary choice.

# Cleaner method of splitting line and streaming to definitions that parse date,
# using a Date.new def I was unaware of (too lazy to research). The method used
# also avoided my use of Enum.list in my parsing of the date string. This avoids
# an iteration over the data, and will be useful reference for other similar
# situations.

# Sends the result of a Stream operation directly to Todo.new/1, whereas I
# used Enum.list to create a list. This is somewhat obvious, since Todo.new/1
# begins with an Enum.reduce operation, and thus will resolve a Stream at this
# point. Developing my CsvImporter module first, in isolation, lead to this
# oversight, since I wanted to view the list (using IO.inspect()) and a stream
# is not so transparent.

# Thus, I included two iterations that were not necessary. No biggie in this
# example, but bad for large data sets.
