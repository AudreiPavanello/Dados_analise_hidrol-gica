pacman::p_load("tidyverse",
               "tidymodels",
               "caret",
               "rio",
               "here",
               "openxlsx",     
               'readxl')  


set.seed(1)


# Split test and train sets
split_ <- sample(nrow(df), 0.9*nrow(df), replace = FALSE)
train <- df[split_,]
test <- df[-split_,]


# Define the recipe for preprocessing
nn_recipe <- recipe(discharge ~ precip + eto, data = train) %>%
 step_center(all_predictors()) %>%
 step_scale(all_predictors()) %>%
 prep(training = train , retain = TRUE)


# Create a neural network specification
nn_spec <- mlp(hidden_units = 50, epochs = 50, activation =  "relu") %>%
  set_engine("keras") %>%
  set_mode("regression")

# Combine recipe and model specification into a workflow
nn_wf <- workflow() %>%
  add_recipe(nn_recipe) %>%
  add_model(nn_spec)


# Train the model
nn_fit <- nn_wf %>%
  fit(data = train)

# Make predictions
predictions <- nn_fit %>%
  predict(new_data = test)


## Metrics for the model

postResample(pred = predictions, obs = test$discharge)

pred <- tribble(~ precip, ~ eto, 2.65, 2.3)

predict(nn_fit, new_data = pred)


## Predicted values

discharge_test <- bind_cols(predictions, test %>% select(discharge, datetime))
discharge_test


# Create a scatter plot with observed and predicted values and lines connecting them
ggplot(discharge_test, aes(x = datetime)) +
  geom_point(aes(y = discharge, color = "Observed"), size = 3) +
  geom_point(aes(y = .pred, color = "Predicted"), size = 3) +
  geom_line(aes(y = discharge, color = "Observed"), size = 1, alpha = 0.5) +
  geom_line(aes(y = .pred, color = "Predicted"), size = 1, alpha = 0.5) +
  labs(title = "Observed vs. Predicted Values with Connecting Lines",
       x = "Date and Time",
       y = "Value") +
  scale_color_manual(values = c("Observed" = "blue", "Predicted" = "red")) +
  theme_minimal()
