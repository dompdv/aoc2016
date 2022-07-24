defmodule AdventOfCode.Day05 do
  def find_next(s, n) do
    Stream.iterate(n, &(&1 + 1))
    |> Enum.reduce_while(nil, fn index, _ ->
      code = :erlang.md5("#{s}#{index}") |> Base.encode16(case: :lower)

      if String.slice(code, 0..4) == "00000",
        do: {:halt, {index, String.at(code, 5), String.at(code, 6)}},
        else: {:cont, nil}
    end)
  end

  def part1(args) do
    Enum.reduce(1..8, {0, []}, fn _, {index, digits} ->
      {index, digit, _} = find_next(args, index)
      {index + 1, [digit | digits]}
    end)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join()
  end

  def part2(args) do
    digits =
      Stream.cycle([nil])
      |> Enum.reduce_while(
        {0, %{}},
        fn _, {index, digits} ->
          {index, position, digit} = find_next(args, index)
          position = (String.to_charlist(position) |> List.first()) - ?0

          if Map.has_key?(digits, position) or position > 7 do
            {:cont, {index + 1, digits}}
          else
            new_digits = Map.put(digits, position, digit)

            if map_size(new_digits) == 8,
              do: {:halt, new_digits},
              else: {:cont, {index + 1, new_digits}}
          end
        end
      )

    for(i <- 0..7, do: digits[i]) |> Enum.join()
  end
end
