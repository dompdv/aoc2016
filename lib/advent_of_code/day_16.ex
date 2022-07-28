defmodule AdventOfCode.Day16 do
  import Enum

  def mash(a) do
    b = reverse(a)
    a ++ [0] ++ for c <- b, do: if(c == 0, do: 1, else: 0)
  end

  def from_string(s), do: for(c <- to_charlist(s), do: c - ?0)

  def fill_disk(seed, disk_size) do
    Stream.iterate(seed, fn s -> mash(s) end)
    |> Stream.drop_while(fn s -> length(s) < disk_size end)
    |> take(1)
    |> List.first()
    |> slice(0, disk_size)
  end

  def checksum(s) when rem(length(s), 2) == 1, do: s

  def checksum(s) do
    reduce(chunk_every(s, 2), [], fn
      [a, a], acc -> [1 | acc]
      _, acc -> [0 | acc]
    end)
    |> reverse()
    |> checksum()
  end

  def part1(_args) do
    fill_disk(from_string("01111001100111011"), 272)
    |> checksum()
    |> map(fn c -> c + ?0 end)
    |> to_string()
  end

  def part2(_args) do
    fill_disk(from_string("01111001100111011"), 35_651_584)
    |> checksum()
    |> map(fn c -> c + ?0 end)
    |> to_string()
  end
end
