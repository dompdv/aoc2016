defmodule AdventOfCode.Day21 do
  import Enum

  @patterns %{
    :rotate_l => ~r/rotate left ([0-9]+) step.*/,
    :rotate_r => ~r/rotate right ([0-9]+) step.*/,
    :swap_n => ~r/swap position ([0-9]+) with position ([0-9]+)/,
    :swap_l => ~r/swap letter (.+) with letter (.+)/,
    :move => ~r/move position ([0-9]+) to position ([0-9]+)/,
    :reverse => ~r/reverse positions ([0-9]+) through ([0-9]+)/,
    :rotate_by_letter => ~r/rotate based on position of letter (.+)/
  }

  def parse_line(line) do
    [{atom, pattern}] =
      Stream.drop_while(@patterns, fn {_, pattern} -> not Regex.match?(pattern, line) end)
      |> take(1)

    [atom | Regex.run(pattern, line, capture: :all_but_first)]
    |> map(fn
      e when is_atom(e) ->
        e

      e ->
        case Integer.parse(e) do
          :error -> String.to_charlist(e) |> List.first()
          {i, _} -> i
        end
    end)
    |> List.to_tuple()
  end

  def parse(args), do: map(String.split(args, "\n", trim: true), &parse_line/1)

  def scramble({:move, pos1, pos2}, p) do
    {l1, [x | h1]} = split(p, pos1)
    {l2, h2} = split(l1 ++ h1, pos2)
    l2 ++ [x | h2]
  end

  def scramble({:swap_n, pos1, pos2}, p) do
    {c1, c2} = {Enum.at(p, pos1), Enum.at(p, pos2)}

    for {c, i} <- Enum.with_index(p) do
      cond do
        i == pos1 -> c2
        i == pos2 -> c1
        true -> c
      end
    end
  end

  def scramble({:swap_l, c1, c2}, p) do
    for c <- p do
      case(c) do
        ^c1 -> c2
        ^c2 -> c1
        _ -> c
      end
    end
  end

  def scramble({:reverse, pos1, pos2}, p) do
    reversed_slice = Enum.slice(p, pos1..pos2) |> reverse()

    for {c, i} <- Enum.with_index(p) do
      if i >= pos1 and i <= pos2, do: at(reversed_slice, i - pos1), else: c
    end
  end

  def scramble({:rotate_l, 0}, p), do: p
  def scramble({:rotate_r, 0}, p), do: p

  def scramble({:rotate_l, s}, p), do: slice(p, s..-1) ++ slice(p, 0..(s - 1))

  def scramble({:rotate_r, s}, p) do
    {l, r} = split(p, length(p) - s)
    r ++ l
  end

  def scramble({:rotate_by_letter, x}, p) do
    index = find_index(p, &(&1 == x))
    scramble({:rotate_r, index + 1 + if(index >= 4, do: 1, else: 0)}, p)
  end

  def scramble([], password), do: password

  def scramble([c | r], password) do
    new_password = scramble(c, password)
    IO.inspect({c, password, new_password}, label: "Avant Après")
    scramble(r, new_password)
  end

  def part1(args) do
    parse(args) |> scramble(String.to_charlist("abcdefgh"))
  end

  def part2(args) do
    parse(args)
  end
end
