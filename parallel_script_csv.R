library(future)
plan(multiprocess)

x <- data.frame(matrix(runif(1000*1e4), ncol = 100))

avoid_copy <- function(z){
  list_of_dfs <- lapply(1:100, function(z) data.frame(matrix(runif(1*1e4), ncol = 100)))
  rows <- Reduce(rbind, list_of_dfs)
  rbind(x, rows)
}

## job 1
a %<-% {
  avoid_copy(x[,1:50])
}
## job 2
b %<-% {
  avoid_copy(x[,51:100])
}

## probably not quicker as not a long running enough function
system.time(
  c <- cbind(a, b)
)
