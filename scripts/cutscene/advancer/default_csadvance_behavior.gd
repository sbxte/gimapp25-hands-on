extends Node

var cutscene_visible := true

func _ready() -> void:
	Events.cutscene_visibility_changed.connect(func(v: bool): cutscene_visible = v)

func _unhandled_input(event: InputEvent) -> void:
	if not cutscene_visible:
		return

	if event is InputEventMouseButton:
		var m_event := (event as InputEventMouseButton)
		if m_event.button_index == MOUSE_BUTTON_LEFT and m_event.pressed:
			Events.advance_cutscene.emit()
			get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_accept"):
		Events.advance_cutscene.emit()
		get_viewport().set_input_as_handled()
