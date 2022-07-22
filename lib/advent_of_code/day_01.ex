defmodule AdventOfCode.Day01 do
  @start {0, 0}
  @north {0, 1}

  def parse(args) do
    args
    |> String.trim()
    |> String.split(", ")
    |> Enum.map(fn s -> {String.first(s), s |> String.slice(1..-1) |> String.to_integer()} end)
  end

  def rotate("R", {x, y}), do: {y, -x}
  def rotate("L", {x, y}), do: {-y, x}
  def multiply({x, y}, r), do: {x * r, y * r}
  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def part1(args) do
    {{final_x, final_y}, _} =
      Enum.reduce(
        parse(args),
        {@start, @north},
        fn {rot, move}, {position, direction} ->
          new_direction = rotate(rot, direction)
          {add(position, multiply(new_direction, move)), new_direction}
        end
      )

    abs(final_x) + abs(final_y)
  end

  def forward(position, direction, move, visited) do
    Enum.reduce_while(1..move, {position, visited}, fn _, {position, visited} ->
      new_position = add(position, direction)

      if new_position in visited do
        {:halt, {:halt, new_position, visited}}
      else
        {:cont, {new_position, [new_position | visited]}}
      end
    end)
  end

  def part2(args) do
    {{final_x, final_y}, _, _} =
      parse(args)
      |> Enum.map(fn {d, m} -> [d, {"M", m}] end)
      |> List.flatten()
      |> Enum.reduce_while(
        {@start, @north, []},
        fn
          "R", {position, direction, visited} ->
            {:cont, {position, rotate("R", direction), visited}}

          "L", {position, direction, visited} ->
            {:cont, {position, rotate("L", direction), visited}}

          {"M", move}, {position, direction, visited} ->
            case forward(position, direction, move, visited) do
              {new_position, new_visited} ->
                {:cont, {new_position, direction, new_visited}}

              {:halt, new_position, new_visited} ->
                {:halt, {new_position, direction, new_visited}}
            end
        end
      )

    abs(final_x) + abs(final_y)
  end
end
