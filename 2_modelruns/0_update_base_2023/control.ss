#C file created using an r4ss function
#C file write time: 2026-11-18  15:17:27
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
2 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
4 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	 1	1	0	#_recr_dist_pattern1
1	 4	1	0	#_recr_dist_pattern2
1	 7	1	0	#_recr_dist_pattern3
1	10	1	0	#_recr_dist_pattern4
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
3 #_Nblock_Patterns
5 5 1 #_blocks_per_pattern
#_begin and end years of blocks
1960 1988 1989 1993 1994 1998 1999 2003 2004 2009
1960 1976 1977 1984 1985 1992 1993 2000 2001 2009
1949 1949
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
1 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
5 #_N_breakpoints
0 1 2 3 4 # age(real) at M breakpoints
2 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0.1 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
3 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
0.075	       2	     0.8	     0.8	  1	6	 -5	0	0	   0	   0	0.5	0	0	#_NatM_p_1_Fem_GP_1  
   -3	       3	       0	       0	  1	6	 -7	0	0	   0	   0	0.5	0	0	#_NatM_p_2_Fem_GP_1  
   -3	       3	       0	       0	  1	6	 -7	0	0	   0	   0	0.5	0	0	#_NatM_p_3_Fem_GP_1  
   -3	       3	       0	       0	  1	6	 -6	0	0	   0	   0	0.5	0	0	#_NatM_p_4_Fem_GP_1  
   -3	       3	       0	       0	  1	6	 -6	0	0	   0	   0	0.5	0	0	#_NatM_p_5_Fem_GP_1  
    0	      30	 5.89629	      20	100	6	 -5	0	0	   0	   0	0.5	0	0	#_L_at_Amin_Fem_GP_1 
   50	     100	 70.3509	    70.2	100	6	 -5	0	0	   0	   0	0.5	0	0	#_L_at_Amax_Fem_GP_1 
   -3	       3	 0.34809	   0.373	100	6	 -1	0	0	   0	   0	0.5	0	0	#_VonBert_K_Fem_GP_1 
    0	       5	  2.9096	       1	  1	0	 -5	0	0	   0	   0	  0	0	0	#_Richards_Fem_GP_1  
 0.01	      60	     0.2	     0.2	100	6	 -5	0	0	   0	   0	0.5	0	0	#_CV_young_Fem_GP_1  
   -3	       3	   -0.69	   -0.69	100	6	 -5	0	0	   0	   0	0.5	0	0	#_CV_old_Fem_GP_1    
   -3	       3	4.97e-06	4.97e-06	100	6	 -1	0	0	   0	   0	0.5	0	0	#_Wtlen_1_Fem_GP_1   
    2	       4	 3.39292	 3.39292	100	6	 -1	0	0	   0	   0	0.5	0	0	#_Wtlen_2_Fem_GP_1   
    1	     150	      38	      38	100	6	 -1	0	0	   0	   0	0.5	0	0	#_Mat50%_Fem_GP_1    
   -8	       1	   -1.25	   -1.25	100	6	 -1	0	0	   0	   0	0.5	0	0	#_Mat_slope_Fem_GP_1 
    0	       2	       1	       1	100	6	 -1	0	0	   0	   0	0.5	0	0	#_Eggs_alpha_Fem_GP_1
   -1	       1	       0	       0	100	6	 -1	0	0	   0	   0	0.5	0	0	#_Eggs_beta_Fem_GP_1 
   -4	       4	       0	       0	 99	0	 -3	0	0	   0	   0	0.5	0	0	#_RecrDist_GP_1      
   -4	       4	       0	       0	 99	0	 -3	0	0	   0	   0	0.5	0	0	#_RecrDist_Area_1    
   -4	       4	       0	       0	 99	0	 -3	0	0	   0	   0	0.5	0	0	#_RecrDist_month_1   
   -4	       4	       0	       0	0.1	6	  5	0	1	1983	2018	  5	0	0	#_RecrDist_month_2   
   -4	       4	       0	       0	0.1	6	  5	0	1	1983	2018	  5	0	0	#_RecrDist_month_3   
   -4	       4	       0	       0	0.1	6	  5	0	1	1983	2018	  5	0	0	#_RecrDist_month_4   
  0.1	      10	       1	       1	  1	6	 -1	0	0	   0	   0	0.5	0	0	#_CohortGrowDev      
