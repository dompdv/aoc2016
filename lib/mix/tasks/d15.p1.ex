defmodule Mix.Tasks.D15.P1 do
  use Mix.Task

  import AdventOfCode.Day15

  @shortdoc "Day 15 Part 1"
  def run(args) do
    input = """
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
    """

    input = AdventOfCode.Input.get!(15, 2016)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
