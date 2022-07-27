defmodule AdventOfCode.Day11 do
  import Enum

  @start0 [{1, :h, :m}, {1, :l, :m}, {2, :h, :g}, {3, :l, :g}]

  @start1 [
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

  @start2 [
    {1, :el, :g},
    {1, :el, :m},
    {1, :di, :g},
    {1, :di, :m},
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

  @spec init_warehouse :: %{elevator: 1, storage: map}
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

  def compress(a_floor) do
    reduce(a_floor, {0, 0}, fn
      {_, :m}, {m, g} -> {m + 1, g}
      {_, :g}, {m, g} -> {m, g + 1}
    end)
  end

  def add_to_visited(visited, %{elevator: e, storage: storage}) do
    :gb_sets.add_element({e, for({f, l} <- storage, do: {f, compress(l)})}, visited)
  end

  def is_visited(visited, %{elevator: e, storage: storage}),
    do: :gb_sets.is_element({e, for({f, l} <- storage, do: {f, compress(l)})}, visited)

  def find_solution(q, visited) do
    if :queue.is_empty(q) do
      :not_found
    else
      {level, wh} = :queue.head(q)
      q = :queue.tail(q)

      #      if :rand.uniform() > 0.9, do: IO.inspect({level, :queue.len(q), :gb_sets.size(visited)})
      if final?(wh) do
        {level, wh}
      else
        if is_visited(visited, wh) do
          find_solution(q, visited)
        else
          visited = visited |> add_to_visited(wh)

          new_whs =
            for(
              {to, objects} <- possible_moves(wh),
              do: move(wh, to, objects)
            )

          q =
            reduce(new_whs, q, fn a_wh, local_q ->
              :queue.snoc(local_q, {level + 1, a_wh})
            end)

          find_solution(q, visited)
        end
      end
    end
  end

  def exec(args) do
    wh =
      reduce(
        args,
        init_warehouse(),
        fn {floor, material, component}, wh -> add(wh, floor, {material, component}) end
      )

    q = :queue.new()

    find_solution(:queue.cons({0, wh}, q), :gb_sets.new())
    |> elem(0)
  end

  def part1(_args), do: exec(@start1)

  def part2(_args), do: exec(@start2)
end
