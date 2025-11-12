class_name Main
extends Node2D

@export var snap_vec: Vector2 = Vector2(64, 64)

var dragging: bool = false
var path: Array[Vector2] = []
var first_cat: Cat

@export var cat_scene: PackedScene

func _ready() -> void:
	Events.connect("cat_mouse_click", cat_mouse_click)
	Events.connect("cat_mouse_enter", cat_mouse_enter)

	# Spawn cats randomly
	for i in range(10):
		var instance: Cat = cat_scene.instantiate()
		instance.position = Vector2(randf_range(100, 600), randf_range(50, 400)).snapped(snap_vec)
		instance.type = randi_range(1, 4)
		add_child(instance)


func _process(_delta: float) -> void:
	# When the mouse is released, clear the line path
	# and cancel further processing (return)
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		queue_redraw()
		path.clear()
		return

	if not dragging:
		return

	var snap_to = get_global_mouse_position().snapped(snap_vec)
	if path[path.size() - 1] != snap_to:
		queue_redraw()
		path.push_back(snap_to)


func _draw() -> void:
	# The path array consists of points in the path
	# To draw the whole line, draw line segments connecting each point
	if path.size() == 0:
		return
	for cell_i in range(1, path.size()):
		draw_circle(path[cell_i], 2, Color.GREEN)
		draw_line(path[cell_i - 1], path[cell_i], Color.GREEN, 5.0)

func cat_mouse_click(pos: Vector2, cat: Cat) -> void:
	# When beginning to press and mouse is hovering above a cat,
	# clear the existing path and append the first point in the line path
	#
	if not dragging:
		dragging = true
		first_cat = cat
		path.clear()
		path.push_back(pos)

func cat_mouse_enter(_pos: Vector2, cat: Cat) -> void:
	if not dragging:
		return

	if cat == first_cat or cat.type != first_cat.type:
		return

	# Delete cats
	cat.queue_free()
	first_cat.queue_free()
	dragging = false

	# FIX: Path does not visually connect to the paired cat
	path.clear()
	queue_redraw()
