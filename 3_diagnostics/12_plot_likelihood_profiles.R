##############################################################################
# Generic SS3 likelihood profile script
# Profiles over: log(R0), steepness (h), and natural mortality (M)
#
# Requires: r4ss (>= 1.45), an SS3 executable, and a fitted base model
#
# Usage: edit the "USER INPUTS" block below, then source the whole script,
#        or run it section by section.
##############################################################################

library(r4ss)

##############################################################################
# 1. USER INPUTS -- edit these for your assessment
##############################################################################

base_dir   <- base_dir     # folder containing your fitted base model

# new_grow_dir <- paste0(PATH_SENSITIVITES, 's9_new_growth',sep="")
exe_name   <- "ss3_win.exe"                   # "ss" (Linux/Mac) or "ss.exe" (Windows), no extension needed if on PATH
run_extras <- "-nohess -maxfn 5000"              # skip hessian for speed; use "" if you want it

# Which parameters to profile. Set to FALSE to skip one.
do_R0 <- TRUE
do_h  <- FALSE
do_M  <- TRUE

# --- log(R0) profile range ---
# Centered automatically on the base model MLE unless you set explicit values
R0_range   <- c(-1.0, 2.0)   # +/- range around base MLE, in log(R0) units
R0_step    <- 0.2

# --- steepness (h) profile range ---
# If h is ESTIMATED in your model, leave h_vec <- NULL and it will
# auto-center on the base MLE, same as R0 and M below.
# If h is FIXED (typical for tuna models, e.g. run separately at 0.70/0.80/0.90),
# there's no meaningful MLE to center on, so set explicit values here instead.
h_vec      <- seq(0.5, 1.0, by = 0.05)   # set to NULL to auto-center instead

# --- natural mortality (M) profile range ---
# +/- proportion of the base M value (e.g., 0.5 = -50% to +50%)
M_range_pct <- c(0.5, 2)   # multiplicative range around base M
M_step_pct  <- 0.1           # step size as a proportion of base M

##############################################################################
# 2. HELPER FUNCTION -- runs one profile for a given parameter string
##############################################################################

run_profile <- function(par_string, par_parstring, profile_vec, subfolder,
                        base_dir, exe_name, run_extras,
                        low_bound = NULL, high_bound = NULL) {
  
  prof_dir <- file.path(base_dir, subfolder)
  dir.create(prof_dir, showWarnings = FALSE, recursive = TRUE)
  
  # copy base model files into profile subfolder
  file.copy(list.files(base_dir, full.names = TRUE, no.. = TRUE),
            prof_dir, overwrite = TRUE)
  # remove any stray subfolders accidentally copied (e.g. old profile dirs)
  unlink(list.dirs(prof_dir, recursive = FALSE), recursive = TRUE)
  file.copy(list.files(base_dir, full.names = TRUE)[
    !file.info(list.files(base_dir, full.names = TRUE))$isdir],
    prof_dir, overwrite = TRUE)
  
  # point starter file at the .par and a modifiable control file
  starter <- SS_readstarter(file.path(prof_dir, "starter.ss"))
  starter$init_values_src <- 1
  starter$ctlfile <- "control_modified.ss"
  SS_writestarter(starter, dir = prof_dir, overwrite = TRUE)
  
  # run the profile
  prof_out <- profile(
    dir         = prof_dir,
    oldctlfile  = "control.ss_new",
    newctlfile  = "control_modified.ss",
    string      = par_string,
    parstring   = par_parstring,
    profilevec  = profile_vec,
    exe         = exe_name,
    extras      = run_extras,
    usepar      = TRUE
  )
  
  # read all profile runs back in
  prof_models <- SSgetoutput(dirvec = prof_dir, keyvec = 1:length(profile_vec))
  prof_summary <- SSsummarize(prof_models)
  
  list(dir = prof_dir, models = prof_models, summary = prof_summary,
       profile_vec = profile_vec, par_string = par_string)
}

##############################################################################
# 2b. HELPER -- filter out non-converged profile runs before plotting
##############################################################################

build_conv_summary <- function(prof, maxgrad_thresh = 0.001) {
  converged <- prof$summary$maxgrad < maxgrad_thresh
  if (!all(converged)) {
    warning(sum(!converged), " of ", length(converged),
            " profile runs for '", prof$par_string,
            "' did not converge (maxgrad >= ", maxgrad_thresh,
            ") and were excluded from the plot.")
  }
  if (sum(converged) < 2) {
    warning("Fewer than 2 converged runs for '", prof$par_string,
            "' -- falling back to the full (unfiltered) summary.")
    return(prof$summary)
  }
  SSsummarize(prof$models[converged])
}

