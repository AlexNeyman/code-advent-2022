defmodule CodeAdvent2022.Day4 do
  def solve1(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(&parse_ranges/1)
    |> Enum.count(fn {r1, r2} -> subset?(r1, r2) || subset?(r2, r1) end)
  end

  def solve2(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(&parse_ranges/1)
    |> Enum.count(fn {r1, r2} -> !disjoint?(r1, r2) end)
  end

  defp parse_ranges(line) do
    [a1, b1, a2, b2] =
      line
      |> String.split(",")
      |> Enum.flat_map(&String.split(&1, "-"))
      |> Enum.map(&String.to_integer/1)

    {{a1, b1}, {a2, b2}}
  end

  defp subset?({a1, b1}, {a2, b2}) do
    a1 >= a2 && b1 <= b2
  end

  defp disjoint?({a1, b1}, {a2, b2}) do
    a1 > b2 || b1 < a2
  end
end
