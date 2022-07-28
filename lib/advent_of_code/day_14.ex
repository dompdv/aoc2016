defmodule AdventOfCode.Day14 do
  def next1(salt, counter), do: :erlang.md5("#{salt}#{counter}") |> Base.encode16(case: :lower)

  def next2(salt, counter),
    do:
      Enum.reduce(
        1..2016,
        :erlang.md5("#{salt}#{counter}") |> Base.encode16(case: :lower),
        fn _, a ->
          :erlang.md5(a) |> Base.encode16(case: :lower)
        end
      )

  def find_match(q, m) do
    m = String.duplicate(m, 5)
    Enum.any?(:queue.to_list(q), fn h -> String.contains?(h, m) end)
  end

  def accumulate(_q, _counter, digits, _salt, _next) when length(digits) == 64, do: digits

  def accumulate(q, counter, digits, salt, next) do
    hash = :queue.head(q)
    q = :queue.tail(q)

    case Regex.run(~r/(.)\1\1/, hash) do
      [_, m] ->
        if find_match(q, m),
          do:
            accumulate(
              :queue.snoc(q, next.(salt, counter)),
              counter + 1,
              [counter - 1001 | digits],
              salt,
              next
            ),
          else: accumulate(:queue.snoc(q, next.(salt, counter)), counter + 1, digits, salt, next)

      _ ->
        accumulate(:queue.snoc(q, next.(salt, counter)), counter + 1, digits, salt, next)
    end
  end

  def exec(salt, next) do
    {q, counter} =
      Enum.reduce(
        0..1000,
        {:queue.new(), 0},
        fn _, {q, counter} -> {:queue.snoc(q, next.(salt, counter)), counter + 1} end
      )

    accumulate(q, counter, [], salt, next)
  end

  def part1(_args), do: exec("zpqevtbw", &next1/2)

  def part2(_args), do: exec("abc", &next2/2)
end
