defmodule AdventOfCode.Day10 do
  def parse(args), do: String.split(args, "\n", trim: true) |> Enum.map(&parse_line/1)

  def parse_line([value, bot], nil),
    do: {:bot, String.to_integer(value), String.to_integer(bot)}

  def parse_line(nil, [from_bot, low_to, low_to_number, high_to, high_to_number]),
    do:
      {:transfer, String.to_integer(from_bot), String.to_atom(low_to),
       String.to_integer(low_to_number), String.to_atom(high_to),
       String.to_integer(high_to_number)}

  def parse_line(line) do
    parse_line(
      Regex.run(~r/value (\d+) goes to bot (\d+)/, line, capture: :all_but_first),
      Regex.run(
        ~r/bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)/,
        line,
        capture: :all_but_first
      )
    )
  end

  def put_value(bots, output, {:output, value, ouput_number}) do
    {bots, Map.put(output, ouput_number, value), {false, nil}}
  end

  def put_value(bots, output, {:bot, value, bot}) do
    bots =
      Map.update(bots, bot, {value, nil}, fn
        {nil, nil} -> {value, nil}
        {nil, v2} -> {value, v2}
        {v1, nil} -> {v1, value}
      end)

    {v1, v2} = Map.get(bots, bot)
    {bots, output, {v1 != nil and v2 != nil, bot}}
  end

  def run([], bots, output, _rules), do: {bots, output}

  def run([cmd | commands], bots, output, rules) do
    {bots, output, {fire, bot}} = put_value(bots, output, cmd)

    if fire do
      {low_to, low_to_number, high_to, high_to_number} = rules[bot]
      {v1, v2} = bots[bot]
      {low_v, high_v} = if v1 <= v2, do: {v1, v2}, else: {v2, v1}

      if {low_v, high_v} == {17, 61}, do: IO.inspect(bot, label: "The one bot to find")

      bots = Map.put(bots, bot, {nil, nil})

      run(
        [{low_to, low_v, low_to_number}, {high_to, high_v, high_to_number} | commands],
        bots,
        output,
        rules
      )
    else
      run(commands, bots, output, rules)
    end
  end

  def part1(args) do
    instructions =
      parse(args)
      |> Enum.group_by(fn
        {:bot, _, _} -> :bot
        _ -> :transfer
      end)

    rules =
      for {:transfer, bot, low_to, low_to_number, high_to, high_to_number} <-
            instructions[:transfer],
          into: %{},
          do: {bot, {low_to, low_to_number, high_to, high_to_number}}

    run(instructions[:bot], %{}, %{}, rules)
  end

  def part2(args) do
    {_, output} = part1(args)
    output[0] * output[1] * output[2]
  end
end
