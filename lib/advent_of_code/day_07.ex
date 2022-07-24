defmodule AdventOfCode.Day07 do
  import Enum

  def is_abba([a, b, b, a | _]) when a != b, do: true
  def is_abba([_a | r]), do: is_abba(r)
  def is_abba(_), do: false

  def analyze_line(line) do
    {found_outside, ok_inside} =
      reduce(
        line
        |> String.split(["[", "]"], trim: true)
        |> with_index(),
        {false, true},
        fn {bloc, index}, {found_outside, ok_inside} ->
          cond do
            rem(index, 2) == 0 and found_outside -> {true, ok_inside}
            rem(index, 2) == 0 -> {is_abba(to_charlist(bloc)), ok_inside}
            ok_inside -> {found_outside, not is_abba(to_charlist(bloc))}
            true -> {found_outside, ok_inside}
          end
        end
      )

    found_outside and ok_inside
  end

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> map(&analyze_line/1)
    |> count(& &1)
  end

  def collect_aba([a, b, a | r], acc) when a != b, do: collect_aba([b, a | r], [[b, a, b] | acc])
  def collect_aba([_x | r], acc), do: collect_aba(r, acc)
  def collect_aba([], acc), do: acc

  def analyze_line2(line) do
    %{0 => supernet, 1 => hypernet} =
      line
      |> String.split(["[", "]"], trim: true)
      |> with_index()
      |> group_by(fn {_, i} -> rem(i, 2) end, fn {e, _} -> e end)

    abas =
      reduce(supernet, [], fn bloc, acc -> collect_aba(to_charlist(bloc), acc) end)
      |> map(&to_string/1)

    any?(for aba <- abas, bloc <- hypernet, do: String.contains?(bloc, aba))
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> map(&analyze_line2/1)
    |> count(& &1)
  end
end
