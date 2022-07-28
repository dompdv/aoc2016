defmodule AdventOfCode.Day15 do
  import Enum

  def parse(args) do
    reduce(
      String.split(args, "\n", trim: true),
      %{},
      fn line, acc ->
        [_, disc, total_pos, pos] =
          Regex.run(
            ~r/Disc #([0-9]+) has ([0-9]+) positions; at time=0, it is at position ([0-9]+)./,
            line
          )

        Map.put(acc, String.to_integer(disc), %{
          total: String.to_integer(total_pos),
          start_pos: String.to_integer(pos)
        })
      end
    )
  end

  def check_time(discs, t) do
    all?(
      for {disc, %{total: total, start_pos: start_pos}} <- discs,
          do: rem(start_pos + t + disc, total) == 0
    )
  end

  def find_right_time(discs) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.drop_while(fn i -> not check_time(discs, i) end)
    |> take(1)
  end

  def part1(args), do: find_right_time(parse(args))

  def part2(args) do
    discs = parse(args)

    Map.put(discs, count(discs) + 1, %{total: 11, start_pos: 0})
    |> find_right_time()
  end
end
