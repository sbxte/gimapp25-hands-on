extends SetSceneBehavior

@export_range(0, 5, 1) var threshold: int

func _ready() -> void:
	if SaveSystem.get_data().levels_completed < threshold:
		button.disabled = true
	super._ready()

func pressed() -> void:
	if SaveSystem.get_data().levels_completed < threshold:
		button.disabled = true
		return
	super.pressed()
