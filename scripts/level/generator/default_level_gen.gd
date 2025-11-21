extends AbstractLevelGen

func gen_cats(grid_size: Vector2i, snap_vec: Vector2, max_pairs: int, cat_scene: PackedScene, cat_parent: Node) -> void:
	var theoretical_max_pairs := (grid_size.x * grid_size.y) >> 1
	assert(max_pairs == -1 or (0 <= max_pairs and max_pairs <= theoretical_max_pairs))
	var remaining_pairs := max_pairs
	if max_pairs == -1:
		remaining_pairs = theoretical_max_pairs

	# Half of the grid size (division by 2 via bitshift)
	# Generate min_half onion layers at most
	var x_half := (grid_size.x + 1) >> 1 # Round up
	var y_half := (grid_size.y + 1) >> 1
	var min_half := mini(x_half, y_half)

	var cells_taken = []
	var cat_array: Array[int] = []
	for i in range(grid_size.x * grid_size.y):
		cat_array.append(-1)
	for i in range(min_half):
		# Width and height of the i-th onion layer
		var width := grid_size.x - (min_half - i - 1) * 2
		var height := grid_size.y - (min_half - i - 1) * 2
		var area := 2 * (width + height - 2)
		var pairs := mini(area >> 1, remaining_pairs)
		remaining_pairs -= pairs


		cells_taken.clear()
		cells_taken.resize(area)
		cells_taken.fill(false)

		for p in range(pairs):
			var type = randi_range(1, 8)
			for _i in range(2):
				# Pos vec aligned with origin (0,0) at the top left corner of the i-th onion layer
				# And (width - 1, height - 1) at the bottom right corner of the i-th onion layer
				var pos: Vector2i
				var attempts := 20
				while true:
					# Keep randomly selecting till a cell that is not taken yet is found
					# Probably inefficient but meh :p
					var ridx = randi_range(0, area - 1)
					if cells_taken[ridx]:
						continue

					# Generates i-th onion layer with indicies mapped to
					# top edge with corners,
					# bottom edge with corners,
					# left edge without corners,
					# right edge without corners
					# in that order
					if ridx < width:
						pos = Vector2i(ridx, 0)
					elif ridx < 2 * width:
						pos = Vector2i(ridx - width, height - 1)
					elif ridx < 2 * width + height - 2:
						pos = Vector2i(0, ridx - (2 * width) + 1)
					else:
						pos = Vector2i(width - 1, ridx - (2 * width + height - 2) + 1)

					# Attempt to set type that is not equal to any adjacent squares' type
					var pos_i := Vector2i(pos.x + (min_half - 1 - i), pos.y + (min_half - 1 - i))
					if ((((pos_i.x > 0) and cat_array[vec_to_idx(pos_i.x - 1, pos_i.y, grid_size.x)] != type) or (pos_i.x == 0)) and \
						(((pos_i.y > 0) and cat_array[vec_to_idx(pos_i.x, pos_i.y - 1, grid_size.x)] != type) or (pos_i.y == 0)) and \
					 	(((pos_i.x < grid_size.x - 1) and cat_array[vec_to_idx(pos_i.x + 1, pos_i.y, grid_size.x)] != type) or (pos_i.x == grid_size.x - 1)) and \
						(((pos_i.y < grid_size.y - 1) and cat_array[vec_to_idx(pos_i.x, pos_i.y + 1, grid_size.x)] != type) or (pos_i.y == grid_size.y - 1))) or attempts == 0:
						cells_taken[ridx] = true
						cat_array[vec_to_idx(pos_i.x, pos_i.y, grid_size.x)] = type
						break
					else:
						attempts -= 1


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

func vec_to_idx(x: int, y: int, width: int) -> int:
	return y * width + x
