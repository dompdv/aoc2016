defmodule AdventOfCode.Day04 do
  import Enum

  def parse_line(line) do
    [l, c] = String.split(line, "[")
    [c, _] = String.split(c, "]")
    l = String.split(l, "-")
    {l |> slice(0..-2), String.to_integer(List.last(l)), c}
  end

  def parse(args) do
    args |> String.split("\n", trim: true) |> map(&parse_line/1)
  end

  def decide({l, n, c}) do
    checksum =
      map(l, &to_charlist/1)
      # met tous les charactères à plat
      |> List.flatten()
      # compte les caractères
      |> Enum.frequencies()
      # convertit en liste de couples {key,value}
      |> Map.to_list()
      # trie selon le bon ordre
      |> sort(fn {c1, n1}, {c2, n2} -> if n1 == n2, do: c1 < c2, else: n1 > n2 end)
      # garde les 5 premiers
      |> take(5)
      # retient les lettres uniquement
      |> map(&elem(&1, 0))
      |> to_string()

    if checksum == c, do: n, else: 0
  end

  def part1(args) do
    parse(args) |> map(&decide/1) |> sum()
  end

  def rotate({l, id_sector, _}) do
    decrypted =
      for word <- l do
        for(ch <- to_charlist(word), do: rem(ch - ?a + id_sector, ?z - ?a + 1) + ?a)
        |> to_string()
      end
      |> join(" ")

    {decrypted, id_sector}
  end

  def part2(args) do
    parse(args)
    |> filter(fn room -> decide(room) > 0 end)
    |> map(&rotate/1)
    |> filter(&(elem(&1, 0) == "northpole object storage"))
    |> List.first()
    |> elem(1)
  end
end
