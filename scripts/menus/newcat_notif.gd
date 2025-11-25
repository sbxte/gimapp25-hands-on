class_name NewCatNotifController
extends CanvasLayer

@export var cat_texture: TextureRect
@export var cat_sprites: CatSprites

@export var animation_player: AnimationPlayer
var notif_queued := false
var type_queued := -1

func load_cat(type : int) -> void:
	assert(1 <= type and type <= 8)
	cat_texture.texture = cat_sprites.sprites[type - 1]

func new_cat(type: int) -> void:
	if animation_player.is_playing() and (animation_player.current_animation == "idling" or animation_player.current_animation == "slide_right"):
		load_cat(type)
		if animation_player.current_animation == "idling":
			animation_player.reset_section()
	elif not animation_player.is_playing():
		load_cat(type)
		animation_player.play("slide_right")
	else:
		notif_queued = true
		type_queued = type

func on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slide_right":
		animation_player.play("idling")
	elif anim_name == "slide_left":
		if notif_queued:
			load_cat(type_queued)
			type_queued = -1
			notif_queued = false
			animation_player.play("slide_right")
	else: # idling
		animation_player.play("slide_left")
