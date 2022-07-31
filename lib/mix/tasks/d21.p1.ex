defmodule Mix.Tasks.D21.P1 do
  use Mix.Task

  import AdventOfCode.Day21

  @shortdoc "Day 21 Part 1"
  def run(args) do
    input = """
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
    """

    input = AdventOfCode.Input.get!(21, 2016)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
