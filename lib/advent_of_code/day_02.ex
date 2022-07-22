defmodule AdventOfCode.Day02 do
  import Enum

  @graph %{
    ?U => %{1 => 1, 2 => 2, 3 => 3, 4 => 1, 5 => 2, 6 => 3, 7 => 4, 8 => 5, 9 => 6},
    ?D => %{1 => 4, 2 => 5, 3 => 6, 4 => 7, 5 => 8, 6 => 9, 7 => 7, 8 => 8, 9 => 9},
    ?L => %{1 => 1, 2 => 1, 3 => 2, 4 => 4, 5 => 4, 6 => 5, 7 => 7, 8 => 7, 9 => 8},
    ?R => %{1 => 2, 2 => 3, 3 => 3, 4 => 5, 5 => 6, 6 => 6, 7 => 8, 8 => 9, 9 => 9}
  }

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> map(&String.to_charlist/1)
    |> reduce({5, []}, fn l, {pos, digits} ->
      new_pos = reduce(l, pos, fn d, p -> @graph[d][p] end)
      {new_pos, [new_pos | digits]}
    end)
    |> elem(1)
    |> reverse()
  end

  def part2(args) do
  end
end
