class_name Main
extends Node2D

@export var snap_vec: Vector2 = Vector2(64, 64)
@export var grid_size := Vector2i(6, 4)

var dragging: bool = false
var path: Array[Vector2] = []
var first_cat: Cat

@export var cat_scene: PackedScene

func _ready() -> void:
	Events.connect("cat_mouse_click", cat_mouse_click)
	Events.connect("cat_mouse_enter", cat_mouse_enter)

	gen_cats_rect()

func _process(_delta: float) -> void:
	# When the mouse is released, clear the line path
	# and cancel further processing (return)
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		erase_path()
		return

	if not dragging:
		return

	var last_path_point := path[path.size() - 1]
	var snap_to := (get_global_mouse_position() - snap_vec / 2).snapped(snap_vec) + snap_vec / 2
	var offset := cardinalize(snap_to - last_path_point)
	if not offset.is_zero_approx():
		append_path(last_path_point + offset)

	confine_to_play_area()

func _draw() -> void:
	# The path array consists of points in the path
	# To draw the whole line, draw line segments connecting each point
	if path.size() == 0:
		return
	for point_i in range(1, path.size()):
		draw_circle(path[point_i], 2, Color.GREEN)
		draw_line(path[point_i - 1], path[point_i], Color.GREEN, 5.0)

func cat_mouse_click(pos: Vector2, cat: Cat) -> void:
	# When beginning to press and mouse is hovering above a cat,
	# clear the existing path and append the first point in the line path
	if not dragging:
		start_path(pos, cat)

func cat_mouse_enter(_pos: Vector2, cat: Cat) -> void:
	if not dragging:
		return

	if cat == first_cat:
		return

	# When the mouse enters a cat that isn't the same type, delete the path
	if cat.type != first_cat.type:
		erase_path()
		return

	# Delete cats
	cat.queue_free()
	first_cat.queue_free()

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
	path.push_back(pos)
	queue_redraw()

func gen_cats_rect() -> void:
	var grid_shift := DisplayServer.window_get_size() / 2
	var x_half := grid_size.x >> 1
	var y_half := grid_size.y >> 1
	var min_half := mini(x_half, y_half)
	var cells_taken = []
	for i in range(min_half):
		var width := (x_half - min_half + 1 + i) * 2
		var height := (y_half - min_half + 1 + i) * 2
		var area := 2 * (width + height - 2)
		var pairs := area >> 1
		cells_taken.clear()
		cells_taken.resize(area)
		cells_taken.fill(false)
		for p in range(pairs):
			var type = randi_range(1, 4)
			for _i in range(2):
				var pos: Vector2i
				while true:
					var ridx = randi_range(0, area - 1)
					if not cells_taken[ridx]:
						if ridx < width:
							pos = Vector2i(ridx, 0)
						elif ridx < width + height - 1:
							pos = Vector2i(width - 1, ridx - width + 1)
						elif ridx < 2 * width + height - 2:
							pos = Vector2i((width - 1) - (ridx - (width + height - 1)) - 1, height - 1)
						else:
							pos = Vector2i(0, (height - 1) - (ridx - (2 * width + height - 2)) - 1)
						cells_taken[ridx] = true
						break

				var instance: Cat = cat_scene.instantiate()
				var pos_shift = pos - Vector2i(i + (x_half - min_half), i + (y_half - min_half))
				instance.position = Vector2(pos_shift.x * snap_vec.x, pos_shift.y * snap_vec.y) + Vector2(grid_shift.x, grid_shift.y) - snap_vec / 2
				instance.type = type
				add_child(instance)

func confine_to_play_area() -> void:
	var play_area := grid_size / 2 + Vector2i.ONE
	var play_area_scaled := Vector2(play_area.x * snap_vec.x, play_area.y * snap_vec.y)
	var center := DisplayServer.window_get_size() / 2
	var offset := get_global_mouse_position() - Vector2(center)
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
