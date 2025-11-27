extends Node

func _ready() -> void:
	Events.cutscene_custom_comp.connect(handle_comp)

func handle_comp(_node: Node, comp: CutsceneComponent):
	if comp is EpilogueSeenCSComp:
		seen_epilogue()
		Events.cutscene_custom_comp_finished.emit()

func seen_epilogue() -> void:
	SaveSystem.get_data().has_seen_epilogue = true
	SaveSystem.write_data()

