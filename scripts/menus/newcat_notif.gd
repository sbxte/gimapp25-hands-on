extends CanvasLayer

@export var cat_texture: TextureRect
@export var cats: Array[CompressedTexture2D]

func load_cats(type : int) -> void:
	assert(1 <= type and type <= 8)
	cat_texture.texture = cats[type - 1]