##############################################################################
# 3. GET BASE MODEL MLE VALUES (used to auto-center R0 and M ranges)
##############################################################################

base_out <- SS_output(dir = base_dir, verbose = FALSE, printstats = FALSE)
# new_grow_out <- SS_output(dir = new_grow_dir, verbose = FALSE, printstats = FALSE)

base_logR0 <- base_out$parameters[
  grepl("SR_LN\\(R0\\)", base_out$parameters$Label), "Value"]

base_M <- base_out$parameters[
  grepl("^NatM_break_1_Fem_GP_1", base_out$parameters$Label), "Value"][1]  # female M; adjust label if your model differs

# grow_M <- new_grow_out$parameters[
# grepl("^NatM_uniform_Fem_GP_1", new_grow_out$parameters$Label), "Value"][1]  # female M; adjust label if your model differs

# steepness: only used if h_vec is NULL (i.e. h is estimated and you want
# an auto-centered range); check whether it's actually estimated (Phase > 0)
h_row <- base_out$parameters[grepl("steep", base_out$parameters$Label,
                                   ignore.case = TRUE), ]
base_h <- h_row$Value[1]
h_is_estimated <- !is.null(h_row$Phase) && h_row$Phase[1] > 0

if (is.null(h_vec)) {
  if (!h_is_estimated) {
    warning("h_vec was NULL but steepness appears to be FIXED in the base ",
            "model -- auto-centering on a fixed value is not very informative. ",
            "Consider setting h_vec explicitly (e.g. seq(0.5, 1.0, by = 0.05)).")
  }
  h_range_default <- c(-0.2, 0.2)  # +/- around base_h
  h_step_default  <- 0.05
  h_vec <- seq(max(0.21, base_h + h_range_default[1]),  # 0.21 = SS3 lower bound for BH steepness
               min(1.0,  base_h + h_range_default[2]),
               by = h_step_default)
}

##############################################################################
# 4. RUN PROFILES
##############################################################################

results <- list()

## --- log(R0) ---
if (do_R0) {
  R0_vec <- seq(base_logR0 + R0_range[1],
                base_logR0 + R0_range[2],
                by = R0_step)
  
  results$R0 <- run_profile(
    par_string  = "SR_LN(R0)",
    par_parstring = "SRparm[1]",
    profile_vec = R0_vec,
    subfolder   = "profile_R0",
    base_dir = base_dir, exe_name = exe_name, run_extras = run_extras
  )
}

## --- steepness (h) ---
if (do_h) {
  results$h <- run_profile(
    par_string  = "SR_BH_steep",   # adjust label if using a different SR function
    par_parstring = "SRparm[2]",
    profile_vec = h_vec,
    subfolder   = "profile_h",
    base_dir = base_dir, exe_name = exe_name, run_extras = run_extras
  )
}

## --- natural mortality (M) ---
if (do_M) {
  M_vec <- seq(base_M * M_range_pct[1],
               base_M * M_range_pct[2],
               by = base_M * M_step_pct)
  
  results$M <- run_profile(
    par_string  = "NatM_break_1_Fem_GP_1",  # matches your 2-sex control file label
    par_parstring = "MGparm[1]",
    profile_vec = M_vec,
    subfolder   = "profile_M",
    base_dir = base_dir, exe_name = exe_name, run_extras = run_extras
  )
}


##############################################################################
# 4b. RELOAD AN EXISTING PROFILE FROM DISK (skip if results$M already in memory)
##############################################################################

# Only needed if you're in a fresh R session and results$M no longer exists,
# but the profile_M/ subfolder from a previous run is still on disk.

# reload_profile <- function(par_string, subfolder, base_dir, n_runs) {
#   prof_dir <- file.path(base_dir, subfolder)
#   
#   if (!dir.exists(prof_dir)) {
#     stop("Can't find ", prof_dir, " -- the profile folder doesn't exist, ",
#          "so you'll need to rerun the profile itself.")
#   }
#   
#   prof_models <- SSgetoutput(dirvec = prof_dir, keyvec = 1:n_runs)
#   prof_summary <- SSsummarize(prof_models)
#   
#   list(dir = prof_dir, models = prof_models, summary = prof_summary,
#        profile_vec = NULL, par_string = par_string)
# }
# 
# # Rebuild M_vec exactly as it was when you ran the profile (needed for
# # n_runs and for correct x-axis values in the plot). This just recomputes
# # the vector from your USER INPUTS -- it doesn't rerun any models.
# base_out <- SS_output(dir = base_dir, verbose = FALSE, printstats = FALSE)
# base_M <- base_out$parameters[
#   grepl("^NatM_break_1_Fem_GP_1", base_out$parameters$Label), "Value"][1]
# 
# M_vec <- seq(base_M * M_range_pct[1],
#              base_M * M_range_pct[2],
#              by = base_M * M_step_pct)
# 
# results <- list()
# results$M <- reload_profile(
#   par_string = "NatM_break_1_Fem_GP_1",
#   subfolder  = "profile_M",
#   base_dir   = base_dir,
#   n_runs     = length(M_vec)
# )
# results$M$profile_vec <- M_vec

