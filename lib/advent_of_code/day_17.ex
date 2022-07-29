defmodule AdventOfCode.Day17 do
  # :erlang.md5("#{salt}#{counter}") |> Base.encode16(case: :lower)
  import Enum

  @cvt %{up: "U", down: "D", left: "L", right: "R"}
  @deltas %{up: {0, -1}, down: {0, 1}, left: {-1, 0}, right: {1, 0}}
  @order %{0 => :up, 1 => :down, 2 => :left, 3 => :right}
  @directions %{"U" => :up, "D" => :down, "L" => :left, "R" => :right}
  @open for i <- to_charlist("0123456789abcdef"), into: %{}, do: {to_string([i]), i > ?a}

  def opened_doors(salt, path) do
    hash = :erlang.md5("#{salt}#{path}") |> Base.encode16(case: :lower)
    IO.inspect({"#{salt}#{path}", hash}, label: "Opened compute")

    for i <- 0..3, into: %{}, do: {@order[i], @open[String.slice(hash, i, 1)]}
  end

  def possible_moves({x, y}, opened) do
    IO.inspect(opened, label: "Opened")

    for(
      {d, {dx, dy}} <- @deltas,
      x + dx >= 0,
      x + dx < 4,
      y + dy >= 0,
      y + dy < 4,
      opened[d],
      do: {@cvt[d], {x + dx, y + dy}}
    )
    |> IO.inspect(label: "Possible moves")
  end

  def find_solution(q, salt) do
    if :queue.is_empty(q) do
      :not_found
    else
      {position, path} = :queue.head(q)
      IO.inspect({position, path})
      q = :queue.tail(q)

      if position == {3, 3} do
        join(reverse(path))
      else
        q =
          Enum.reduce(
            possible_moves(position, opened_doors(salt, reverse(path))),
            q,
            fn {direction, new_pos}, local_q ->
              :queue.snoc(local_q, {new_pos, [direction | path]})
            end
          )

        find_solution(q, salt)
      end
    end
  end

  def part1(_args) do
    #    opened_doors("hijkl", "D")
    #    find_solution2(:queue.cons({0, {1, 1, 31, 39, 1358}}, q), :gb_sets.new())
    salt = "ulqzkmiv"
    salt = "yjjvjgan"
    q = :queue.new()
    a_path = find_solution(:queue.cons({{0, 0}, []}, q), salt)

    reduce(String.graphemes(a_path), {{0, 0}, ""}, fn char, {{x, y}, path} ->
      d = @directions[char]
      possible = opened_doors(salt, path)
      IO.inspect({d, possible, possible[d]}, label: "Check Possible??")
      {dx, dy} = @deltas[d]
      {{x + dx, y + dy}, "#{path}#{char}"}
    end)
  end

  def part2(_args) do
  end
end
