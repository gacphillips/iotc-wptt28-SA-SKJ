##############################################################################
# Generic SS3 jitter analysis script
#
# Jitters the starting parameter values around the base model MLE and
# re-optimizes from each, to check for convergence to a global (vs local)
# minimum. Flags any jitter runs that find a BETTER (lower) likelihood than
# the base model -- a sign the base model itself may be stuck on a local min.
#
# Requires: r4ss, an SS3 executable, and a fitted base model
##############################################################################

##############################################################################
# 0. PROJECT SETUP -- edit paths for the current project/assessment
##############################################################################

# figure naming/save helpers (as used across the project's SS3 scripts)
figure_name <- "15_jitter_"
saveplot <- function(label, size = 1, type = "png", res = 800, ...) {
  SavePlot(paste(figure_name, label, sep = ""), type = type, size = size, res = res, ...)
}
savepng <- function(label, width = 21, height = 29.7, units = "cm", res = 800, bg = "white", ...) {
  png(paste(figure_name, label, ".png", sep = ""), width = width, height = height,
      units = units, res = res, bg = bg, ...)
}

##############################################################################
# 1. USER INPUTS -- edit these for your assessment
##############################################################################

base_dir   <- base_dir
# new_base_dir <- new_base_dir
  #base_dir # folder containing your fitted base model
jitter_dir <- file.path(PATH_DIAGNOSTICS, "jitter")          # folder the jitter runs will be copied into/run in
exe_name   <- "ss3_win.exe"                # "ss" (Linux/Mac) or "ss.exe"/"ss3_win" (Windows)
run_extras <- "-maxfn 5000"                # extra command-line flags, single string (see notes)

jitter_fraction <- 0.1                 # magnitude of the jitter (SS3 starter.ss setting)
Njitter         <- 25                  # number of jitter runs

figure_label <- "jitter"               # used in saved plot filename (via saveplot/savepng above)
plot_dir     <- paste0(PATH_DIAGNOSTICS, "jitter/plots")               # where to save the summary plot
ylim_pad     <- 5                      # extra likelihood units of padding above/below for y-axis

##############################################################################
# 2. SET UP JITTER FOLDER
##############################################################################

dir.create(jitter_dir, showWarnings = FALSE, recursive = TRUE)

# copy base model files (not subfolders) into the jitter folder
base_files <- list.files(base_dir, full.names = TRUE)
base_files <- base_files[!file.info(base_files)$isdir]
file.copy(base_files, jitter_dir, overwrite = TRUE)

# point starter file at the .par (init_values_src = 1) and set jitter fraction
starter <- SS_readstarter(file.path(jitter_dir, "starter.ss"))
starter$init_values_src <- 1
starter$jitter_fraction <- jitter_fraction
SS_writestarter(starter, dir = jitter_dir, overwrite = TRUE)

##############################################################################
# 3. READ THE BASE MODEL (for the reference likelihood line on the plot)
##############################################################################

base_out <- SS_output(dir = base_dir, covar = TRUE, forecast = FALSE,
                      verbose = FALSE, printstats = FALSE)

base_nll <- base_out$likelihoods_used[1, 1]  # total -log-likelihood of base model

##############################################################################
# 4. RUN THE JITTER
##############################################################################

jit_likes <- r4ss::jitter(
  dir      = jitter_dir,
  exe      = exe_name,
  Njitter  = Njitter,
  verbose  = TRUE,
  extras   = run_extras
)

##############################################################################
# 5. READ ALL JITTER RUNS BACK IN AND SUMMARIZE
##############################################################################

jit_models  <- SSgetoutput(dirvec = jitter_dir, keyvec = 1:Njitter, getcovar = FALSE)
jit_summary <- SSsummarize(jit_models)

# quick look
jit_summary$likelihoods[1, ]   # total NLL for each jitter run
jit_summary$pars               # parameter estimates for each jitter run

nll_vec <- as.numeric(jit_summary$likelihoods[1, 1:Njitter])

