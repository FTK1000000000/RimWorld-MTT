extends Panel


@onready var slots: VBoxContainer = $Slots


func _on_cancel_button_pressed() -> void:
	queue_free()


func _on_spawn_button_pressed() -> void:
	var project_config: Dictionary
	for node in slots.get_children():
		if node is EditSlot:
			project_config.merge(node.GetValue())
	
	Global.project_generator(project_config)
	queue_free()
