defmodule Mix.Tasks.D20.P1 do
  use Mix.Task

  import AdventOfCode.Day20

  @shortdoc "Day 20 Part 1"
  def run(args) do
    input = """
    5-8
    0-2
    4-7
    """

    input = AdventOfCode.Input.get!(20, 2016)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
