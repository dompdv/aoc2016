defmodule AdventOfCode.Day12 do
  @cpyv ~r/cpy (-?\d+) ([a-d])/
  @cpyr ~r/cpy ([a-d]) ([a-d])/
  @incdec ~r/(inc|dec) ([a-d])/
  @jnz ~r/jnz ([a-d]) (-?\d+)/
  @jnzv ~r/jnz (-?\d+) (-?\d+)/

  def parse_line(line) do
    cond do
      Regex.match?(@cpyv, line) ->
        [_, v, r_to] = Regex.run(@cpyv, line)
        {:cpyv, String.to_integer(v), String.to_atom(r_to)}

      Regex.match?(@cpyr, line) ->
        [_, r_from, r_to] = Regex.run(@cpyr, line)
        {:cpyr, String.to_atom(r_from), String.to_atom(r_to)}

      Regex.match?(@incdec, line) ->
        [_, incdec, r_to] = Regex.run(@incdec, line)
        {:incdec, String.to_atom(r_to), if(incdec == "inc", do: 1, else: -1)}

      Regex.match?(@jnz, line) ->
        [_, r_from, offset] = Regex.run(@jnz, line)
        {:jnz, String.to_atom(r_from), String.to_integer(offset)}

      Regex.match?(@jnzv, line) ->
        [_, value, offset] = Regex.run(@jnzv, line)
        {:jnzv, String.to_integer(value), String.to_integer(offset)}
    end
  end

  def parse(args),
    do:
      String.split(args, "\n", trim: true)
      |> Enum.map(&parse_line/1)
      |> Enum.with_index(fn e, i -> {i, e} end)
      |> Map.new()

  def init_state(program), do: %{pc: 0, registers: %{a: 0, b: 0, c: 0, d: 0}, program: program}

  def exec_one_step(%{pc: pc, registers: registers} = state, {:cpyv, v, r_to}),
    do: %{state | pc: pc + 1, registers: Map.put(registers, r_to, v)}

  def exec_one_step(%{pc: pc, registers: registers} = state, {:cpyr, r_from, r_to}),
    do: %{state | pc: pc + 1, registers: Map.put(registers, r_to, registers[r_from])}

  def exec_one_step(%{pc: pc, registers: registers} = state, {:incdec, r_to, v}),
    do: %{state | pc: pc + 1, registers: Map.update!(registers, r_to, &(&1 + v))}

  def exec_one_step(%{pc: pc, registers: registers} = state, {:jnz, r, offset}) do
    if registers[r] == 0, do: %{state | pc: pc + 1}, else: %{state | pc: pc + offset}
  end

  def exec_one_step(%{pc: pc} = state, {:jnzv, v, offset}) do
    if v == 0, do: %{state | pc: pc + 1}, else: %{state | pc: pc + offset}
  end

  def exec_one_step(%{pc: pc, program: program} = state) do
    if Map.has_key?(program, pc),
      do: exec_one_step(state, program[pc]),
      else: {:end, state}
  end

  def run(state) do
    case exec_one_step(state) do
      {:end, state} -> state[:registers]
      state -> run(state)
    end
  end

  def set(%{registers: registers} = state, r, v),
    do: %{state | registers: Map.put(registers, r, v)}

  def part1(args), do: parse(args) |> init_state() |> run()
  def part2(args), do: parse(args) |> init_state() |> set(:c, 1) |> run()
end
