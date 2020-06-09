defmodule Fibonacci do

  alias Fibonacci.Cache

  def fib(n) do
    Cache.run(fn _ ->
      cached_fib(n)
    end)
  end

  defp cached_fib(n) do
    Cache.lookup(n, fn ->
      cached_fib(n-2) + cached_fib(n-1)
    end)
  end

end
