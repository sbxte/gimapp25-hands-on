class_name PlayField
extends Node2D

@export var snap_vec: Vector2 = Vector2(64, 64)
@export var grid_size := Vector2i(6, 4)

var dragging: bool = false
var path: Array[Vector2] = []
var first_cat: Cat
var match_streak := 0

var cats :int

@export var cat_scene: PackedScene
@export var timer: TimerController

@export var victory_scene_path: String
@export var defeat_scene_path: String

func _ready() -> void:
	Events.cat_mouse_click.connect(cat_mouse_click)
	Events.cat_mouse_enter.connect(cat_mouse_enter)

	timer.timer_ended.connect(timer_ended)

	timer.reset()

func _process(_delta: float) -> void:
	# When the mouse is released, clear the line path
	# and cancel further processing (return)
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		erase_path()
		return

	if not dragging:
		return

	var last_path_point := path[path.size() - 1]
	var offset := (get_local_mouse_position() - last_path_point).snapped(snap_vec)
	var cardinalized := cardinalize(offset)
	if not cardinalized.is_zero_approx():
		append_path(last_path_point + cardinalized)

	confine_to_play_area()

func _draw() -> void:
	# The path array consists of points in the path
	# To draw the whole line, draw line segments connecting each point
	if path.size() < 2:
		return
	draw_polyline(path, Color.GREEN, 5)

func cat_mouse_click(pos: Vector2, cat: Cat) -> void:
	if not dragging:
		start_path(pos - position, cat)

func cat_mouse_enter(_pos: Vector2, cat: Cat) -> void:
	if not dragging:
		return

	if cat == first_cat:
		return

	# When the mouse enters a cat that isn't the same type,
	# delete the path, speed up timer, and reset streak
	if cat.type != first_cat.type:
		erase_path()
		timer.set_speed(timer.get_speed() + 1)
		match_streak = 0
		return

	# Delete cats
	cat.queue_free()
	first_cat.queue_free()
	cats -= 2
	print(cats)
	if cats == 0:
		SceneManager.change_scene(victory_scene_path, false)

	match_streak += 1
	if match_streak == 2:
		timer.reset_speed()

	# FIX: Path simply disappears and does not visually connect to the paired cat
	erase_path()

func start_path(pos: Vector2, cat: Cat) -> void:
	first_cat = cat
	dragging = true
	path.clear()
	path.push_back(pos)
	queue_redraw()

func erase_path() -> void:
	dragging = false
	path.clear()
	queue_redraw()

func append_path(pos: Vector2) -> void:
	var prev_idx := path.find(pos)
	if prev_idx != -1:
		path.resize(prev_idx + 1)
	else:
		path.push_back(pos)
	queue_redraw()

func reset_cats() -> void:
	cats = grid_size.x * grid_size.y
	for cat in get_tree().get_nodes_in_group("Cats"):
		cat.queue_free()

	LevelGenerator.gen_cats_rect(grid_size, snap_vec, cat_scene, self as Node)

# Cancel drag when mouse exists play area
func confine_to_play_area() -> void:
	var play_area := grid_size / 2 + 2 * Vector2i.ONE
	var play_area_scaled := Vector2(play_area.x * snap_vec.x, play_area.y * snap_vec.y)
	var offset := get_local_mouse_position()
	if abs(offset.x) > play_area_scaled.x or abs(offset.y) > play_area_scaled.y:
		dragging = false
		path.clear()
		queue_redraw()

func cardinalize(vec: Vector2) -> Vector2:
	if abs(vec.x) > abs(vec.y):
		vec.y = 0
	else:
		vec.x = 0
	return vec

# Player lost!
# oh no, anyway
func timer_ended() -> void:
	SceneManager.change_scene(defeat_scene_path, true)
