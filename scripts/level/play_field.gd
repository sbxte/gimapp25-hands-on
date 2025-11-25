class_name PlayField
extends Node2D

@export_subgroup("Grid")
@export var snap_vec: Vector2 = Vector2(64, 64)
@export var grid_size := Vector2i(4, 4)

var dragging: bool = false
var path: Array[Vector2] = []
var first_cat: Cat
var match_streak := 0

var level: int = 1
var max_pairs := -1
var cats :int
var stages := 5
var stages_cleared := 1
var time_bonus: int
var endless_mode := false
var endless_mode_jingle_played := false
var game_finished = false

@export_subgroup("References")
@export var cat_scene: PackedScene
@export var timer: TimerController
@export var cat_generator: AbstractLevelGen

@export_file_path var defeat_scene_path: String

@export var defeat_animation: AnimationPlayer
@export var cat_notif_controller: NewCatNotifController


const correct_match_lines: Array[String] = [
	"Yes, Good. Brain functioning.",
	"Cat to cat, simple. You did it. Wow.",
	"See? Matching isn’t hard. Even for you.",
	"Good, very good.",
	"Excellent, they will fight with… mild enthusiasm",
	"Excellent Job, Human. I almost believe in you.",
	"A streak, impressive, for a human.",
	"Nice, very nice."
]
const wrong_match_lines: Array[String] = [
	"No. Wrong. Incorrect. Bad.",
	"What—what is THAT? Stop.",
	"Why would you do that?",
	"Is your brain functioning, Human?",
	"Stop guessing. Use brain, please.",
	"Nuh uh, that won’t do.",
	"You just committed a war crime in the whole Felis Dominion!",
	"If you do that again, I’m revoking your thumbs."
]

signal drag_start(start: Vector2)
signal drag_end(end: Vector2, matched: bool)

func _ready() -> void:
	Events.cat_mouse_click.connect(cat_mouse_click)
	Events.cat_mouse_enter.connect(cat_mouse_enter)
	defeat_animation.play("RESET")

	Events.cancel_drag.connect(cancel_drag)

	timer.timer_ended.connect(on_defeat)

func _process(_delta: float) -> void:
	if endless_mode and not endless_mode_jingle_played:
		AudioManager.music.stop()
		AudioManager.enter_endless_mode.finished.connect(func(): AudioManager.music.play(), CONNECT_ONE_SHOT)
		AudioManager.enter_endless_mode.play()
		endless_mode_jingle_played = true

	if not dragging:
		return

	var last_path_point := path[path.size() - 1]
	var offset := (get_local_mouse_position() - last_path_point).snapped(snap_vec)
	var cardinalized := cardinalize(offset)
	if not cardinalized.is_zero_approx():
		append_path(last_path_point + cardinalized)

	confine_to_play_area()

func _unhandled_input(event: InputEvent) -> void:
	# When the mouse is released on nothing, clear the line path
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and dragging:
			AudioManager.deselect.play()
			erase_path(false)


func _draw() -> void:
	# The path array consists of points in the path
	# To draw the whole line, draw line segments connecting each point
	if path.size() < 2:
		return
	draw_polyline(path, Color.GREEN, 5)

func cancel_drag() -> void:
	erase_path(false)

func cat_mouse_click(pos: Vector2, cat: Cat) -> void:
	if not dragging:
		start_path(pos - position, cat)

func cat_mouse_enter(_pos: Vector2, cat: Cat) -> void:
	if not dragging:
		return

	if cat == first_cat:
		return

	# When the mouse enters a cat that isn't the same type,
	# delete the path, speed up timer, and reset streak
	if cat.type != first_cat.type:
		erase_path(false)
		if randf() < 0.01:
			AudioManager.rare_wrongmatch.play()
		else:
			AudioManager.wrongmatch.play()
		match_streak = 0
		return

	# FIX: Path simply disappears and does not visually connect to the paired cat
	erase_path(true, cat.global_position)
	AudioManager.deselect.play()

	notify_if_new_cat(cat.type)

	# Delete cats
	cat.queue_free()
	first_cat.queue_free()
	cats -= 2
	if cats == 0:
		if not endless_mode:
			timer.add_time(time_bonus)
			stages_cleared += 1
			if stages_cleared > stages:
				on_victory()
			else:
				AudioManager.next_stage.play()
				timer.reset()
				reset_cats()
		else:
			if stages_cleared < stages:
				stages_cleared += 1
			if 1 <= stages and stages <= 15:
				timer.start_duration -= 1
			timer.reset()
			reset_cats()

	match_streak += 1
	if match_streak == 2:
		timer.reset_speed()

