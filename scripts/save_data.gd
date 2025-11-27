class_name SaveData
extends Resource

# Defaults are set as the values you have when first launching the game
# Aka fresh start

@export var has_seen_prologue := false

# What is the highest level that has been completed
@export var levels_completed := 0

# How many stages have been cleared in endless mode
@export var endless_mode_stages_cleared := 0

@export var cats_encountered: Array[bool] = [
	false, false, false, false,
	false, false, false, false
]
