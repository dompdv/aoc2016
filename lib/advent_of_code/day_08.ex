defmodule AdventOfCode.Day08 do
  import Enum

  @rect ~r/rect ([0-9]+)x([0-9]+)/
  @columns ~r/rotate column x=([0-9]+) by ([0-9]+)/
  @rows ~r/rotate row y=([0-9]+) by ([0-9]+)/
  def parse_line(line) do
    cond do
      Regex.match?(@rect, line) ->
        [cols, rows] = Regex.run(@rect, line, capture: :all_but_first)
        {:rect, String.to_integer(cols), String.to_integer(rows)}

      Regex.match?(@columns, line) ->
        [x, by] = Regex.run(@columns, line, capture: :all_but_first)
        {:rotate_c, String.to_integer(x), String.to_integer(by)}

      Regex.match?(@rows, line) ->
        [y, by] = Regex.run(@rows, line, capture: :all_but_first)
        {:rotate_r, String.to_integer(y), String.to_integer(by)}
    end
  end

  def parse(args), do: args |> String.split("\n", trim: true) |> map(&parse_line/1)

  def exec(grid, {:rect, cols, rows}) do
    reduce(
      for(c <- 0..(cols - 1), r <- 0..(rows - 1), do: {r, c}),
      grid,
      fn cell, g -> Map.update(g, cell, true, fn _ -> true end) end
    )
  end

  def exec(grid, {:rotate_c, x, by}) do
    for {{r, c}, v} = cell <- grid, into: %{} do
      if c == x, do: {{rem(r + by, 6), c}, v}, else: cell
    end
  end

  def exec(grid, {:rotate_r, y, by}) do
    for {{r, c}, v} = cell <- grid, into: %{} do
      if r == y, do: {{r, rem(c + by, 50)}, v}, else: cell
    end
  end

  def display(grid) do
    for r <- 0..5 do
      for(c <- 0..49, do: if(Map.get(grid, {r, c}, false), do: "#", else: ".")) |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()

    IO.puts("\n")

    grid
  end

  def part1(args) do
    reduce(
      parse(args),
      %{},
      fn command, g -> exec(g, command) end
    )
    |> display()
    |> count()
  end

  def part2(args), do: part1(args)
end