func start_path(pos: Vector2, cat: Cat) -> void:
	first_cat = cat
	dragging = true
	drag_start.emit(pos)
	path.clear()
	path.push_back(pos)
	notify_if_new_cat(cat.type)
	queue_redraw()
	AudioManager.select.play()

func erase_path(matched: bool, last_pos: Vector2 = Vector2.ZERO) -> void:
	AudioManager.trace.stop()
	dragging = false
	if not path.is_empty():
		# Pick a random cat that is not the two matched cats
		var cats = get_tree().get_nodes_in_group("Cats")
		if cats.size() > 2:
			var first_in_pair: Node = null
			var second_in_pair: Node = null

			var front := (path.front() as Vector2) + global_position
			var back := last_pos
			for c: Node in cats:
				if first_in_pair and second_in_pair:
					break
				var c2d := c as Node2D
				var pos := c2d.global_position
				if not first_in_pair and pos == front:
					first_in_pair = c
				elif not second_in_pair and pos == back:
					second_in_pair = c

			cats.erase(first_in_pair)
			cats.erase(second_in_pair)

			if matched:
				DialogueManager.start_dialogue((cats.pick_random() as Node2D).global_position, correct_match_lines.pick_random())
			else:
				DialogueManager.start_dialogue((cats.pick_random() as Node2D).global_position, wrong_match_lines.pick_random())

		drag_end.emit(path.back(), matched)
	path.clear()
	queue_redraw()

func append_path(pos: Vector2) -> void:
	var prev_idx := path.find(pos)
	if prev_idx != -1:
		path.resize(prev_idx + 1)
	else:
		path.push_back(pos)
	queue_redraw()
	play_trace()

func play_trace() -> void:
	if not AudioManager.trace.playing:
		AudioManager.trace.play()

func reset_cats() -> void:
	cats = grid_size.x * grid_size.y
	if max_pairs != -1:
		cats = mini(cats, max_pairs * 2)
	for cat in get_tree().get_nodes_in_group("Cats"):
		cat.queue_free()
	cat_generator.gen_cats(grid_size, snap_vec, max_pairs, cat_scene, self)

# Cancel drag when mouse exists play area
func confine_to_play_area() -> void:
	var play_area := grid_size / 2 + 2 * Vector2i.ONE
	var play_area_scaled := Vector2(play_area.x * snap_vec.x, play_area.y * snap_vec.y)
	var offset := get_local_mouse_position()
	if abs(offset.x) > play_area_scaled.x or abs(offset.y) > play_area_scaled.y:
		erase_path(false)
		AudioManager.deselect.play()

func cardinalize(vec: Vector2) -> Vector2:
	if abs(vec.x) > abs(vec.y):
		vec.y = 0
	else:
		vec.x = 0
	return vec

func notify_if_new_cat(type: int) -> void:
	if not SaveSystem.get_data().cats_encountered[type - 1]:
		SaveSystem.get_data().cats_encountered[type - 1] = true
		SaveSystem.get_data().cats_encountered[type - 1] = true
		cat_notif_controller.new_cat(type)
		SaveSystem.write_data()

# Player lost!
# oh no, anyway
func on_defeat() -> void:
	if not game_finished:
		game_finished = true
		if endless_mode:
			SaveSystem.get_data().endless_mode_stages_cleared = maxi(SaveSystem.get_data().endless_mode_stages_cleared, stages_cleared)
		AudioManager.music.stop()
		AudioManager.trace.stop()
		defeat_animation.play("blurify")
		await defeat_animation.animation_finished
		defeat_animation.play("slide_up")
	else:
		return

func on_victory() -> void:
	if not game_finished:
		game_finished = true
		Events.on_victory.emit(level)
	else:
		return
