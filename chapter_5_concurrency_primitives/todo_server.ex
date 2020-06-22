# Example in book throws error unless my line 13 IO command is added!

defmodule TodoServer do
  def start do
    spawn(fn ->
      Process.register(self(), :todo_server)
      loop(TodoList.new())
    end)
  end

  def add_entry(new_entry) do
    # Weirdly, this throws an argument error, if the IO command is not run first
    IO.inspect(new_entry)
    send(:todo_server, {:add_entry, new_entry})
  end

  def entries(date) do
    send(:todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        message -> process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end

  defp process_message(todo_list, _), do: todo_list
end

defmodule TodoList do
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

TodoServer.start
TodoServer.add_entry(%{date: {2020, 6, 20}, title: "Dentist"})
#=> %{date: {2020, 6, 20}, title: "Dentist"}
TodoServer.add_entry(%{date: {2020, 6, 19}, title: "Movies"})
#=> %{date: {2020, 6, 19}, title: "Movies"}
TodoServer.add_entry(%{date: {2020, 6, 20}, title: "Shopping"})
#=> %{date: {2020, 6, 20}, title: "Shopping"}

entries = TodoServer.entries({2020, 6, 20})
IO.inspect(entries)
#=> [
#=>   %{date: {2020, 6, 20}, id: 1, title: "Dentist"},
#=>   %{date: {2020, 6, 20}, id: 3, title: "Shopping"}
#=> ]
