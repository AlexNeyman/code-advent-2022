defmodule CodeAdvent2022.Day2 do
  @rock "A"
  @paper "B"
  @scissors "C"

  def solve1(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(&round_score/1)
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.map(fn line ->
      [x, y] = String.split(line, " ")

      y_replacement =
        case y do
          "X" ->
            loses_to(loses_to(recognize_figure(x)))

          "Y" ->
            x

          "Z" ->
            loses_to(recognize_figure(x))
        end

      "#{x} #{y_replacement}"
    end)
    |> Enum.join("\n")
    |> solve1()
  end

  defp round_score(line) do
    [x, y] = String.split(line, " ")

    figure_x = recognize_figure(x)
    figure_y = recognize_figure(y)

    winner_score(figure_x, figure_y) + figure_score(figure_y)
  end

  defp winner_score(x, y) do
    cond do
      won?(x, y) ->
        6

      draw?(x, y) ->
        3

      lost?(x, y) ->
        0
    end
  end

  defp loses_to(@rock), do: @paper
  defp loses_to(@paper), do: @scissors
  defp loses_to(@scissors), do: @rock

  defp won?(x, y), do: y == loses_to(x)

  defp draw?(x, x), do: true
  defp draw?(_, _), do: false

  defp lost?(x, y), do: !(draw?(x, y) || won?(x, y))

  defp recognize_figure(s) when s in [@rock, "X"], do: @rock
  defp recognize_figure(s) when s in [@paper, "Y"], do: @paper
  defp recognize_figure(s) when s in [@scissors, "Z"], do: @scissors

  defp figure_score(@rock), do: 1
  defp figure_score(@paper), do: 2
  defp figure_score(@scissors), do: 3
end
