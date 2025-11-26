extends CanvasLayer

@export_category("References")
@export var cat_images : CatImages
@export var cat_lores : CatLore
@export var cat_names : CatNames

@export_category("Nodes")
@export var cat_name_label : Label
@export var cat_image : TextureRect
@export var cat_lore : RichTextLabel


func load_info(type : int) -> void:
	assert(1 <= type and type <= 10)
	cat_name_label.text = cat_names.names[type - 1]
	cat_image.texture = cat_images.images[type - 1]
	cat_lore.text = cat_lores.lore[type - 1]


func _on_overlord_bingus_pressed() -> void:
	load_info(1)


func _on_cat_1_pressed() -> void:
	load_info(2)


func _on_cat_2_pressed() -> void:
	load_info(3)


func _on_cat_3_pressed() -> void:
	load_info(4)


func _on_cat_4_pressed() -> void:
	load_info(5)


func _on_cat_5_pressed() -> void:
	load_info(6)


func _on_cat_6_pressed() -> void:
	load_info(7)


func _on_cat_7_pressed() -> void:
	load_info(8)


func _on_cat_8_pressed() -> void:
	load_info(9)


func _on_emperor_woof_pressed() -> void:
	load_info(10)
