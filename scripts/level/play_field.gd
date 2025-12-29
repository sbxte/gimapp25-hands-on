class_name PlayField
extends Node2D

@export_subgroup("Grid")
@export var snap_vec: Vector2 = Vector2(64, 64)
@export var grid_size := Vector2i(4, 4)

var dragging: bool = false
var path: Array[Vector2] = []
var first_cat: Cat
var match_streak := 0

var level: int = 1
var max_pairs := -1
var cats :int
var stages := 5
var stages_cleared := 1
var time_bonus: int
var endless_mode := false
var endless_mode_jingle_played := false
var game_finished = false

var anim_bytes: PackedByteArray = []
var anim_frame: int = 0
var anim_cats: PackedByteArray = []
var anim_cats_ref: Array = []
var anim_first_frame_time: int

@export_subgroup("References")
@export var cat_scene: PackedScene
@export var timer: TimerController
@export var cat_generator: AbstractLevelGen

@export var cat_notif_controller: NewCatNotifController

signal drag_start(start: Vector2)
signal drag_end(end: Vector2, attempt_match: bool, correct_match: bool)

func _ready() -> void:
	Events.cat_mouse_click.connect(cat_mouse_click)
	Events.cancel_drag.connect(cancel_drag)

	timer.timer_ended.connect(on_defeat)

	Events.pre_set_scene.connect(func():
		if endless_mode:
			SaveSystem.save_highscore(stages_cleared)
	)

func _process(_delta: float) -> void:
	if anim_bytes.size() != 0:
		queue_redraw()

	if game_finished:
		return

	if endless_mode and not endless_mode_jingle_played:
		AudioManager.stop_all_music()
		AudioManager.enter_endless_mode.finished.connect(func(): AudioManager.music.play(), CONNECT_ONE_SHOT)
		AudioManager.enter_endless_mode.play()
		endless_mode_jingle_played = true

	if not dragging:
		return

	var last_path_point := path[path.size() - 1]
	var offset := (get_local_mouse_position() - last_path_point).snapped(snap_vec)
	var cardinalized := cardinalize(offset)
	if not cardinalized.is_zero_approx():
		var prev := global_position + last_path_point
		var intersection := get_world_2d().direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(prev, prev + cardinalized))
		if intersection:
			attempt_match((intersection.get("collider") as Node).get_parent() as Cat)
		else:
			append_path(last_path_point + cardinalized)

	confine_to_play_area()

func _unhandled_input(event: InputEvent) -> void:
	# When the mouse is released on nothing, clear the line path
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and dragging:
			AudioManager.deselect.play()
			erase_path(false)


func _draw() -> void:
	if anim_bytes.size() != 0:
		draw_badapple_frame()

	# The path array consists of points in the path
	# To draw the whole line, draw line segments connecting each point
	if path.size() < 2:
		return
	draw_polyline(path, Color.GREEN, 5)

func draw_badapple_frame() -> void:
	if anim_frame >= 6572:
		return

	var elapsed := Time.get_ticks_msec() - anim_first_frame_time
	if (elapsed) * 30 / 1000 < anim_frame:
		return
	
	for row in range(18):
		for col in range(24):
			var arr_idx = row * 24 + col
			var next: int = anim_bytes[anim_frame * (24 * 18) + arr_idx]
			var prev: int = anim_cats[arr_idx]
			if next == 0 and prev == 255:
				var pos := - Vector2(snap_vec.x * grid_size.x / 2, snap_vec.y * grid_size.y / 2) + Vector2(snap_vec.x * col, snap_vec.y * row) + Vector2(snap_vec) / 2

				var instance: Cat = cat_scene.instantiate()
				instance.position = pos
				instance.set_type(randi_range(1, 8))
				instance.scale *= 0.25
				instance.add_to_group("Cats")
				anim_cats_ref[arr_idx] = instance
				anim_cats[arr_idx] = 0
				add_child(instance)
			elif next != 0 and prev == 0: 
				var instance: Cat = anim_cats_ref[arr_idx]
				instance.free()
				anim_cats[arr_idx] = 255
				anim_cats_ref[arr_idx] = null

	anim_frame += 1

func cancel_drag() -> void:
	erase_path(false)

func cat_mouse_click(pos: Vector2, cat: Cat) -> void:
	if not dragging:
		start_path(pos - position, cat)

