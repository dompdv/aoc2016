defmodule AdventOfCode.Day02 do
  import Enum

  @graph_p1 %{
    ?U => %{1 => 1, 2 => 2, 3 => 3, 4 => 1, 5 => 2, 6 => 3, 7 => 4, 8 => 5, 9 => 6},
    ?D => %{1 => 4, 2 => 5, 3 => 6, 4 => 7, 5 => 8, 6 => 9, 7 => 7, 8 => 8, 9 => 9},
    ?L => %{1 => 1, 2 => 1, 3 => 2, 4 => 4, 5 => 4, 6 => 5, 7 => 7, 8 => 7, 9 => 8},
    ?R => %{1 => 2, 2 => 3, 3 => 3, 4 => 5, 5 => 6, 6 => 6, 7 => 8, 8 => 9, 9 => 9}
  }
  @graph_p2 %{
    ?U => %{
      1 => 1,
      2 => 2,
      3 => 1,
      4 => 4,
      5 => 5,
      6 => 2,
      7 => 3,
      8 => 4,
      9 => 9,
      ?A => 6,
      ?B => 7,
      ?C => 8,
      ?D => ?B
    },
    ?D => %{
      1 => 3,
      2 => 6,
      3 => 7,
      4 => 8,
      5 => 5,
      6 => ?A,
      7 => ?B,
      8 => ?C,
      9 => 9,
      ?A => ?A,
      ?B => ?D,
      ?C => ?C,
      ?D => ?D
    },
    ?L => %{
      1 => 1,
      2 => 2,
      3 => 2,
      4 => 3,
      5 => 5,
      6 => 5,
      7 => 6,
      8 => 7,
      9 => 8,
      ?A => ?A,
      ?B => ?A,
      ?C => ?B,
      ?D => ?D
    },
    ?R => %{
      1 => 1,
      2 => 3,
      3 => 4,
      4 => 4,
      5 => 6,
      6 => 7,
      7 => 8,
      8 => 9,
      9 => 9,
      ?A => ?B,
      ?B => ?C,
      ?C => ?C,
      ?D => ?D
    }
  }

  def walk(args, graph) do
    args
    |> String.split("\n", trim: true)
    |> map(&String.to_charlist/1)
    |> reduce({5, []}, fn l, {pos, digits} ->
      new_pos = reduce(l, pos, fn d, p -> graph[d][p] end)
      {new_pos, [new_pos | digits]}
    end)
    |> elem(1)
    |> reverse()
  end

  def part1(args) do
    walk(args, @graph_p1)
  end

  def part2(args) do
    walk(args, @graph_p2) |> map(fn c -> if c < 10, do: c + ?0, else: c end) |> to_string()
  end
end
