defmodule Fibonacci.Cache do

  @me __MODULE__

  def start_link() do
    Agent.start_link(fn -> %{ 0 => 0, 1 => 1 } end, name: @me)
  end

  def run(body) do
    body.(@me)
  end

  def lookup(n, if_not_found) do
    Agent.get(@me, fn map -> map[n] end)
    |> complete_if_not_found(n, if_not_found)
  end

  defp complete_if_not_found(nil, n, if_not_found) do
    if_not_found.()
    |> set(n)
  end

  defp complete_if_not_found(value, _n, _if_not_found) do
    value
  end

  defp set(val, n) do
    Agent.get_and_update(@me, fn map ->
      { val, Map.put(map, n, val)}
    end)
  end

end