# base_logR0 <- base_out$parameters[
#   grepl("SR_LN\\(R0\\)", base_out$parameters$Label), "Value"]
# 
# R0_vec <- seq(base_logR0 + R0_range[1],
#               base_logR0 + R0_range[2],
#               by = R0_step)
# 
# results$R0 <- reload_profile(
#   par_string = "SR_LN(R0)",
#   subfolder  = "profile_R0",
#   base_dir   = base_dir,
#   n_runs     = length(R0_vec)
# )
# results$R0$profile_vec <- R0_vec

##############################################################################
# 5. PLOT EACH PROFILE (reproduces the Total + component-by-component figure)
##############################################################################

plot_dir <- file.path(base_dir, "profile_plots")
dir.create(plot_dir, showWarnings = FALSE)

rename_profile_plots <- function(plotdir, prefix) {
  files <- list.files(plotdir, pattern = "^profile_plot.*\\.png$", full.names = TRUE)
  file.rename(files, file.path(plotdir, paste0(prefix, "_", basename(files))))
}

if (do_R0) {
  R0_summary_conv <- build_conv_summary(results$R0)
  SSplotProfile(R0_summary_conv, profile.string = "SR_LN\\(R0\\)",
                profile.label = "Log(R0)", print = TRUE, plotdir = plot_dir)
  rename_profile_plots(plot_dir, "R0")
}

if (do_h) {
  h_summary_conv <- build_conv_summary(results$h)
  SSplotProfile(h_summary_conv, profile.string = "SR_BH_steep",
                profile.label = "Steepness (h)", print = TRUE, plotdir = plot_dir)
  rename_profile_plots(plot_dir, "h")
}

if (do_M) {
  M_summary_conv <- build_conv_summary(results$M)
  SSplotProfile(M_summary_conv, profile.string = "NatM_break_1_Fem_GP_1",
                profile.label = "Natural mortality (M)", print = TRUE, plotdir = plot_dir)
  rename_profile_plots(plot_dir, "M")
}

##############################################################################
# 6. OPTIONAL: piner plots (component-specific R0 profile, common in tuna RFMO docs)
##############################################################################

if (do_R0) {
  PinerPlot(
    R0_summary_conv,
    profile.string = "SR_LN\\(R0\\)",
    profile.label  = "Log(R0)",
    print   = TRUE,
    plotdir = plot_dir)
  rename_profile_plots(plot_dir, "R0_PINER")
  
}

##############################################################################
# NOTES
##############################################################################
# - Parameter label strings (par_string) must exactly match the labels in
#   your control.ss_new file. Common variants to check/adjust:
#     * Steepness: "SR_BH_steep" (Beverton-Holt) vs "SR_Ricker_steep" (Ricker)
#     * M label: "NatM_uniform_Fem_GP_1" is typical for a single-sex/uniform-M
#       setup; multi-sex or age-varying M models will have different labels
#       (e.g. "NatM_uniform_Fem_GP_1", "NatM_p_1_Mal_GP_1"). Run
#       base_out$parameters$Label and grep "NatM" to check yours.
# - If M or h is NOT estimated in your base model (common for tuna, since you
#   said h is fixed at 0.7/0.8/0.9), SS_profile still works: it just fixes
#   the parameter at each profile value in turn and re-optimizes everything
#   else, same as if it were estimated. No special flag is needed --
#   SS_profile handles both fixed and estimated parameters identically.
# - For large/slow models, consider parallelizing profile runs with the
#   `parallel` or `foreach` packages instead of running SS_profile's
#   internal loop; r4ss's run_SS_profile() (r4ss >= 1.46) supports
#   multithreaded profile runs as an alternative to SS_profile().
# - build_conv_summary() (Section 2b) filters out any profile runs whose
#   maxgrad exceeds 0.001 before plotting, and warns you how many were
#   dropped. Adjust maxgrad_thresh in the function call if you want a
#   stricter/looser convergence criterion.
##############################################################################