defmodule AdventOfCode.Day17 do
  import Enum

  @cvt %{up: "U", down: "D", left: "L", right: "R"}
  @deltas %{up: {0, -1}, down: {0, 1}, left: {-1, 0}, right: {1, 0}}
  @order %{0 => :up, 1 => :down, 2 => :left, 3 => :right}
  @open for i <- to_charlist("0123456789abcdef"), into: %{}, do: {to_string([i]), i > ?a}

  def opened_doors(salt, path) do
    hash = :erlang.md5("#{salt}#{path}") |> Base.encode16(case: :lower)
    for i <- 0..3, into: %{}, do: {@order[i], @open[String.slice(hash, i, 1)]}
  end

  def possible_moves({x, y}, opened) do
    for {d, {dx, dy}} <- @deltas,
        x + dx >= 0,
        x + dx < 4,
        y + dy >= 0,
        y + dy < 4,
        opened[d],
        do: {@cvt[d], {x + dx, y + dy}}
  end

  def find_solution(q, salt) do
    if :queue.is_empty(q) do
      :not_found
    else
      {position, path} = :queue.head(q)
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
    salt = "yjjvjgan"
    q = :queue.new()
    find_solution(:queue.cons({{0, 0}, []}, q), salt)
  end

  def find_l_solution(q, len, salt) do
    if :queue.is_empty(q) do
      len
    else
      {position, path} = :queue.head(q)
      q = :queue.tail(q)

      if position == {3, 3} do
        find_l_solution(q, if(length(path) > len, do: length(path), else: len), salt)
      else
        q =
          Enum.reduce(
            possible_moves(position, opened_doors(salt, reverse(path))),
            q,
            fn {direction, new_pos}, local_q ->
              :queue.snoc(local_q, {new_pos, [direction | path]})
            end
          )

        find_l_solution(q, len, salt)
      end
    end
  end

  def part2(_args) do
    salt = "yjjvjgan"
    q = :queue.new()
    find_l_solution(:queue.cons({{0, 0}, []}, q), 0, salt)
  end
end
