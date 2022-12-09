Enum.map(Path.wildcard("./day*"), fn day ->
  Code.require_file("#{day}.exs", "./#{day}")
end)

defmodule CodeAdvent2022 do
  alias CodeAdvent2022.{Day1, Day2}

  @spec run([String.t()]) :: String.t()
  def run(args) do
    {day, part, input_name} = parse_args(args)

    input = File.read!(Path.relative_to_cwd("./day#{day}/input_#{input_name}.txt"))

    case {day, part} do
      {1, 1} ->
        Day1.solve1(input)

      {1, 2} ->
        Day1.solve2(input)

      {2, 1} ->
        Day2.solve1(input)

      {2, 2} ->
        Day2.solve2(input)

      _ ->
        raise "unexpected day #{day}"
    end
  end

  defp parse_args(args) do
    case args do
      [day, part, input_name] ->
        {String.to_integer(day), String.to_integer(part), input_name}

      _ ->
        raise "unexpected number of arguments"
    end
  end
end

IO.puts(CodeAdvent2022.run(System.argv()))
