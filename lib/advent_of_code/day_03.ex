defmodule AdventOfCode.Day03 do
  import Enum

  def check_triangle([a, b, c]), do: a + b > c and b + c > a and a + c > b

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> map(fn c -> String.split(c, " ", trim: true) |> map(&String.to_integer/1) end)
    |> filter(&check_triangle/1)
    |> count()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> map(fn c -> String.split(c, " ", trim: true) |> map(&String.to_integer/1) end)
    |> chunk_every(3)
    |> map(fn [[a, b, c], [d, e, f], [g, h, i]] ->
      [check_triangle([a, d, g]), check_triangle([b, e, h]), check_triangle([c, f, i])]
      |> count(fn c -> c end)
    end)
    |> sum()
  end
end
