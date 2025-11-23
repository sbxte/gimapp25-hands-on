extends CanvasLayer
@onready var cat_texture: TextureRect = $Control/CatTexture

const cats : Array[Texture2D] = [
	preload("uid://b1n2edvu32ea2"),
	preload("uid://cfce8t5f0f6jw"),
	preload("uid://bgupfuahk6elr"),
	preload("uid://cw2eo60dnjty"),
	preload("uid://b0siuou27j2o2"),
	preload("uid://tcaog1u21otu"),
	preload("uid://dxxmfxjq83l0r"),
	preload("uid://b0u8bi455weqv")
]

func load_cats(type : int) -> void:
	match type:
		0:
			self.texture = cats[0]
		1:
			self.texture = cats[0]
		2:
			self.texture = cats[0]
		3:
			self.texture = cats[0]
		4:
			self.texture = cats[0]
		5:
			self.texture = cats[0]
		6:
			self.texture = cats[0]
		7:
			self.texture = cats[0]
		_:
			self.texture = null
