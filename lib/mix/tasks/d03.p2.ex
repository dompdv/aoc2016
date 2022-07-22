defmodule Mix.Tasks.D03.P2 do
  use Mix.Task

  import AdventOfCode.Day03

  @shortdoc "Day 03 Part 2"
  def run(args) do
    input = """
    101 301 501
    102 302 502
    103 303 503
    201 401 601
    202 402 602
    203 403 603
    """

    input = AdventOfCode.Input.get!(3, 2016)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
