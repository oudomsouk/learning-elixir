(for x <- 1..100, y <- 1..100, z <- 1..100, x*x + y*y == z*z, do: {x, y, z})
|> length
|> IO.puts

(for x <- 1..100, y <- 1..x, z <- x..100, x*x + y*y == z*z, do: {x, y, z})
|> length
|> IO.puts
