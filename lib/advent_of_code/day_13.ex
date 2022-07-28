defmodule AdventOfCode.Day13 do
  def is_cubicle(x, y, f) do
    rem(
      Integer.to_string(f + x * x + 3 * x + 2 * x * y + y + y * y, 2)
      |> to_charlist()
      |> Enum.frequencies()
      |> Map.get(?1),
      2
    ) == 1
  end

  def final?({x, y, tx, ty, _}), do: x == tx and y == ty

  def possible_moves({x, y, _tx, _ty, favorite}) do
    for {dx, dy} <- [{1, 0}, {-1, 0}, {0, 1}, {0, -1}],
        x + dx >= 0,
        y + dy >= 0,
        not is_cubicle(x + dx, y + dy, favorite),
        do: {dx, dy}
  end

  def move({x, y, tx, ty, f}, {dx, dy}), do: {x + dx, y + dy, tx, ty, f}

  def add_to_visited(visited, {x, y, _tx, _ty, _f}), do: :gb_sets.add_element({x, y}, visited)

  def is_visited(visited, {x, y, _tx, _ty, _f}),
    do: :gb_sets.is_element({x, y}, visited)

  def find_solution(q, visited) do
    #    IO.inspect(q, label: "Start")
    if :queue.is_empty(q) do
      :not_found
    else
      {moves, wh} = :queue.head(q)
      q = :queue.tail(q)

      if final?(wh) do
        {moves, wh}
      else
        if is_visited(visited, wh) do
          find_solution(q, visited)
        else
          visited = visited |> add_to_visited(wh)

          #         IO.inspect(possible_moves(wh), label: "Possible")

          new_whs =
            for(
              {dx, dy} <- possible_moves(wh),
              do: move(wh, {dx, dy})
            )

          q =
            Enum.reduce(new_whs, q, fn a_wh, local_q ->
              :queue.snoc(local_q, {moves + 1, a_wh})
            end)

          find_solution(q, visited)
        end
      end
    end
  end

  def part1(_args) do
    is_cubicle(6, 3, 10)
    q = :queue.new()

    find_solution(:queue.cons({0, {1, 1, 31, 39, 1358}}, q), :gb_sets.new())
  end

  def find_solution2(q, visited) do
    #    IO.inspect(q, label: "Start")
    if :queue.is_empty(q) do
      :not_found
    else
      {moves, wh} = :queue.head(q)
      q = :queue.tail(q)

      if moves == 51 do
        {moves, :gb_sets.size(visited)}
      else
        if is_visited(visited, wh) do
          find_solution2(q, visited)
        else
          visited = visited |> add_to_visited(wh)

          #         IO.inspect(possible_moves(wh), label: "Possible")

          new_whs =
            for(
              {dx, dy} <- possible_moves(wh),
              do: move(wh, {dx, dy})
            )

          q =
            Enum.reduce(new_whs, q, fn a_wh, local_q ->
              :queue.snoc(local_q, {moves + 1, a_wh})
            end)

          find_solution2(q, visited)
        end
      end
    end
  end

  def part2(_args) do
    is_cubicle(6, 3, 10)
    q = :queue.new()

    find_solution2(:queue.cons({0, {1, 1, 31, 39, 1358}}, q), :gb_sets.new())
  end
end