# flag any runs that beat the base model likelihood (lower NLL = better fit)
better_runs <- which(nll_vec < base_nll - 0.01)  # small tolerance for numerical noise
if (length(better_runs) > 0) {
  message(length(better_runs), " jitter run(s) found a BETTER likelihood than ",
          "the base model: run(s) ", paste(better_runs, collapse = ", "),
          ". Base model may not be at the global minimum -- investigate.")
} else {
  message("No jitter run found a better likelihood than the base model. ",
          "Base model appears to be at (or near) the global minimum.")
}

##############################################################################
# 6. PLOT
##############################################################################

setwd(PATH_DIAG_PLOT)
savepng(figure_label, width = 17.78, height = 17.78)


nll_vec <- nll_vec < 10000

plot(1:Njitter, nll_vec,
     xlab = "Jitter run",
     ylab = "Total -log-likelihood",
     type = "p", pch = 16,
     col  = ifelse(nll_vec < base_nll - 0.01, "red", "black"),
     ylim = c(min(c(nll_vec, base_nll)) - ylim_pad,
              max(c(nll_vec, base_nll)) + ylim_pad),
     main = paste0("Jitter analysis (n=", Njitter, ")"))
abline(h = base_nll, col = "blue", lty = 2)
legend("topright", legend = c("Jitter run", "Base model NLL"),
       col = c("black", "blue"), pch = c(16, NA), lty = c(NA, 2), bty = "n")

dev.off()



savepng('base model jitter.png',width=17.78,height=17.78)
par(mfrow=c(1,3),mar=c(5,4,3,1))
plot(1:Njitter,jit_summary$likelihoods[1,1:Njitter],xlab='Jitter runs',ylab='Likelihood',type='p',pch=19,col='red',main='Likelihood',ylim=c(min(jit_summary$likelihoods[1,1:Njitter])-25, max(jit_summary$likelihoods[1,1:Njitter])))
abline(h=base_out$likelihoods_used[1,1])
plot(1:Njitter,jit_summary$maxgrad[1:Njitter],xlab='Jitter runs',ylab='Maxgrad',type='p',pch=19,col='red',main='Maxgrad',ylim=c(min(jit_summary$maxgrad[1:Njitter]),max(jit_summary$maxgrad[1:Njitter])))
abline(h=0.0001)
plot(1:Njitter,jit_summary$SpawnBio[1,1:Njitter],xlab='Jitter runs',ylab='SSB0',type='p',pch=19,col='red',main='SB0',ylim= c(min(jit_summary$SpawnBio[1,1:Njitter]),max(jit_summary$SpawnBio[1,1:Njitter]))) # c(min(Jittersummary$SpawnBio[1,1:Njitter]),max(Jittersummary$SpawnBio[1,1:Njitter]))
abline(h=base_out$derived_quants[1,2])
dev.off()


#######

