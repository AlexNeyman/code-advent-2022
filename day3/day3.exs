defmodule CodeAdvent2022.Day3 do
  def solve1(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(&find_duplicate_item/1)
    |> Enum.map(&calculate_item_priority/1)
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.chunk_every(3)
    |> Enum.map(&find_common_item/1)
    |> Enum.map(&calculate_item_priority/1)
    |> Enum.sum()
  end

  defp find_duplicate_item(line) do
    line
    |> String.split_at(div(String.length(line), 2))
    |> Tuple.to_list()
    |> find_common_item()
  end

  defp find_common_item(item_lists) do
    [common_item] =
      item_lists
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.to_list()

    common_item
  end

  defp calculate_item_priority(item) do
    case String.to_charlist(item) do
      [char] when char in ?a..?z ->
        char - 96

      [char] when char in ?A..?Z ->
        char - 38
    end
  end
end
