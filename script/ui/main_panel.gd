extends Panel

const NEW_PROJECT_DEFINE_PANEL = preload("res://ui/new_project_define_panel.tscn")


@onready var options: VBoxContainer = $Options


func _on_define_project_button_pressed() -> void:
	options.hide()
	
	var panel = NEW_PROJECT_DEFINE_PANEL.instantiate()
	panel.tree_exited.connect(options.show)
	add_child(panel)


func _on_import_pack_button_pressed() -> void:
	Global.file_dialog.show()
