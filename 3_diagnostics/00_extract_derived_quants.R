##############
# Base and sensitivity Models
##############

mod_update_names <- list.files(PATH_MODELRUNS, full.names = FALSE)
mod_update_names <- grep("^[0-9]", mod_update_names, value = TRUE)
mod_sens_names <- list.files(PATH_SENSITIVITES, full.names = FALSE)
mod_sens_names <- grep("^(s[0-9]|4_update_L50)", mod_sens_names, value = TRUE)# mod_grid_names <- list.files(PATH_GRID, full.names = FALSE)

mod_sens_names <- str_sort(grep("^s[0-9]", mod_sens_names, value = TRUE), numeric = TRUE)
mod_sens_names <- c("4_update_L50",mod_sens_names)

mod_grid_names <- list.files(PATH_GRID, full.names = FALSE)
mod_grid_names <- grep("^skj_", mod_grid_names, value = TRUE)

#### MODEL UPDATES

# mod_update_names <- mod_update_names[c(2:14)]
 # mod_sens_names <- mod_sens_names[c(2:11)]
# mod_grid_names <- mod_grid_names[c(17,21)]

results_list <- lapply(mod_update_names, function(mod_name) {
  mod_path <- file.path(PATH_MODELRUNS, mod_name)
  mod_data <- extract.derived_quantities(path = mod_path)
  current_year <- if (mod_name == "0_update_base_2023" | mod_name == "0_base_2023") 2022 else 2025
  get.mpd.quantities(mod_data, current_year = current_year)
})

# Combine results into one data frame
results_updates <- do.call(rbind, results_list)

# Assign row names
rownames(results_updates) <- mod_update_names

###extract likelihoods

results_list_lik <- lapply(mod_update_names, function(mod_name){
  mod_path <- file.path(PATH_MODELRUNS, mod_name)
  mod_data <- extract.lik(path=mod_path)
  get.mpd.lik(mod_data)
})

results_lik <- do.call(rbind, results_list_lik)
rownames(results_lik) <- mod_update_names

#### MODEL SENSITIVITES

results_list_sens <- lapply(mod_sens_names, function(sens_name) {
  sens_path <- file.path(PATH_SENSITIVITES, sens_name)
  sens_data <- extract.derived_quantities(path = sens_path)
  get.mpd.quantities(sens_data, current_year = 2025)
})

# Combine results into one data frame
results_sens <- do.call(rbind, results_list_sens)

# Assign row names
rownames(results_sens) <- mod_sens_names

###extract likelihoods

results_list_sens_lik <- lapply(mod_sens_names, function(sens_name){
  sens_path <- file.path(PATH_SENSITIVITES, sens_name)
  sens_data <- extract.lik(path=sens_path)
  get.mpd.lik(sens_data)
})

results_sens_lik <- do.call(rbind, results_list_sens_lik)
rownames(results_sens_lik) <- mod_sens_names


#### MODEL GRID

results_list_grid <- lapply(mod_grid_names, function(grid_name) {
  grid_path <- file.path(PATH_GRID, grid_name)
  grid_data <- extract.derived_quantities(path = grid_path)
  get.mpd.quantities(grid_data, current_year = 2024)
})

# Combine results into one data frame
results_grid <- do.call(rbind, results_list_grid)

# Assign row names
rownames(results_grid) <- mod_grid_names

###extract likelihoods

results_list_grid_lik <- lapply(mod_grid_names, function(grid_name){
  grid_path <- file.path(PATH_GRID, grid_name)
  grid_data <- extract.lik(path=grid_path)
  get.mpd.lik(grid_data)
})

results_grid_lik <- do.call(rbind, results_list_grid_lik)
rownames(results_grid_lik) <- mod_grid_names



