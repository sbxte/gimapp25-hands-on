class_name SaveData
extends Resource

# Defaults are set as the values you have when first launching the game
# Aka fresh start

# Volumes
@export var vol_master := 1.
@export var vol_sfx := 1.
@export var vol_music := 1.

# Prologue and epilogue
@export var has_seen_prologue := false
@export var has_seen_epilogue := false

# What is the highest level that has been completed
@export var levels_completed := -1

# How many stages have been cleared in endless mode
@export var endless_mode_stages_cleared := 0

@export var cats_encountered: Array[bool] = [
	false, false, false, false,
	false, false, false, false
]
