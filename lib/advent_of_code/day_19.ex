defmodule AdventOfCode.Day19 do
  def play(1, q), do: :queue.head(q) |> elem(0)

  def play(l, q) do
    {elf, n} = :queue.head(q)
    q = :queue.tail(q)

    if n == 0 do
      play(l - 1, q)
    else
      {_next_elf, next_n} = :queue.head(q)
      q = :queue.tail(q)
      play(l - 1, :queue.snoc(q, {elf, n + next_n}))
    end
  end

  def part1(_args) do
    starting_circle =
      Enum.reduce(1..3_012_210, :queue.new(), fn e, q -> :queue.snoc(q, {e, 1}) end)

    play(:queue.len(starting_circle), starting_circle)
  end

  def play2(<<c::24>>, 1), do: c

  def play2(circle, l) do
    cut = div(l, 2)
    low = :erlang.binary_part(circle, 0, 3 * cut)
    high = :erlang.binary_part(circle, 3 * cut, 3 * l - 3 * cut)
    <<elf::24, left::binary>> = low
    <<_::24, r::binary>> = high
    play2(left <> r <> <<elf::24>>, l - 1)
  end

  def part2(_args) do
    players = 3_012_210
    starting = for(i <- 1..players, do: <<i::24>>) |> :binary.list_to_bin()
    play2(starting, players)
  end
end
