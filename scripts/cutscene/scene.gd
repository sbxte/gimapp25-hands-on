class_name Cutscene
extends Node

@export_subgroup("Objects")
@export var background: Sprite2D
@export var dialog_text: RichTextLabel
@export var dialog_speaker: RichTextLabel
@export var base_character: PackedScene

@export_subgroup("Entries")
@export var entries: Array[CutsceneEntry] = []
@export var entry_idx := 0

var chars: Dictionary[String, CharacterBehavior] = {}

func _ready() -> void:
	exec_entry()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if entry_idx + 1 == entries.size():
			SceneManager.change_scene(entries[entry_idx].change_scene, false)
			return

		entry_idx += 1
		exec_entry()

func exec_entry() -> void:
	var entry := entries[entry_idx]
	var components := entry.components
	for component in components:
		if component is CutsceneBackground:
			background.texture = (component as CutsceneBackground).background
		elif component is DialogLine:
			var comp = (component as DialogLine)
			dialog_text.text = comp.text
			if not comp.char_name_override.is_empty():
				dialog_speaker.text = comp.char_name_override
			else:
				dialog_speaker.text = comp.character.name
		elif component is CutsceneCharEnter:
			var comp = (component as CutsceneCharEnter)
			var c: CharacterBehavior = base_character.instantiate()

			c.position = comp.position
			c.scale = Vector2(comp.scale, comp.scale)
			c.sprite.texture = comp.character.sprites[comp.sprite]
			c.sprite.flip_h = comp.flipped_h
			c.sprite.flip_v = comp.flipped_v
			c.character = comp.character

			add_child(c)
			chars[comp.character.name] = c
		elif component is CutsceneCharMove:
			var comp = (component as CutsceneCharMove)

			if not chars.has(comp.character.name):
				printerr("Character has not yet enterred the scene!")
				continue

			var c = chars[comp.character.name]
			if comp.position_update:
				c.position = comp.position
			if comp.flip_update:
				c.sprite.flip_h = comp.flipped_h
				c.sprite.flip_v = comp.flipped_v
			if not comp.sprite.is_empty():
				c.sprite.texture = c.character.sprites[comp.sprite]
