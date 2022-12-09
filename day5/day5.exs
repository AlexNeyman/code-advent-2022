defmodule CodeAdvent2022.Day5 do
  def solve1(input) do
    solve(input, false)
  end

  def solve2(input) do
    solve(input, true)
  end

  defp solve(input, move_at_once) do
    [initial_stacks_input, moves_input] = String.split(input, ~r/\n\n/)
    initial_stacks = parse_initial_stacks(initial_stacks_input)

    moves_input
    |> String.split(~r/\n/)
    |> Enum.reduce(initial_stacks, fn move_input, stacks ->
      move(stacks, parse_move(move_input), move_at_once)
    end)
    |> Enum.sort_by(fn {n, _stack} -> n end)
    |> Enum.map(fn {_n, [first | _]} -> first end)
    |> Enum.join()
  end

  defp parse_move(input) do
    [_, count, from, to] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, input)

    {String.to_integer(count), String.to_integer(from), String.to_integer(to)}
  end

  defp do_move(stacks, count, from, to) do
    {items, popped_stacks} =
      Map.get_and_update!(stacks, from, fn stack ->
        Enum.split(stack, count)
      end)

    Map.update!(popped_stacks, to, &(items ++ &1))
  end

  defp move(stacks, {count, from, to}, true) do
    do_move(stacks, count, from, to)
  end

  defp move(stacks, {0, _, _}, false) do
    stacks
  end

  defp move(stacks, {count, from, to}, false) do
    move(
      do_move(stacks, 1, from, to),
      {count - 1, from, to},
      false
    )
  end

  defp parse_initial_stacks(input) do
    [number_line | stack_lines] =
      input
      |> String.split(~r/\n/)
      |> Enum.reverse()

    stack_positions =
      ~r/\d/
      |> Regex.scan(number_line, return: :index)
      |> Enum.map(fn [{i, _}] -> {i, String.to_integer(String.at(number_line, i))} end)

    # stacks = for n <- 1..stack_number, into: %{}, do: {n, []}

    Enum.reduce(stack_lines, %{}, fn line, stacks ->
      Enum.reduce(stack_positions, stacks, fn {i, n}, stacks ->
        put_item(stacks, n, String.at(line, i))
      end)
    end)
  end

  defp put_item(stacks, _, item) when item in [nil, " "], do: stacks
  defp put_item(stacks, n, item), do: Map.update(stacks, n, [item], &[item | &1])
end