1e-06	0.999999	     0.5	     0.5	0.5	0	-99	0	0	   0	   0	  0	0	0	#_FracFemale_GP_1    
#_timevary MG parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
1e-04	   2	0.3	0.3	0.5	6	-5	#_RecrDist_month_2_dev_se      
-0.99	0.99	  0	  0	0.5	6	-6	#_RecrDist_month_2_dev_autocorr
1e-04	   2	0.3	0.3	0.5	6	-5	#_RecrDist_month_3_dev_se      
-0.99	0.99	  0	  0	0.5	6	-6	#_RecrDist_month_3_dev_autocorr
1e-04	   2	0.3	0.3	0.5	6	-5	#_RecrDist_month_4_dev_se      
-0.99	0.99	  0	  0	0.5	6	-6	#_RecrDist_month_4_dev_autocorr
# info on dev vectors created for MGparms are reported with other devs after tag parameter section
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
6 #_Spawner-Recruitment; 2=Ricker (2 parms); 3=std_B-H(2); 4=SCAA(2);5=Hockey(3); 6=B-H_flattop(2); 7=Survival(3);8=Shepard(3);9=Ricker_Power(3);10=B-H_a,b(4)
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
    0	  35	 20	 20	 10	6	 1	0	0	0	0	0	0	0	#_SR_LN(R0)       
0.201	0.99	0.8	0.8	 10	6	-2	0	0	0	0	0	0	0	#_SR_BH_flat_steep
    0	   2	0.3	0.3	0.8	6	-4	0	0	0	0	0	0	0	#_SR_sigmaR       
   -5	   5	  0	  0	  1	6	-4	0	0	0	0	0	0	0	#_SR_regime       
    0	 0.5	  0	  0	 99	0	-2	0	0	0	0	0	0	0	#_SR_autocorr     
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1983 # first year of main recr_devs; early devs can preceed this era
2021 # last year of main recr_devs; forecast devs start in following year
4 #_recdev phase
1 # (0/1) to read 13 advanced options
0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
-4 #_recdev_early_phase
-10 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1960 #_last_yr_nobias_adj_in_MPD; begin of ramp
1983 #_first_yr_fullbias_adj_in_MPD; begin of plateau
2021 #_last_yr_fullbias_adj_in_MPD
2021 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
1 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-15 #min rec_dev
15 #max rec_dev
0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
#Fishing Mortality info
0.15 # F ballpark
2000 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
7 # max F or harvest rate, depends on F_Method
5 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    8	1	0	0	0	1	#_PL_CPUE       
    9	1	0	0	0	1	#_PSLS_CPUE_LONG
   10	1	0	0	0	1	#_BAI_CPUE      
   11	1	0	0	0	1	#_Behaviour_CPUE
-9999	0	0	0	0	0	#_terminator    
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-25	25	-22.9567	0	1	0	-1	0	0	0	0	0	0	0	#_LnQ_base_PL_CPUE(8)        
-25	25	-22.5903	0	1	0	-1	0	0	0	0	0	0	0	#_LnQ_base_PSLS_CPUE_LONG(9) 
-25	25	-19.3442	0	1	0	-1	0	0	0	0	0	0	0	#_LnQ_base_BAI_CPUE(10)      
-25	25	-19.3442	0	1	0	-1	0	0	0	0	0	0	0	#_LnQ_base_Behaviour_CPUE(11)
#_no timevary Q parameters
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
27	0	0	7	#_1 PL             
27	0	0	5	#_2 PSLS           
27	0	0	5	#_3 PSFS           
24	0	0	0	#_4 GL             
24	0	0	0	#_5 LI             
 1	0	0	0	#_6 LL             
24	0	0	0	#_7 Other          
 5	0	0	1	#_8 PL_CPUE        
 5	0	0	2	#_9 PSLS_CPUE_LONG 
 5	0	0	2	#_10 BAI_CPUE      
 5	0	0	2	#_11 Behaviour_CPUE
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
11	0	0	0	#_1 PL             
11	0	0	0	#_2 PSLS           
11	0	0	0	#_3 PSFS           
11	0	0	0	#_4 GL             
11	0	0	0	#_5 LI             
11	0	0	0	#_6 LL             
11	0	0	0	#_7 Other          
11	0	0	0	#_8 PL_CPUE        
11	0	0	0	#_9 PSLS_CPUE_LONG 
11	0	0	0	#_10 BAI_CPUE      
11	0	0	0	#_11 Behaviour_CPUE
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
     0	    0	        0	  0	    0	0	-99	0	0	0	0	0.5	0	0	#_SizeSel_Spline_Code_PL(1)     
-0.001	    1	 0.247221	  0	0.001	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_Spline_GradLo_PL(1)   
    -1	0.001	-0.658209	  0	0.001	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_Spline_GradHi_PL(1)   
    10	  100	  22.6447	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_1_PL(1)   
    10	  100	  37.5977	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_2_PL(1)   
    10	  100	  42.0377	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_3_PL(1)   
    10	  100	   45.702	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_4_PL(1)   
    10	  100	  51.7386	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_5_PL(1)   
    10	  100	  59.9904	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_6_PL(1)   
    10	  100	  71.3145	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_7_PL(1)   
    -9	    7	 -4.42509	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_1_PL(1)     
    -9	    7	  -2.2233	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_2_PL(1)     
    -9	    7	 -1.56912	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_3_PL(1)     
    -9	    7	       -1	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_4_PL(1)     
    -9	    7	 -1.26099	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_5_PL(1)     
    -9	    7	 -0.55179	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_6_PL(1)     
    -9	    7	-0.579285	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_7_PL(1)     
     0	    0	        0	  0	    0	0	-99	0	0	0	0	0.5	0	0	#_SizeSel_Spline_Code_PSLS(2)   
