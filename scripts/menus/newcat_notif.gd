extends CanvasLayer

@export var cat_texture: TextureRect
@export var cat_sprites: CatSprites

func load_cats(type : int) -> void:
	assert(1 <= type and type <= 8)
	cat_texture.texture = cat_sprites.sprites[type - 1]
