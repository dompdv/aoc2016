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

  def play2(_, 1, d), do: d

  def play2(elf, l, d) do
    # IO.inspect({elf, l, d})
    if :rand.uniform() > 0.99, do: IO.inspect(l)

    IO.inspect(l)

    {_, ordered, current_elf_index} =
      Enum.reduce(d, {0, %{}, nil}, fn {n_elf, _}, {index, acc, index_current_elf} ->
        found =
          case index_current_elf do
            nil -> if n_elf == elf, do: index, else: nil
            n -> n
          end

        {index + 1, Map.put(acc, index, n_elf), found}
      end)

    presents = :orddict.fetch(elf, d)
    opposite_index = rem(current_elf_index + div(l, 2), l)
    opposite_elf = ordered[opposite_index]

    next_elf = ordered[rem(current_elf_index + 1, l)]

    next_elf =
      if next_elf != opposite_elf, do: next_elf, else: ordered[rem(current_elf_index + 2, l)]

    presents_opposite = :orddict.fetch(opposite_elf, d)
    d = :orddict.erase(opposite_elf, d)
    d = :orddict.store(elf, presents + presents_opposite, d)
    if l == 2, do: play2(nil, 1, d), else: play2(next_elf, l - 1, d)
  end

  def part2(_args) do
    starting_circle = :orddict.from_list(for i <- 1..3_012_210, do: {i, 1})

    play2(1, :orddict.size(starting_circle), starting_circle)
  end
end
