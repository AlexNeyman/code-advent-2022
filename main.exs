defmodule CodeAdvent2022 do
  def run(args) do
    {day, part, input_name} = parse_args(args)

    input = File.read!(Path.relative_to_cwd("./day#{day}/input_#{input_name}.txt"))

    {module, function} = find_solver_module(day, part)

    apply(module, function, [input])
  end

  defp parse_args(args) do
    case args do
      [day, part, input_name] ->
        {String.to_integer(day), String.to_integer(part), input_name}

      _ ->
        raise "Unexpected number of arguments"
    end
  end

  defp find_solver_module(day, part) do
    Code.require_file("day#{day}.exs", "./day#{day}")

    module = String.to_existing_atom("Elixir.CodeAdvent2022.Day#{day}")
    function = String.to_existing_atom("solve#{part}")

    unless function_exported?(module, function, 1) do
      raise "Function #{module}.#{function}/1 is not exported"
    end

    {module, function}
  end
end

IO.puts(CodeAdvent2022.run(System.argv()))
