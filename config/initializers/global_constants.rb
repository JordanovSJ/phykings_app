# Default image
DEF_IMAGE = "crown.png"

# Problem categories:

CATEGORY = ["Classical mechanics", 
						"Electromagnetism", 
						"Thermodynamics and statistical physics", 
						"Quantum mechanics", 
						"Relativity", 
						"Optics"]
						
LENGTH = [10, 30, 60]

MAX_DIFFICULTY = 10

LENGTH_COMPETITION=[10, 30, 60, 120]

# At every this many votes the problem parameters will refresh
VOTES_REFRESH = 20

#the acceptable range of error of an answer 
MAX_ACPT_ERR=0.05

#maximum picture size in kilobytes
MAX_PIC_SIZE=500


#free gold to get after N_PROBLEMS_FREE_GOLD
FREE_GOLD=1000
#number of problems solved at competition required to get FREE_GOLD free gold
N_PROBLEMS_FREE_GOLD=10


#GOLD
MIN_PREMIUM_ENTRY_GOLD=500
COST_TO_UNLOCK_ANSWER= 100
COST_TO_UNLOCK_SOLUTIONS=500
	#percents
PERCENT=0.1
REPAY_PERCENT=1-PERCENT
COMPETITION_PERCENT_FOR_US=0.1
COMPETITION_PERCENT_FOR_CREATORS=0.05
	#base of the exponent used in the function which determines how much gold any of the players gets
	#rank(n) get gold BASE_GOLD_FUN times more than rank(n+1)
BASE_GOLD_FUN=2


#EXPERIANCE
MAX_EXP_CHANGE_PROBLEM=25
BASE_RANK_EXP=2 #used in competition_helper, method: rank_lvl_change
BASE_EXP=300 #if a user has BASE_EXP less thatn the average in a competition he gets BASE_RANK_EXP time more
RANK_LVL_CHANGE_COEFF=25

# Rescue timer after end of time
RESCUE_TIME = 60
