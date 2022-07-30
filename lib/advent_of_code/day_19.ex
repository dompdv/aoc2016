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

  def init_circle(players) do
    for i <- 0..(players - 1),
        into: %{},
        do: {i, %{before: rem(players + i - 1, players), after: rem(i + 1, players)}}
  end

  def one_turn(current_elf_number, circle, l) do
    opposite_elf_number =
      Enum.reduce(1..div(l, 2), current_elf_number, fn _, e_number ->
        circle[e_number][:after]
      end)

    %{before: before_opposite_elf_number, after: after_opposite_elf_number} =
      circle[opposite_elf_number]

    before_opposite_elf = circle[before_opposite_elf_number]
    after_opposite_elf = circle[after_opposite_elf_number]

    new_circle =
      circle
      |> Map.put(
        before_opposite_elf_number,
        %{before_opposite_elf | after: after_opposite_elf_number}
      )
      |> Map.put(
        after_opposite_elf_number,
        %{after_opposite_elf | before: before_opposite_elf_number}
      )
      |> Map.delete(opposite_elf_number)

    {new_circle[current_elf_number][:after], new_circle, l - 1}
  end

  def play2(_elf, c, 1), do: (Map.keys(c) |> List.first()) + 1

  def play2(elf, circle, l) do
    if :rand.uniform() > 0, do: IO.inspect(l)
    {elf, circle, l} = one_turn(elf, circle, l)
    play2(elf, circle, l)
  end

  def part2(_args) do
    starting = init_circle(3_012_210)
    play2(0, starting, Enum.count(starting))
  end
end
