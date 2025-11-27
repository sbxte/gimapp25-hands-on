extends Node

func _ready() -> void:
	Events.cutscene_custom_comp.connect(handle_comp)

func handle_comp(_node: Node, comp: CutsceneComponent):
	if comp is PrologueSeenCSComp:
		seen_prologue()
		Events.cutscene_custom_comp_finished.emit()

func seen_prologue() -> void:
	SaveSystem.get_data().has_seen_prologue = true
	SaveSystem.write_data()
