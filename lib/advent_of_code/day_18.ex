defmodule AdventOfCode.Day18 do
  def transform([?^, ?^, ?.]), do: ?^
  def transform([?., ?^, ?^]), do: ?^
  def transform([?^, ?., ?.]), do: ?^
  def transform([?., ?., ?^]), do: ?^
  def transform(_), do: ?.

  def next_row(row), do: [?. | row] |> Enum.chunk_every(3, 1, [?.]) |> Enum.map(&transform/1)

  def count_safe(row), do: Map.get(Enum.frequencies(row), ?., 0)

  def room(first_row, rows),
    do:
      Enum.reduce(2..rows, {count_safe(first_row), first_row}, fn _, {counter, row} ->
        new_row = next_row(row)
        safe_tiles = count_safe(new_row)
        {counter + safe_tiles, new_row}
      end)

  def part1(args) do
    room(String.to_charlist(args), 40) |> elem(0)
  end

  def part2(args) do
  end
end
