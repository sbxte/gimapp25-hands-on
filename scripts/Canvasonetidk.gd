extends Node2D

var mousePos: Vector2
@export var snap_vec: Vector2 = Vector2(64, 64)
var snap: bool = false
var path: Array = []

@export var cat_scene: PackedScene

func _ready() -> void:
	for i in range(10):
		var instance: Cat = cat_scene.instantiate()
		instance.position = Vector2(randf_range(100, 600), randf_range(50, 400)).snapped(snap_vec)
		instance.type = randi_range(1, 4)
		add_child(instance)
	pass

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	var snapped = get_global_mouse_position().snapped(snap_vec)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not snap and intersects(snapped) != -1:
			# just now started pressing button
			snap = true
			path.clear()
			path.push_back(snapped)
	else:
		snap = false 
		path.clear()
		return
	

	var intersection = intersects(snapped)
	var intersection_instance = instance_from_id(intersection) 
	var snap_intersec_inst = instance_from_id(intersects(path[0]))
	
	if intersection == -1:
		if path[path.size() - 1] != snapped: 
			path.push_back(snapped)
	elif intersection_instance != null and snap_intersec_inst != null \
		and intersection_instance != snap_intersec_inst \
		and (intersection_instance as Node).get_parent() is Cat \
		and (snap_intersec_inst as Node).get_parent() is Cat \
		and  (intersection_instance.get_parent() as Cat).type == (snap_intersec_inst.get_parent() as Cat).type:
			if path[path.size() - 1] != snapped: 
				path.push_back(snapped)
			(intersection_instance as Node).get_parent().queue_free()
			(snap_intersec_inst as Node).get_parent().queue_free()

func _draw() -> void:
	if path.size() == 0:
		return
	for cell_i in range(1, path.size()):
		draw_circle(path[cell_i], 2, Color.GREEN)
		draw_line(path[cell_i - 1], path[cell_i], Color.GREEN, 5.0)
	

func intersects(vec: Vector2) -> int: 
	var param = PhysicsPointQueryParameters2D.new()
	param.position = vec 
	var intersection = get_world_2d().direct_space_state.intersect_point(param, 1)
	if intersection.size() == 0:
		return -1
	else:
		return intersection[0]["collider_id"]
