defmodule CodeAdvent2022.Day6 do
  def solve1(input) do
    input
    |> String.codepoints()
    |> find_start_position(4)
  end

  def solve2(input) do
    input
    |> String.codepoints()
    |> find_start_position(14)
  end

  defp find_start_position(chars, uniq_number) do
    do_find_start_position(chars, uniq_number, 0)
  end

  defp do_find_start_position(chars, uniq_number, _)
       when length(chars) < uniq_number + 1 do
    raise "No start position found"
  end

  defp do_find_start_position(chars, uniq_number, offset) do
    if are_all_different?(Enum.take(chars, uniq_number)) do
      offset + uniq_number
    else
      do_find_start_position(tl(chars), uniq_number, offset + 1)
    end
  end

  defp are_all_different?(chars) do
    Enum.count(MapSet.new(chars)) == Enum.count(chars)
  end
end
