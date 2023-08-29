library(keras)
library(caret)

# Load your data
# Assuming you have 'Train' and 'normalized_Valid' datasets

# Define the model architecture
model <- keras_model_sequential() %>%
  layer_dense(units = 10, activation = "relu", input_shape = ncol(x_train)) %>%  # Input layer
  layer_dense(units = 1, activation = "linear")  # Output layer with linear activation

# Compile the model
model %>% compile(
  loss = "mean_squared_error",  # Use mean squared error for regression
  optimizer = optimizer_adam()  # Use Adam optimizer
)

# Normalize input features (assuming they are not scaled yet)
x_train <- Train[, c("precip", "eto")]
x_train <- scale(x_train)

# Extract target variable
y_train <- Train$discharge

# Train the model
history <- model %>% fit(
  x_train, y_train,
  epochs = 100,  # Number of training epochs
  batch_size = 32,  # Batch size
  validation_split = 0.2,  # Validation split
  verbose = 2  # Show training progress
)

# Extract input features for validation
x_valid <- normalized_Valid[, c("precip", "eto")]

# Normalize input features for validation
x_valid <- scale(x_valid)

# Predict using the trained model
predictions <- model %>% predict(x_valid)

# Calculate accuracy or other relevant metrics if applicable
# In a regression context, you might use metrics like Mean Squared Error (MSE) or Root Mean Squared Error (RMSE).

# Extract true target values for validation
y_valid <- normalized_train[, "discharge"]

# Calculate Mean Squared Error (MSE)
mse <- mean((predictions - Valid$discharge)^2)

# Calculate Root Mean Squared Error (RMSE)
rmse <- sqrt(mse)

# Display results
cat("Mean Squared Error (MSE):", mse, "\n")
cat("Root Mean Squared Error (RMSE):", rmse, "\n")


r_squared <- 1 - sum((Valid$discharge - predictions)^2) / sum((Valid$discharge - mean(Valid$discharge))^2)


cat("Coefficient of Determination (R-squared):", r_squared, "\n")








