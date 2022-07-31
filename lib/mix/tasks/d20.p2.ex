defmodule Mix.Tasks.D20.P2 do
  use Mix.Task

  import AdventOfCode.Day20

  @shortdoc "Day 20 Part 2"
  def run(args) do
    input = """
    5-8
    0-2
    4-7
    """

    input = AdventOfCode.Input.get!(20, 2016)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