func attempt_match(cat: Cat) -> void:
	badapple()

	if cat == first_cat:
		return

	# When the mouse enters a cat that isn't the same type,
	# delete the path, speed up timer, and reset streak
	if cat.type != first_cat.type:
		erase_path(true, false)
		if randf() < 0.01:
			AudioManager.rare_wrongmatch.play()
		else:
			AudioManager.wrongmatch.play()
		timer.set_speed(timer.get_speed() + 1)
		match_streak = 0
		return

	# FIX: Path simply disappears and does not visually connect to the paired cat
	erase_path(true, true)
	AudioManager.deselect.play()

	notify_if_new_cat(cat.type)

	# Delete cats
	cat.queue_free()
	first_cat.queue_free()
	cats -= 2
	if cats == 0:
		stages_cleared += 1
		if not endless_mode:
			# badapple()

			timer.add_time(time_bonus)
			if stages_cleared > stages:
				on_victory()
			else:
				on_next_stage()
		else:
			timer.start_duration = 30. / pow(stages_cleared, log(3) / log(15))
			on_next_stage()

	match_streak += 1
	if match_streak == 2:
		timer.reset_speed()

func badapple() -> void:
	# Do this only once
	if anim_bytes.size() != 0:
		return

	timer.stop()

	grid_size = Vector2i(24, 18)
	snap_vec *= 0.25

	for c in get_tree().get_nodes_in_group("Cats"):
		c.queue_free()
	
	anim_cats.resize(24 * 18)
	anim_cats.fill(255)

	anim_cats_ref.resize(24 * 18)
	anim_cats_ref.fill(null)

	anim_first_frame_time = Time.get_ticks_msec()

	# Load all PGMs into memory
	for frame in range(1, 6572 + 1):
		var file: PackedByteArray = FileAccess.get_file_as_bytes("res://badapple_frames/downscaled_%04d.pgm" % frame)
		anim_bytes.append_array(file.slice(13))

	queue_redraw()

	# # Halt further processing
	# while true:
	# 	pass

func on_next_stage() -> void:
	Events.update_stage.emit(stages_cleared)
	AudioManager.next_stage.play()
	timer.reset()
	reset_cats()

func start_path(pos: Vector2, cat: Cat) -> void:
	first_cat = cat
	dragging = true
	drag_start.emit(pos)
	path.clear()
	path.push_back(pos)
	notify_if_new_cat(cat.type)
	queue_redraw()
	AudioManager.select.play()

func erase_path(attempt_match: bool, correct_match: bool = false) -> void:
	AudioManager.trace.stop()
	dragging = false
	if not path.is_empty():
		if attempt_match:
			Events.trigger_speech.emit(correct_match)

		drag_end.emit(path.back(), attempt_match, correct_match)
	path.clear()
	queue_redraw()

func append_path(pos: Vector2) -> void:
	var prev_idx := path.find(pos)
	if prev_idx != -1:
		path.resize(prev_idx + 1)
	else:
		path.push_back(pos)
	queue_redraw()
	play_trace()

func play_trace() -> void:
	if not AudioManager.trace.playing:
		AudioManager.trace.play()

func reset_cats() -> void:
	cats = grid_size.x * grid_size.y
	if max_pairs != -1:
		cats = mini(cats, max_pairs * 2)
	for cat in get_tree().get_nodes_in_group("Cats"):
		cat.queue_free()
	cat_generator.gen_cats(grid_size, snap_vec, max_pairs, cat_scene, self)

# Cancel drag when mouse exists play area
func confine_to_play_area() -> void:
	var play_area := grid_size / 2 + 2 * Vector2i.ONE
	var play_area_scaled := Vector2(play_area.x * snap_vec.x, play_area.y * snap_vec.y)
	var offset := get_local_mouse_position()
	if abs(offset.x) > play_area_scaled.x or abs(offset.y) > play_area_scaled.y:
		erase_path(false)
		AudioManager.deselect.play()

func cardinalize(vec: Vector2) -> Vector2:
	if abs(vec.x) > abs(vec.y):
		vec.y = 0
	else:
		vec.x = 0
	return vec

func notify_if_new_cat(type: int) -> void:
	if SaveSystem.get_data().cats_encountered[type - 1]:
		return

	SaveSystem.get_data().cats_encountered[type - 1] = true
	SaveSystem.get_data().cats_encountered[type - 1] = true
	cat_notif_controller.new_cat(type)
	SaveSystem.write_data()

# Player lost!
# oh no, anyway
func on_defeat() -> void:
	if game_finished:
		return

	if endless_mode:
		Events.on_defeat_endless_mode.emit(stages_cleared)
	else:
		Events.on_defeat.emit()
		game_finished = true
		timer.queue_free()

func on_victory() -> void:
	if game_finished:
		return

	Events.on_victory.emit(level)
	game_finished = true
	timer.queue_free()

class AnimFrame:
	var pixels: PackedByteArray
