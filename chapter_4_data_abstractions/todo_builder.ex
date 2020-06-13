# Build a todo list by reading and parsing a CSV file, and iterating over the
# filtered contents of the file.

# This is an exercise, based on the contents of chapter 4, from 4.2.4 onwards.

defmodule TodoList.CsvImporter do
  def parse!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.replace(&1, ",", ""))
    |> Stream.map(&String.split(&1))
    |> Stream.map(
    fn([head | [hd | _tail]]) ->
      date = format_date(head)
      %{date: date, title: hd}
    end
    )
    |> Enum.to_list()
  end

  def format_date(string) do
    stream = String.split(string, "/")
    |> Stream.map(&String.to_integer(&1))
    |> Enum.to_list
    |> List.to_tuple()
  end
end

IO.inspect(
  TodoList.CsvImporter.parse!("todos.csv")
)
