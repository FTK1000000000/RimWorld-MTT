extends Panel


@onready var menu_bar: MenuBar = $VBoxContainer/MenuBar


func _ready() -> void:
	for menu: PopupMenu in menu_bar.get_children():
		for sub_nume_index: int in menu.get_children().size():
			menu.set_item_submenu_node(sub_nume_index, menu.get_child(sub_nume_index))


func _on_theme_index_pressed(index: int) -> void:
	Global.theme_index = index


func _on_language_index_pressed(index: int) -> void:
	Global.language_index = index


func _on_project_file_style_index_pressed(index: int) -> void:
	Global.project_file_style_index = index


func _on_file_index_pressed(index: int) -> void:
	match index:
		0:
			pass
