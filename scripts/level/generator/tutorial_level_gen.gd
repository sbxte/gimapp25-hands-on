extends AbstractLevelGen

func gen_cats(grid_size: Vector2i, snap_vec: Vector2, _max_pairs: int, cat_scene: PackedScene, cat_parent: Node) -> void:
	var cat_array: Array[int] = [3, 6, 7, 6, 7, 3]

	# Instantiate cats
	for yi in range(grid_size.y):
		for xi in range(grid_size.x):
			var type := cat_array[yi * grid_size.x + xi]
			if type == -1:
				continue

			var pos := - Vector2(snap_vec.x * grid_size.x / 2, snap_vec.y * grid_size.y / 2) + Vector2(snap_vec.x * xi, snap_vec.y * yi) + Vector2(snap_vec) / 2

			var instance: Cat = cat_scene.instantiate()
			instance.position = pos
			instance.set_type(type)
			instance.add_to_group("Cats")
			cat_parent.add_child(instance)
