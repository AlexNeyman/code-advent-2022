defmodule CodeAdvent2022.Day1 do
  def solve1(input) do
    input
    |> String.split(~r/\n\n/)
    |> Enum.map(&sum_lines/1)
    |> Enum.max()
  end

  def solve2(input) do
    input
    |> String.split(~r/\n\n/)
    |> Enum.map(&sum_lines/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp sum_lines(lines) do
    lines
    |> String.split(~r/\n/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