# ## Check which parameter is causing the issue:
# 
# # base model par values (already read in as base_out)
# base_pars <- base_out$parameters[, c("Label", "Value")]
# 
# # one of the converged-to-2654.24 runs, e.g. run 1
# jit1_pars <- jit_summary$pars[, c("Label", "replist1")]  # column name may be "1" or "replist1" depending on r4ss version
# 
# comp <- merge(base_pars, jit1_pars, by = "Label")
# comp$diff <- comp$replist1 - comp$Value  # jitter minus base
# comp[order(-abs(comp$diff)), ]  # sort by largest absolute difference
# 
# ## Check bounds
# 
# base_out$parameters[base_out$parameters$Status != "OK",
#                     c("Label", "Value", "Min", "Max", "Status")]
# 
# 
# ## Check all 24 models
# 
# pars_mat <- jit_summary$pars[, paste0("replist", 1:Njitter)]
# pars_mat <- pars_mat[, -2]  # drop run 2, the failed/outlier run
# apply(pars_mat, 1, sd)  # low SD across rows = converged runs agree
# 
# 
# base_out$likelihoods_used
# # vs
# jit_summary$likelihoods[, "replist1"] 
# ##############################################################################
# # NOTES
# ##############################################################################
# # - jitter_fraction controls how far starting values are perturbed from the
# #   base model's .par values before each run re-optimizes. 0.1 is a common
# #   default; larger values (e.g. 0.2-0.3) test convergence more aggressively
# #   but may cause more runs to fail/not converge.
# # - r4ss::jitter() calls the SS executable Njitter times inside jitter_dir,
# #   writing numbered output folders/files (or renamed Report.sso etc,
# #   depending on r4ss version) that SSgetoutput() then reads back in.
# # - If some jitter runs fail to converge or crash, SSgetoutput(..., keyvec =
# #   1:Njitter) may error on the missing run(s). Either rerun those manually,
# #   or wrap the call to only read the runs that produced valid output, e.g.:
# #     ok <- file.exists(file.path(jitter_dir, paste0("Report", 1:Njitter, ".sso")))
# #     jit_models <- SSgetoutput(dirvec = jitter_dir, keyvec = which(ok), getcovar = FALSE)
# # - run_extras must be a single string, not a vector, if you need multiple
# #   flags -- e.g. run_extras <- "-nohess -maxfn 5000"
# # - covar = TRUE is used when reading the base model here (for consistency
# #   with typical base model diagnostics elsewhere), but is not required just
# #   for the jitter comparison -- set to FALSE if the base model's covariance
# #   file is large/slow to read and you don't need it elsewhere in your script.
# ##############################################################################
# 
# 
# 
# 
# # pick any of the 24 good runs, e.g. run 1 (skip run 2, the failed one)
# good_run <- 4
# 
# # path to that jitter run's .par file (r4ss jitter typically renames these,
# # check jitter_dir for the exact naming — often ss.par_1.sso or similar)
# good_par <- file.path(jitter_dir, paste0("ss3.par_", good_run, ".sso"))
# # if that exact filename doesn't exist, list files to confirm naming:
# list.files(jitter_dir, pattern = "par")
# 
# # set up a fresh "new base" folder from your original base model
# new_base_dir <- file.path(PATH_DIAGNOSTICS, "base_refit")
# dir.create(new_base_dir, showWarnings = FALSE, recursive = TRUE)
# base_files <- list.files(base_dir, full.names = TRUE)
# base_files <- base_files[!file.info(base_files)$isdir]
# file.copy(base_files, new_base_dir, overwrite = TRUE)
# 
# # overwrite its .par with the good jittered run's .par
# file.copy(good_par, file.path(new_base_dir, "ss.par"), overwrite = TRUE)
# 
# # point starter at the .par (not the control file) and turn jitter OFF
# starter <- SS_readstarter(file.path(new_base_dir, "starter.ss"))
# starter$init_values_src <- 1
# starter$jitter_fraction <- 0
# SS_writestarter(starter, dir = new_base_dir, overwrite = TRUE)
# 
# # re-run
# r4ss::run(dir = new_base_dir, exe = exe_name, extras = run_extras, skipfinished = FALSE)
# 
# 
# 
# refit_out <- SS_output(dir = new_base_dir, covar = TRUE, forecast = FALSE, verbose = FALSE)
# refit_out$likelihoods_used[1, 1]   # should be ~2654.24
# refit_out$maximum_gradient_component
# refit_out$parameters[refit_out$parameters$Status != "OK", c("Label","Value","Status")]
# 
# 
# ##############################################################################
# # Sanity check: compare old base model vs new refit
# ##############################################################################
# 
# # read in the refit model (base_out already holds the old base model from
# # earlier in the script)
# refit_out <- SS_output(dir = new_base_dir, covar = TRUE, forecast = FALSE,
#                        verbose = FALSE, printstats = FALSE)
# 
# # quick numeric check before plotting
# cat("Old base NLL:  ", base_out$likelihoods_used[1, 1], "\n")
# cat("New refit NLL: ", refit_out$likelihoods_used[1, 1], "\n")
# 
# # summarize both models together
# compare_summary <- SSsummarize(list(base_out, refit_out))
# 
# # set model names for clean plot legends
# compare_summary$modelnames <- c("Old base", "New refit")
# 
# ##############################################################################
# # Plot comparisons -- SSB, recruitment, F, and reference points
# ##############################################################################
# 
# setwd(PATH_DIAG_PLOT)  # or wherever you want these saved
# 
# SSplotComparisons(
#   compare_summary,
#   legendlabels = c("Old base", "New refit"),
#   subplots     = c(2, 4, 8, 11),  
#   # 2  = spawning biomass (SSB)
#   # 4  = SSB relative to unfished (depletion)
#   # 8  = recruitment
#   # 11 = summary F
#   print        = TRUE,          # save plots to file
#   plotdir      = PATH_DIAG_PLOT,
#   filenameprefix = "15b_refit_compare_",
#   pdf          = FALSE,
#   new          = TRUE
# )
# 
# ##############################################################################
# # Side-by-side reference points / key derived quantities table
# ##############################################################################
# 
# # grab a handful of key derived quantities for direct numeric comparison
# key_labels <- c("SSB_Virgin", "SSB_Unfished", "Bratio_2025",   # adjust year to your terminal year
#                 "SSB_MSY", "annF_MSY", "Dead_Catch_MSY")
# 
# get_dq <- function(out, labels) {
#   dq <- out$derived_quants
#   dq[dq$Label %in% labels, c("Label", "Value", "StdDev")]
# }
# 
# old_dq <- get_dq(base_out, key_labels)
# new_dq <- get_dq(refit_out, key_labels)
# 
# dq_compare <- merge(old_dq, new_dq, by = "Label", suffixes = c("_old", "_new"))
# dq_compare$pct_change <- 100 * (dq_compare$Value_new - dq_compare$Value_old) / dq_compare$Value_old
# print(dq_compare)
# 
# ##############################################################################
# # Parameter-level comparison (should mostly be the Q's, per earlier diagnosis)
# ##############################################################################
# 
# par_compare <- merge(
#   base_out$parameters[, c("Label", "Value")],
#   refit_out$parameters[, c("Label", "Value")],
#   by = "Label", suffixes = c("_old", "_new")
# )
# par_compare$diff <- par_compare$Value_new - par_compare$Value_old
# par_compare <- par_compare[order(-abs(par_compare$diff)), ]
# 
# # show the biggest movers
# head(par_compare, 15)
# 
# ##############################################################################
# # NOTES
# ##############################################################################
# # - subplots argument numbers correspond to r4ss::SSplotComparisons() options;
# #   run ?SSplotComparisons to see the full list if you want additional panels
# #   (e.g. length/age comps fits, catchability index fits per fleet).
# # - "Bratio_2024" label year must match your model's actual terminal year --
# #   check names(base_out$derived_quants$Label) if unsure of exact label.
# # - A large pct_change in SSB/recruitment/reference points despite the NLL
# #   shift being driven mainly by catchability parameters would be a red flag
# #   worth investigating further (e.g. Q's may be more influential on absolute
# #   scale than expected, or something else moved that wasn't obvious from the
# #   parameter diff table alone).
# ##############################################################################
# 
# ##############################################################################
# # Update control file INIT values with the better starting parameters
# ##############################################################################
# 
# # read the current control file (needs the data file too, for parsing)
# ctl <- SS_readctl(file.path(base_dir, "control.ss"),
#                   datlist = file.path(base_dir, "data.ss"))
# 
# # the parameters that actually differed (from your diff table) --
# # update this vector if the list changes
# changed_pars <- c("LnQ_base_PL_CPUE(8)",
#                   "LnQ_base_Behaviour_CPUE(11)",
#                   "LnQ_base_BAI_CPUE(10)",
#                   "LnQ_base_PSLS_CPUE_LONG(9)")
# 
# # new values from the converged jitter run (run 1, or whichever you picked)
# new_values <- refit_out$parameters[refit_out$parameters$Label %in% changed_pars,
#                                    c("Label", "Value")]
# names(new_values) <- c("Label", "New_INIT")
# print(new_values)