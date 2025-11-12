extends Node2D

var mousePos: Vector2
@export var snap_vec: Vector2 = Vector2(64, 64)
var select_and_drag: bool = false

var path_changed: bool = false
var path: Array = []

@export var cat_scene: PackedScene

func _ready() -> void:
	# Spawn cats randomly
	for i in range(10):
		var instance: Cat = cat_scene.instantiate()
		instance.position = Vector2(randf_range(100, 600), randf_range(50, 400)).snapped(snap_vec)
		instance.type = randi_range(1, 4)
		add_child(instance)

func _process(_delta: float) -> void:
	if path_changed:
		queue_redraw()
		path_changed = false

func _physics_process(_delta: float) -> void:
	var snap_to = get_global_mouse_position().snapped(snap_vec)

	# When beginning to press and mouse is hovering above a cat,
	# clear the existing path and append the first point in the line path
	#
	# When the mouse is released, clear the line path
	# and cancel further processing (return)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not select_and_drag and intersects(snap_to) != -1:
			select_and_drag = true
			path_changed = true
			path.push_back(snap_to)
	else:
		select_and_drag = false
		path_changed = true
		path.clear()
		return

	if not select_and_drag:
		return


	# If no intersection is found and the mouse has moved to a different cell,
	# append the new cell to the path
	#
	# If an intersection is found and mouse is over a cat,
	# check if the cat has matching type with the cat we started with
	# If it matches, delete both cats
	var intersects_end = intersects(snap_to)
	if intersects_end == -1:
		if path[path.size() - 1] != snap_to:
			path_changed = true
			path.push_back(snap_to)
			return
	var instance_end = instance_from_id(intersects_end)
	var instance_start = instance_from_id(intersects(path[0]))
	if instance_end != null and instance_start != null \
		and instance_end != instance_start \
		and (instance_end as Node).get_parent() is Cat \
		and (instance_start as Node).get_parent() is Cat \
		and  (instance_end.get_parent() as Cat).type == (instance_start.get_parent() as Cat).type:
			if path[path.size() - 1] != snap_to:
				path_changed = true
				path.push_back(snap_to)
			(instance_end as Node).get_parent().queue_free()
			(instance_start as Node).get_parent().queue_free()

func _draw() -> void:
	# The path array consists of points in the path
	# To draw the whole line, draw line segments connecting each point
	if path.size() == 0:
		return
	for cell_i in range(1, path.size()):
		draw_circle(path[cell_i], 2, Color.GREEN)
		draw_line(path[cell_i - 1], path[cell_i], Color.GREEN, 5.0)


# Helper function to determine whether a point is touching anything in the physical world
# Returns -1 when not intersecting anything,
# otherwise it returns the collider's instance ID
#
# NOTE: Currently the cats are represented using Area2D and Collision2D
# TODO: Is using UI (Control) elements a better approach instead? Debugger seems to not like the current appraoch
func intersects(vec: Vector2) -> int:
	var param = PhysicsPointQueryParameters2D.new()
	param.position = vec
	var intersection = get_world_2d().direct_space_state.intersect_point(param, 1)
	if intersection.size() == 0:
		return -1
	else:
		return intersection[0]["collider_id"]
