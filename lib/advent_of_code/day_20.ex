defmodule AdventOfCode.Day20 do
  import Enum

  def parse(args) do
    String.split(args, "\n", trim: true)
    |> map(fn line ->
      [l, h] = String.split(line, "-", trim: true)
      {String.to_integer(l), String.to_integer(h)}
    end)
    |> Enum.sort()
  end

  def clean(intervals), do: clean(intervals, [])

  def clean([], acc), do: reverse(acc)

  def clean([it], acc), do: clean([], [it | acc])

  # Disjoints
  def clean([{_l1, h1} = it1, {l2, _h2} = it2 | r], acc) when h1 < l2,
    do: clean([it2 | r], [it1 | acc])

  # it1 englobe it2
  def clean([{l1, h1} = it1, {l2, h2} | r], acc) when l1 <= l2 and h1 >= h2,
    do: clean([it1 | r], acc)

  # it1 et it2 en intersection
  def clean([{l1, _h1}, {_l2, h2} | r], acc), do: clean([{l1, h2} | r], acc)

  def find_first_ip([], ip), do: ip
  def find_first_ip([{l, h} | r], ip) when l <= ip and ip <= h, do: find_first_ip(r, h + 1)
  def find_first_ip(_, ip), do: ip

  def count_ip([], ip, total, max_ip) when ip <= max_ip, do: total + max_ip - ip + 1
  def count_ip([], _ip, total, _max_ip), do: total

  def count_ip([{l, h} | r], ip, total, max_ip) when ip < l,
    do: count_ip(r, h + 1, total + l - ip, max_ip)

  def count_ip([{_l, h} | r], _ip, total, max_ip),
    do: count_ip(r, h + 1, total, max_ip)

  def part1(args), do: parse(args) |> clean() |> find_first_ip(0)

  def part2(args), do: parse(args) |> clean() |> count_ip(0, 0, 9)
end
