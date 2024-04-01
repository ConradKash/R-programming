# Load necessary libraries
library(parallel)
library(data.table)
library(microbenchmark)

# Set up parallel processing
num_cores <- 2  # Number of cores to use
cl <- makeCluster(num_cores)
clusterEvalQ(cl, {
  library(data.table)
})

# Function to process data
process_data <- function(data_chunk) {
  # Calculate total amount after removing the discount
  total_amount <- data_chunk$quantity * data_chunk$price_per_item * (1 - data_chunk$discount)
  
  # Append total amount to the data
  data_chunk$total_amount <- total_amount
  
  # Return the processed data chunk
  return(data_chunk)
}

# Read input CSV file
input_file <- "input.csv"
data <- fread(input_file)

# Split the data into two chunks for two threads
num_rows <- nrow(data)
half_rows <- ceiling(num_rows / 2)

# Divide the data into two parts for parallel processing
data_parts <- split(data, rep(1:num_cores, each = ceiling(nrow(data) / num_cores), length.out = nrow(data)))

# Measure execution time
execution_time <- microbenchmark::microbenchmark(
  processed_data <- parLapply(cl, data_parts, process_data),
  times = 1
)

# Combine the processed data
combined_data <- rbindlist(processed_data)

# Write processed data to CSV file
output_file <- "output.csv"
fwrite(combined_data, output_file)

# Stop the cluster
stopCluster(cl)

# Output execution time
cat("Execution Time:", execution_time$time[1], "milliseconds\n")
