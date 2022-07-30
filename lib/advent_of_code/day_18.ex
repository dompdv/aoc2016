defmodule AdventOfCode.Day18 do
  def detect_trap([?^, ?^, ?.]), do: ?^
  def detect_trap([?., ?^, ?^]), do: ?^
  def detect_trap([?^, ?., ?.]), do: ?^
  def detect_trap([?., ?., ?^]), do: ?^
  def detect_trap(_), do: ?.

  def detect_next_row(row),
    do: [?. | row] |> Enum.chunk_every(3, 1, [?.]) |> Enum.map(&detect_trap/1)

  def count_safe_tiles(row), do: Map.get(Enum.frequencies(row), ?., 0)

  def detect_room(first_row, rows),
    do:
      Enum.reduce(2..rows, {count_safe_tiles(first_row), first_row}, fn _, {counter, row} ->
        new_row = detect_next_row(row)
        safe_tiles = count_safe_tiles(new_row)
        {counter + safe_tiles, new_row}
      end)
      |> elem(0)

  def part1(args), do: detect_room(String.to_charlist(args), 40)

  def part2(args), do: detect_room(String.to_charlist(args), 400_000)
end
