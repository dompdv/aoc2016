defmodule AdventOfCode.Day09 do
  def decompress(args), do: decompress("", args)

  def decompress(current, to_analyze) do
    case Regex.run(~r/(\w*)\((\d+)x(\d+)\)(.*)/, to_analyze, capture: :all_but_first) do
      nil ->
        current <> to_analyze

      [left, next_character_length, times, rest] ->
        next_character_length = String.to_integer(next_character_length)
        times = String.to_integer(times)
        to_duplicate = String.slice(rest, 0, next_character_length)

        decompress(
          current <> left <> String.duplicate(to_duplicate, times),
          String.slice(rest, next_character_length..-1)
        )
    end
  end

  def part1(args) do
    decompress(args) |> String.length()
  end

  def decompress2(args), do: decompress2(0, args)

  def decompress2(current, to_analyze) do
    case Regex.run(~r/(\w*)\((\d+)x(\d+)\)(.*)/, to_analyze, capture: :all_but_first) do
      nil ->
        current + String.length(to_analyze)

      [left, next_character_length, times, rest] ->
        next_character_length = String.to_integer(next_character_length)
        times = String.to_integer(times)
        to_duplicate = String.slice(rest, 0, next_character_length) |> decompress2()

        decompress2(
          current + String.length(left) + to_duplicate * times,
          String.slice(rest, next_character_length..-1)
        )
    end
  end

  def part2(args) do
    decompress2(args)
  end
end
