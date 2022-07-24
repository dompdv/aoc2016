defmodule AdventOfCode.Day06 do
  def sort_by_column(args) do
    Enum.reduce(
      String.split(args, "\n", trim: true) |> Enum.map(&to_charlist/1),
      %{},
      fn s, acc ->
        Enum.reduce(
          Enum.with_index(s),
          acc,
          fn {char, pos}, local_acc ->
            Map.update(local_acc, pos, [char], fn v -> [char | v] end)
          end
        )
      end
    )
  end

  def decrypt(args, function) do
    letters =
      for {k, v} <- sort_by_column(args), into: %{} do
        freq = Enum.frequencies(v)
        val = function.(Map.values(freq))

        {k,
         Enum.find(Map.to_list(freq), nil, fn {_letter, letter_freq} -> letter_freq == val end)
         |> elem(0)}
      end

    for i <- 0..(Enum.count(letters) - 1), do: letters[i]
  end

  def part1(args) do
    decrypt(args, &Enum.max/1)
  end

  def part2(args) do
    decrypt(args, &Enum.min/1)
  end
end
