# Load necessary libraries
library(future)
library(data.table)

# Set up parallel processing with the multisession backend
plan(multisession)

# Function to process data
process_data <- function(data_chunk) {
  total_amount <- data_chunk$quantity * data_chunk$price_per_item * (1 - data_chunk$discount)
  
  data_chunk$total_amount <- total_amount
  
  return(data_chunk)
}

# Read input CSV file
input_file <- "input.csv"
data <- fread(input_file)

num_rows <- nrow(data)
half_rows <- ceiling(num_rows / 2)

# First thread processes the first half of the data
future1 <- future(process_data(data[1:half_rows,]))

# Second thread processes the second half of the data
future2 <- future(process_data(data[(half_rows+1):num_rows,]))

# Wait for both threads to finish and retrieve the values
processed_data1 <- value(future1)
processed_data2 <- value(future2)

# Combine the processed data
combined_data <- rbind(processed_data1, processed_data2)

# Write processed data to CSV file
output_file <- "output.csv"
fwrite(combined_data, output_file)

plan(sequential)

