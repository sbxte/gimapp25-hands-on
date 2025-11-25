extends Node

# Matching mechanics
signal cat_mouse_click(pos: Vector2, cat: Cat)
signal cat_mouse_enter(pos: Vector2, cat: Cat)
signal cancel_drag

# Speech bubbles
signal finished_displaying

# Cutscene handling
signal advance_cutscene
signal cutscene_visibility_changed(visible: bool)
signal cutscene_dialog_box_enabled(enabled: bool)
signal cutscene_custom_comp(cutscene_node: Node, comp: CutsceneComponent)
signal cutscene_custom_comp_finished
