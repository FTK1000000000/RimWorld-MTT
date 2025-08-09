extends Panel


@onready var slots: VBoxContainer = $Slots
@onready var language_tree: Tree = $Slots/lLanguageTree

var root: TreeItem


func _ready() -> void:
	root = language_tree.create_item()
	tree_generator()


func tree_generator():
	var ols: Dictionary = FileFunction.json_as_dictionary("res://config/optional_target_language.json")
	for lang: String in ols.keys():
		var lang_item: TreeItem = root.create_child()
		lang_item.set_meta("key", lang)
		lang_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		lang_item.set_editable(0, true)
		lang_item.set_text(0, ols.get(lang))


func _on_cancel_button_pressed() -> void:
	queue_free()


func _on_spawn_button_pressed() -> void:
	var project_config: Dictionary
	for node in slots.get_children():
		if node is EditSlot:
			project_config.merge(node.GetValue())
	
	var languages: Array[String]
	for item: TreeItem in root.get_children():
		if item.is_checked(0):
			languages.append(item.get_meta("key"))
	if languages.is_empty():
		OS.alert(tr("Not have selected language"), tr("Not have selected language"))
		
		return
	
	Global.project_generator(project_config, languages)
	queue_free()
