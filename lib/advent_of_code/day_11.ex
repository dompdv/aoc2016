defmodule AdventOfCode.Day11 do
  import Enum

  @start1 [{1, :h, :m}, {1, :l, :m}, {2, :h, :g}, {3, :l, :g}]

  @start [
    {1, :th, :g},
    {1, :th, :m},
    {1, :pl, :g},
    {1, :st, :g},
    {2, :pl, :m},
    {2, :st, :m},
    {3, :pr, :g},
    {3, :pr, :m},
    {3, :ru, :g},
    {3, :ru, :m}
  ]

  def init_warehouse(),
    do: %{elevator: 1, storage: for(i <- 1..4, into: %{}, do: {i, MapSet.new()})}

  def add(%{storage: storage} = wh, floor, stg) do
    f = storage[floor]
    %{wh | storage: Map.put(storage, floor, MapSet.put(f, stg))}
  end

  def can_add?(%{storage: storage}, floor, {material, :m}) do
    f = storage[floor]

    if MapSet.member?(f, {material, :g}),
      do: true,
      else: not any?(for {_, component} <- f, do: component == :g)
  end

  def can_add?(%{storage: storage}, floor, {material, :g}) do
    f = storage[floor]

    if MapSet.member?(f, {material, :h}),
      do: true,
      else: not any?(for {_, component} <- f, do: component == :h)
  end

  def final?(%{storage: storage}),
    do: all?(for floor <- 1..3, do: MapSet.size(storage[floor]) == 0)

  def floor_possible_move(%{elevator: 1}), do: [2]
  def floor_possible_move(%{elevator: 4}), do: [3]
  def floor_possible_move(%{elevator: i}), do: [i + 1, i - 1]

  def objects_possible_load(%{elevator: e, storage: storage}) do
    f = storage[e]
    a = for o1 <- f, do: [o1]

    b =
      for {m1, c1} = o1 <- f,
          {m2, c2} = o2 <- f,
          o1 != o2,
          o1 < o2,
          m1 == m2 or c1 == c2,
          do: [o1, o2]

    b ++ a
  end

  def can_move(wh, f, [o]), do: can_add?(wh, f, o)
  def can_move(_wh, _f, [{m, _}, {m, _}]), do: true
  def can_move(wh, f, [o1, o2]), do: can_add?(wh, f, o1) and can_add?(wh, f, o2)

  def possible_moves(wh) do
    for f <- floor_possible_move(wh),
        objects <- objects_possible_load(wh),
        can_move(wh, f, objects),
        do: {f, objects}
  end

  def move(%{elevator: e, storage: storage}, to, objects) do
    objects = MapSet.new(objects)
    f = storage[e] |> MapSet.difference(objects)
    t = storage[to] |> MapSet.union(objects)
    %{elevator: to, storage: storage |> Map.put(e, f) |> Map.put(to, t)}
  end

  def rank_function(%{storage: storage}) do
    -(for(i <- 1..4, do: i * MapSet.size(storage[i])) |> sum())
  end

  def find_solutions(_wh, moves, _path, min_moves, _) when moves >= min_moves, do: false

  def find_solutions(wh, moves, _path, min_moves, known) do
    #    if moves == 12, do: IO.inspect({moves, wh})
    # IO.inspect({moves, wh, min_moves}, label: "Current")

    if final?(wh) do
      IO.inspect({moves, wh, min_moves}, label: "Final")
      moves
    else
      pm = possible_moves(wh)
      # |> IO.inspect(label: "PMoves")

      if count(pm) == 0 do
        false
      else
        new_whs =
          for(
            {to, objects} <- pm,
            do: move(wh, to, objects)
          )
          |> filter(fn w -> not :gb_sets.is_element(w, known) end)

        # new_whs = sort_by(new_whs, &rank_function/1)

        reduce(new_whs, {min_moves, known}, fn new_wh, {mm, new_known} ->
          new_known = :gb_sets.add_element(new_wh, new_known)
          # [new_wh | path]
          case find_solutions(new_wh, moves + 1, nil, mm, new_known) do
            false -> {mm, new_known}
            n -> {if(n < mm, do: n, else: mm), new_known}
          end
        end)
        |> elem(0)
      end
    end
  end

  def part1(_args) do
    # ascenceur bouge de 1 à la fois
    # il contient 1 ou 2 éléments
    # on peut avoir autant de G que l'on veut par étage
    # 4 étages, il faut tout ramener au 4eme
    # on peut avoir autant d'éléments que l'on veut par étage
    # on ne peut pas avoir de M (microchip) sans son G correspondant dans un étage où il y a d'autres G
    # on peut avoir autant de M que l'on veut tant qu'on ne brise pas la règle précédente
    wh =
      reduce(
        @start,
        init_warehouse(),
        fn {floor, material, component}, wh -> add(wh, floor, {material, component}) end
      )

    # move(wh, 2, [{:h, :m}, {:l, :m}]) |> move(1, [{:h, :m}, {:l, :m}])

    find_solutions(wh, 0, [wh], 7, :gb_sets.from_list([wh]))
  end

  def part2(_args) do
  end
end