-0.001	    1	 0.622317	  0	0.001	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_Spline_GradLo_PSLS(2) 
    -1	0.001	-0.110388	  0	0.001	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_Spline_GradHi_PSLS(2) 
    10	  100	   23.125	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_1_PSLS(2) 
    10	  100	  41.9035	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_2_PSLS(2) 
    10	  100	  45.6322	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_3_PSLS(2) 
    10	  100	  50.2975	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_4_PSLS(2) 
    10	  100	  70.9228	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_5_PSLS(2) 
    -9	    7	  -8.9974	  0	0.001	1	 -2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_1_PSLS(2)   
    -9	    7	 -2.05844	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_2_PSLS(2)   
    -9	    7	       -1	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_3_PSLS(2)   
    -9	    7	-0.954789	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_4_PSLS(2)   
    -9	    7	 -2.24451	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_5_PSLS(2)   
     0	    0	        0	  0	    0	0	-99	0	0	0	0	0.5	0	0	#_SizeSel_Spline_Code_PSFS(3)   
-0.001	    1	0.0149309	  0	0.001	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_Spline_GradLo_PSFS(3) 
    -1	0.001	-0.245826	  0	0.001	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_Spline_GradHi_PSFS(3) 
    10	  100	  23.1313	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_1_PSFS(3) 
    10	  100	  44.1442	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_2_PSFS(3) 
    10	  100	  48.4634	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_3_PSFS(3) 
    10	  100	  54.7779	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_4_PSFS(3) 
    10	  100	  71.2972	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spline_Knot_5_PSFS(3) 
    -9	    7	 -8.99994	  0	0.001	1	 -2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_1_PSFS(3)   
    -9	    7	 -2.04755	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_2_PSFS(3)   
    -9	    7	       -1	  0	    0	0	-99	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_3_PSFS(3)   
    -9	    7	 -1.02858	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_4_PSFS(3)   
    -9	    7	 -1.20735	  0	0.001	1	  2	0	0	0	0	 -4	0	0	#_SizeSel_Spine_Val_5_PSFS(3)   
    26	   94	       40	 40	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_GL(4)             
    -6	    4	   -1.061	 -3	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_GL(4)             
    -1	    9	    4.714	8.3	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_3_GL(4)             
    -1	    9	        4	  4	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_4_GL(4)             
   -15	   -5	      -10	 -1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_5_GL(4)             
    -5	    9	-0.730581	 -1	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_6_GL(4)             
    26	   94	       40	 40	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_LI(5)             
    -6	    4	   -1.061	 -3	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_LI(5)             
    -1	    9	    4.714	8.3	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_3_LI(5)             
    -1	    9	        4	  4	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_4_LI(5)             
   -15	   -5	      -10	 -1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_5_LI(5)             
    -5	    9	-0.730581	 -1	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_6_LI(5)             
     5	  100	       40	 40	   99	1	  3	0	0	0	0	  0	0	0	#_SizeSel_P_1_LL(6)             
   -12	   40	       10	 10	   99	1	  3	0	0	0	0	  0	0	0	#_SizeSel_P_2_LL(6)             
    26	   94	       40	 40	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_Other(7)          
    -6	    4	   -1.061	 -3	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_Other(7)          
    -1	    9	    4.714	8.3	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_3_Other(7)          
    -1	    9	        4	  4	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_4_Other(7)          
   -15	   -5	      -10	 -1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_5_Other(7)          
    -5	    9	-0.730581	 -1	   99	1	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_6_Other(7)          
     1	    1	        1	  1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_PL_CPUE(8)        
    20	   20	       20	 20	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_PL_CPUE(8)        
     1	    1	        1	  1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_PSLS_CPUE_LONG(9) 
    20	   20	       20	 20	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_PSLS_CPUE_LONG(9) 
     1	    1	        1	  1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_BAI_CPUE(10)      
    20	   20	       20	 20	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_BAI_CPUE(10)      
     1	    1	        1	  1	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_Behaviour_CPUE(11)
    20	   20	       20	 20	   99	1	 -3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_Behaviour_CPUE(11)
