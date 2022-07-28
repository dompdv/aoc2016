defmodule AdventOfCode.Day14 do
  def next(salt, counter), do: :erlang.md5("#{salt}#{counter}") |> Base.encode16(case: :lower)

  def find_match(q, m) do
    m = String.duplicate(m, 5)
    Enum.any?(:queue.to_list(q), fn h -> String.contains?(h, m) end)
  end

  def accumulate(_q, _counter, digits, _salt) when length(digits) == 64, do: Enum.reverse(digits)

  def accumulate(q, counter, digits, salt) do
    hash = :queue.head(q)
    q = :queue.tail(q)

    case Regex.run(~r/(.)\1\1/, hash) do
      [_, m] ->
        if find_match(q, m) do
          # IO.inspect(counter - 1001)
          accumulate(:queue.snoc(q, next(salt, counter)), counter + 1, [m | digits], salt)
        else
          accumulate(:queue.snoc(q, next(salt, counter)), counter + 1, digits, salt)
        end

      _ ->
        accumulate(:queue.snoc(q, next(salt, counter)), counter + 1, digits, salt)
    end
  end

  def part1(_args) do
    salt = "zpqevtbw"

    {q, counter} =
      Enum.reduce(
        0..1000,
        {:queue.new(), 0},
        fn _, {q, counter} -> {:queue.snoc(q, next(salt, counter)), counter + 1} end
      )

    accumulate(q, counter, [], salt)
  end

  def part2(_args) do
  end
end
