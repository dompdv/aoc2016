defmodule AdventOfCode.Day22 do
  import Enum

  @pattern ~r/\/dev\/grid\/node-x([0-9]+)-y([0-9]+)\s*([0-9]+)T\s*([0-9]+)T\s*([0-9]+)T\s*([0-9]+)%/

  def parse_line(line) do
    [x, y, size, used, avail, usedp] =
      Regex.run(@pattern, line, capture: :all_but_first) |> map(&String.to_integer/1)

    {{x, y}, {size, used, avail, usedp}}
  end

  def parse(args),
    do: String.split(args, "\n", trim: true) |> Enum.drop(2) |> map(&parse_line/1) |> Map.new()

  def part1(args) do
    nodes = parse(args)

    for(
      {n1, {_s1, u1, _a1, _}} <- nodes,
      {n2, {_s2, _u2, a2, _}} <- nodes,
      n1 != n2,
      u1 > 0,
      u1 <= a2,
      do: 1
    )
    |> sum()
  end

  def part2(args) do
    nodes = parse(args)
    max_x = Enum.max(for {x, _} <- Map.keys(nodes), do: x)
    max_y = Enum.max(for {_, y} <- Map.keys(nodes), do: y)
    {max_x, max_y}
  end
end