#_AgeSelex
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_PL(1)             
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_PL(1)             
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_PSLS(2)           
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_PSLS(2)           
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_PSFS(3)           
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_PSFS(3)           
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_GL(4)             
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_GL(4)             
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_LI(5)             
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_LI(5)             
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_LL(6)             
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_LL(6)             
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_Other(7)          
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_Other(7)          
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_PL_CPUE(8)        
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_PL_CPUE(8)        
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_PSLS_CPUE_LONG(9) 
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_PSLS_CPUE_LONG(9) 
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_BAI_CPUE(10)      
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_BAI_CPUE(10)      
0	8	0	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_1_Behaviour_CPUE(11)
0	8	8	5	99	0	-1	0	0	0	0	0	0	0	#_AgeSel_P_2_Behaviour_CPUE(11)
#_no timevary selex parameters
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
1 # TG_custom:  0=no read; 1=read if tags exist
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_1 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_2 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_3 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_4 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_5 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_6 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_7 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_8 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_9 
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_10
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_11
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_12
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_13
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_14
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_15
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_16
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_17
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_18
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_19
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_20
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_21
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_22
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_23
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_24
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_25
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_26
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_27
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_28
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_29
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_30
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_31
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_32
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_33
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_34
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_35
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_36
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_37
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_38
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_39
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_40
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_41
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_42
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_43
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_44
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_45
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_46
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_47
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_48
-15	10	-10	-10	0.001	1	-4	0	0	0	0	0	0	0	#__TG_Loss_init_49
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_1 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_2 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_3 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_4 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_5 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_6 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_7 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_8 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_9 
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_10
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_11
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_12
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_13
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_14
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_15
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_16
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_17
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_18
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_19
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_20
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_21
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_22
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_23
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_24
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_25
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_26
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_27
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_28
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_29
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_30
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_31
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_32
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_33
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_34
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_35
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_36
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_37
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_38
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_39
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_40
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_41
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_42
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_43
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_44
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_45
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_46
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_47
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_48
-15	10	-4.185	-4.185	0.001	1	-4	0	0	0	0	0	0	0	#_TG_Loss_chronic_49
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_1 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_2 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_3 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_4 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_5 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_6 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_7 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_8 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_9 
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_10
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_11
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_12
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_13
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_14
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_15
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_16
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_17
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_18
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_19
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_20
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_21
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_22
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_23
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_24
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_25
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_26
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_27
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_28
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_29
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_30
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_31
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_32
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_33
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_34
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_35
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_36
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_37
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_38
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_39
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_40
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_41
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_42
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_43
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_44
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_45
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_46
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_47
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_48
1	150	20	20	0.001	1	-4	0	0	0	0	0	0	0	#_TG_overdispersion_49
-20	20	-10	-10	  2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_1
-20	20	 10	 10	0.2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_2
-20	20	 10	 10	0.2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_3
-20	20	-10	-10	  2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_4
-20	20	-10	-10	  2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_5
-20	20	-10	-10	  2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_6
-20	20	-10	-10	  2	1	-4	0	0	0	0	0	0	0	#_TG_report_fleet_par_7
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_1
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_2
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_3
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_4
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_5
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_6
-4	0	0	0	2	6	-4	0	0	0	0	0	0	0	#_TG_report_decay_par_7
# Input variance adjustments factors: 
#_factor	fleet	value
    4	1	0.01	#_Variance_adjustment_list1
    4	2	0.01	#_Variance_adjustment_list2
    4	3	0.01	#_Variance_adjustment_list3
    4	4	0.01	#_Variance_adjustment_list4
    4	5	0.01	#_Variance_adjustment_list5
    4	6	0.01	#_Variance_adjustment_list6
    4	7	0.01	#_Variance_adjustment_list7
-9999	0	   0	#_terminator               
#
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 11 changes to default Lambdas (default value is 1.0)
#_like_comp	fleet	phase	value	sizefreq_method
    1	 8	1	1	1	#_Surv_PL_CPUE_Phz1                  
    1	 9	1	1	1	#_Surv_PSLS_CPUE_LONG_Phz1           
    1	10	1	0	1	#_Surv_BAI_CPUE_Phz1                 
    1	11	1	0	1	#_Surv_Behaviour_CPUE_Phz1           
    4	 1	1	1	1	#_length_PL_sizefreq_method_1_Phz1   
    4	 2	1	1	1	#_length_PSLS_sizefreq_method_1_Phz1 
    4	 3	1	1	1	#_length_PSFS_sizefreq_method_1_Phz1 
    4	 4	1	1	1	#_length_GL_sizefreq_method_1_Phz1   
    4	 5	1	1	1	#_length_LI_sizefreq_method_1_Phz1   
    4	 6	1	1	1	#_length_LL_sizefreq_method_1_Phz1   
    4	 7	1	1	1	#_length_Other_sizefreq_method_1_Phz1
-9999	 0	0	0	0	#_terminator                         
#
0 # 0/1 read specs for more stddev reporting
#
999
