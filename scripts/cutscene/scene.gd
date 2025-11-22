class_name Cutscene
extends CanvasLayer

@export_subgroup("Objects")
@export var background: Sprite2D
@export var dialog_text: RichTextLabel
@export var dialog_speaker: RichTextLabel
@export var base_character: PackedScene
@export var text_timer: Timer

@export_subgroup("Entries")
@export var entries: Array[CutsceneEntry] = []
@export var entry_idx := 0

var chars: Dictionary[String, CharacterBehavior] = {}

var comps_finished := 0

var text: String = ""
var text_idx := 0
var text_animation_speed := 1

func _ready() -> void:
	Events.advance_cutscene.connect(advance_entry)
	Events.cutscene_custom_comp_finished.connect(func(): comps_finished += 1)
	visibility_changed.connect(func(): Events.cutscene_visibility_changed.emit(visible))
	text_timer.timeout.connect(on_text_timer_finished)

	exec_entry.call_deferred()

func advance_entry() -> void:
	# Forcefully finish the text animation
	if text_idx + 1 < text.length():
		text_timer.stop()
		dialog_text.text = text
		text_idx = text.length()
		comps_finished += 1
		on_text_animate_finished()
		return

	if comps_finished < entries[entry_idx].components.size():
		return

	if entry_idx + 1 == entries.size():
		SceneManager.change_scene(entries[entry_idx].change_scene, false)
		return

	entry_idx += 1
	exec_entry()

func exec_entry() -> void:
	comps_finished = 0
	text = ""
	var entry := entries[entry_idx]
	var components := entry.components
	for component in components:
		if component is CutsceneBackground:
			background.texture = (component as CutsceneBackground).background
		elif component is DialogLine:
			var comp = (component as DialogLine)

			text_animation_speed = comp.text_animation_speed

			if not comp.char_name_override.is_empty():
				dialog_speaker.text = comp.char_name_override
			else:
				dialog_speaker.text = comp.character.name

			dialog_text.text = ""
			text = comp.text
			text_idx = 0
			if not text.is_empty():
				next_letter()
				on_text_animate_started(comp.character.dialog_sfx)

		elif component is CutsceneCharEnter:
			var comp = (component as CutsceneCharEnter)
			var c: CharacterBehavior = base_character.instantiate()

			c.position = comp.position
			c.scale = Vector2(comp.scale, comp.scale)
			if not comp.sprite.is_empty():
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
		elif component is CutsceneAudio:
			var comp := (component as CutsceneAudio)

			var player := AudioStreamPlayer.new()
			get_tree().current_scene.add_child(player)

			player.stream = comp.stream
			player.play()
			player.finished.connect(func(): player.queue_free())
		elif component is CutsceneHide:
			var _comp := (component as CutsceneHide)
			hide()
		elif component is CutsceneShow:
			var _comp := (component as CutsceneShow)
			show()
		elif component is ToggleDialogBox:
			dialog_text.visible = component.enabled
			dialog_speaker.visible = component.enabled
			Events.cutscene_dialog_box_enabled.emit(component.enabled)
		elif component is CutscenePauseTree:
			get_tree().paused = true
		elif component is CutsceneUnpauseTree:
			get_tree().paused = false
		else:
			Events.cutscene_custom_comp.emit(self, component)
			comps_finished -= 1
		comps_finished += 1

func next_letter() -> void:
	dialog_text.text += text[text_idx]

	if text_idx + 1 >= text.length():
		comps_finished += 1
		on_text_animate_finished()
		return

	text_idx += 1
	text_timer.start(0.05 / text_animation_speed)

func on_text_timer_finished() -> void:
	next_letter()

func on_text_animate_started(stream: AudioStream) -> void:
	var player := AudioManager.reusable_player
	player.stream = stream
	player.play()

func on_text_animate_finished() -> void:
	AudioManager.reusable_player.stop()
