extends Panel


@onready var menu_bar: MenuBar = $VBoxContainer/MenuBar


func _ready() -> void:
	for menu: PopupMenu in menu_bar.get_children():
		for sub_nume_index: int in menu.get_children().size():
			menu.set_item_submenu_node(sub_nume_index, menu.get_child(sub_nume_index))


func _on_theme_index_pressed(index: int) -> void:
	Global.theme_index = index


func _on_project_file_style_index_pressed(index: int) -> void:
	Global.project_file_style_index = index


func _on_definetion_manager_index_pressed(index: int) -> void:
	Global.definetion_manage_pack_node_text_index = index


func _on_language_index_pressed(index: int) -> void:
	Global.language_index = index


func _on_file_index_pressed(index: int) -> void:
	match index:
		0:
			Global.file_import.show()
		1:
			OS.shell_show_in_file_manager(ProjectSettings.globalize_path(Global.CONFIG_DIR), true)
		2:
			if Global.steam_mods_dir_path == "":
				Global.path_assign.dir_selected.connect(Global.set_steam_mods_dir_path)
				Global.path_assign.show()
			else:
				OS.shell_show_in_file_manager(ProjectSettings.globalize_path(Global.steam_mods_dir_path), true)
		3:
			if Global.local_mods_dir_path == "":
				Global.path_assign.dir_selected.connect(Global.set_local_mods_dir_path)
				Global.path_assign.show()
			else:
				OS.shell_show_in_file_manager(ProjectSettings.globalize_path(Global.local_mods_dir_path), true)
