extends Node

# Matching mechanics
signal cat_mouse_click(pos: Vector2, cat: Cat)
signal cat_mouse_enter(pos: Vector2, cat: Cat)
signal cancel_drag

# Speech bubbles
signal trigger_speech(correct_match: bool)
signal finished_displaying

# Cutscene handling
signal advance_cutscene
signal cutscene_visibility_changed(visible: bool)
signal cutscene_dialog_box_enabled(enabled: bool)
signal cutscene_custom_comp(cutscene_node: Node, comp: CutsceneComponent)
signal cutscene_custom_comp_finished

# Level handling
signal update_stage(stage: int)
signal on_defeat
signal on_defeat_endless_mode(stages_cleared: int)
signal on_victory(level: int)
signal set_next_level(level: int)
signal pre_advance_level
signal cancel_advance_level
