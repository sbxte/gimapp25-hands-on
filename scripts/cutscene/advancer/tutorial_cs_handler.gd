extends Node2D

var play_mode := false
var play_hint := false

var hint_anim_comp: TutorialHintCSComp
var hint_anim_pidx := 0
var hint_anim_points: Array[Vector2]
var hint_anim_timer: Timer

@export var play_field: PlayField

func _ready() -> void:
	Events.cutscene_visibility_changed.connect(func(v: bool): play_mode = not v)
	Events.cutscene_dialog_box_enabled.connect(func(v: bool): play_mode = not v)

	play_field.drag_start.connect(drag_start)
	play_field.drag_end.connect(drag_end)

	Events.cutscene_custom_comp.connect(handle_comp)
	hint_anim_timer = Timer.new()
	hint_anim_timer.one_shot = true
	hint_anim_timer.timeout.connect(hint_anim_timer_finished)
	add_child(hint_anim_timer)

func _unhandled_input(event: InputEvent) -> void:
	if not play_mode:
		if event is InputEventMouseButton:
			var m_event := (event as InputEventMouseButton)
			if m_event.button_index == MOUSE_BUTTON_LEFT and m_event.pressed:
				get_viewport().set_input_as_handled()
				Events.advance_cutscene.emit()
		if event.is_action_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			Events.advance_cutscene.emit()

func _draw() -> void:
	if hint_anim_points.size() < 2:
		return
	draw_polyline(hint_anim_points, Color.ORANGE, 8)

func handle_comp(_node: Node, component: CutsceneComponent) -> void:
	if component is TutorialHintCSComp:
		play_hint = true
		hint_anim_comp = component
		hint_anim_pidx = 0
		hint_anim_points.clear()
		hint_anim_timer.paused = false
		hint_anim_timer.start(0.5)
	elif component is TutorialHintDisableCSComp:
		play_hint = false
		hint_anim_comp = null
		hint_anim_timer.paused = true
		hint_anim_pidx = 0
		hint_anim_points.clear()

func drag_start(point: Vector2) -> void:
	if not play_hint:
		return
	if point - (global_position - play_field.global_position) != transform_point(hint_anim_comp.points[0]):
		Events.cancel_drag.emit()
		return

	hint_anim_timer.start(2.0)
	hint_anim_timer.paused = true
	hint_anim_pidx = 0
	hint_anim_points.clear()
	queue_redraw()

func drag_end(_point: Vector2, matched: bool) -> void:
	if not play_hint:
		return
	if matched:
		play_hint = false
		Events.cutscene_custom_comp_finished.emit()
		Events.advance_cutscene.emit()
		return
	hint_anim_timer.paused = false
	hint_anim_timer.start(2.0)
	animate_hint()

func hint_anim_timer_finished() -> void:
	animate_hint()

func animate_hint() -> void:
	if hint_anim_pidx + 1 > hint_anim_comp.points.size():
		hint_anim_pidx = 0
		hint_anim_points.clear()
	var p := hint_anim_comp.points[hint_anim_pidx]
	var next_point := transform_point(p)
	hint_anim_points.append(next_point)
	hint_anim_pidx += 1
	queue_redraw()
	hint_anim_timer.start(0.2)

func transform_point(p: Vector2i) -> Vector2:
	return Vector2(p.x * play_field.snap_vec.x, p.y * play_field.snap_vec.y) + hint_anim_comp.offset + play_field.global_position - global_position
