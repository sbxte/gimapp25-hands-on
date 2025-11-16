class_name LevelGenerator

static func gen_cats_rect(grid_size: Vector2i, snap_vec: Vector2, cat_scene: PackedScene, cat_parent: Node) -> void:
	# Align the grid to the center of the screen
	var grid_shift := DisplayServer.window_get_size() / 2

	# Half of the grid size (division by 2 via bitshift)
	# Generate min_half onion layers at most
	var x_half := grid_size.x >> 1
	var y_half := grid_size.y >> 1
	var min_half := mini(x_half, y_half)

	var cells_taken = []
	for i in range(min_half):
		# Width and height of the i-th onion layer
		var width := (x_half - min_half + 1 + i) * 2
		var height := (y_half - min_half + 1 + i) * 2
		var area := 2 * (width + height - 2)
		var pairs := area >> 1

		cells_taken.clear()
		cells_taken.resize(area)
		cells_taken.fill(false)

		for p in range(pairs):
			var type = randi_range(1, 8)
			for _i in range(2):
				# Pos vec aligned with origin (0,0) at the top left corner of the i-th onion layer
				# And (width - 1, height - 1) at the bottom right corner of the i-th onion layer
				var pos: Vector2i
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

					cells_taken[ridx] = true
					break

				# Instantiate cat
				# Transform pos vec back into screen space
				var instance: Cat = cat_scene.instantiate()
				var pos_shift = pos - Vector2i(i + (x_half - min_half), i + (y_half - min_half))
				instance.position = \
					Vector2(pos_shift.x * snap_vec.x, pos_shift.y * snap_vec.y) \
					+ Vector2(grid_shift.x, grid_shift.y) - snap_vec / 2
				instance.set_type(type)
				instance.add_to_group("Cats")
				cat_parent.add_child(instance)

