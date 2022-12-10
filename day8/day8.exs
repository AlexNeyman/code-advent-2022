defmodule CodeAdvent2022.Day8 do
  alias CodeAdvent2022.Day8.Forest

  def solve1(input) do
    input
    |> Forest.new()
    |> Forest.count_visible_trees()
  end

  def solve2(input) do
    input
    |> Forest.new()
    |> Forest.calculate_scenic_scores()
    |> Enum.max()
  end

  defmodule Forest do
    defstruct [:width, :height, :map]

    def new(input) do
      map = parse_map(input)

      {width, height} = Enum.max_by(Map.keys(map), fn {x, y} -> x + y end)

      %__MODULE__{
        width: width,
        height: height,
        map: map
      }
    end

    def calculate_scenic_scores(forest = %__MODULE__{}) do
      Enum.map(forest.map, fn tree -> calculate_scenic_score(forest, tree) end)
    end

    defp calculate_scenic_score(forest, tree) do
      count_visible_trees_to(forest, &explore_north/4, tree) *
        count_visible_trees_to(forest, &explore_east/4, tree) *
        count_visible_trees_to(forest, &explore_south/4, tree) *
        count_visible_trees_to(forest, &explore_west/4, tree)
    end

    def count_visible_trees(forest = %__MODULE__{}) do
      Enum.count(forest.map, fn tree -> visible_from_outside?(forest, tree) end)
    end

    defp count_visible_trees_to(forest, explore_fn, {{x, y}, v}) do
      trees = explore_fn.(forest, x, y, &(&1 < v))

      if Enum.all?(trees) do
        Enum.count(trees)
      else
        trees
        |> Enum.take_while(& &1)
        |> Enum.count()
        |> Kernel.+(1)
      end
    end

    defp visible_from_outside?(forest, tree) do
      visible_from?(forest, &explore_north/4, tree) ||
        visible_from?(forest, &explore_east/4, tree) ||
        visible_from?(forest, &explore_south/4, tree) ||
        visible_from?(forest, &explore_west/4, tree)
    end

    defp visible_from?(forest, explore_fn, {{x, y}, v}) do
      forest
      |> explore_fn.(x, y, &(&1 < v))
      |> Enum.all?()
    end

    defp explore_south(%{height: h}, _, y, _) when y == h, do: []

    defp explore_south(%{map: map, height: h}, x, y, fun) do
      for y1 <- Range.new(y + 1, h), do: fun.(Map.fetch!(map, {x, y1}))
    end

    defp explore_north(_, _, 0, _), do: []

    defp explore_north(%{map: map}, x, y, fun) do
      for y1 <- Range.new(y - 1, 0), do: fun.(Map.fetch!(map, {x, y1}))
    end

    defp explore_east(%{width: w}, x, _, _) when x == w, do: []

    defp explore_east(%{map: map, width: w}, x, y, fun) do
      for x1 <- Range.new(x + 1, w), do: fun.(Map.fetch!(map, {x1, y}))
    end

    defp explore_west(_, 0, _, _), do: []

    defp explore_west(%{map: map}, x, y, fun) do
      for x1 <- Range.new(x - 1, 0), do: fun.(Map.fetch!(map, {x1, y}))
    end

    defp parse_map(input) do
      input
      |> String.split(~r/\n/)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {chars, y}, acc ->
        chars
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, acc ->
          Map.put(acc, {x, y}, String.to_integer(char))
        end)
      end)
    end
  end
end
