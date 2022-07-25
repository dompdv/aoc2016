defmodule Mix.Tasks.D09.P2 do
  use Mix.Task

  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 2"
  def run(args) do
    input = "A(1x5)BC"
    input = "(3x3)XYZ"
    input = "ADVENT"
    input = "A(2x2)BCD(2x2)EFG"
    input = "(6x1)(1x3)A"
    input = "X(8x2)(3x3)ABCY"
    input = AdventOfCode.Input.get!(9, 2016)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
