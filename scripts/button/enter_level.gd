extends SetSceneBehavior

@export var level: int

func _ready() -> void:
	if SaveSystem.get_data().levels_completed + 1 < level:
		button.disabled = true
	super._ready()

func pressed() -> void:
	if SaveSystem.get_data().levels_completed + 1 < level:
		button.disabled = true
		return
	super.pressed()
