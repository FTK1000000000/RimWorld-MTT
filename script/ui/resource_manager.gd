extends Panel


@onready var tip: Label = $Tip
@onready var defs_tree: Tree = $VBoxContainer/DefsTree

var root: TreeItem


func _ready() -> void:
	root = defs_tree.create_item()
	Global.packs_change.connect(tree_generator)


func tree_generator(packs: Array[Pack]):
	tip.hide()
	
	for pack: Pack in packs:
		var pack_item: TreeItem = root.create_child()
		pack_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		pack_item.set_editable(0, true)
		pack_item.set_checked(0, true)
		pack_item.set_text(0, pack.about.packageId)
		for def: Dictionary in pack.defs:
			if "defName" in def.values()[0].children:
				var def_item: TreeItem = pack_item.create_child()
				def_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
				def_item.set_editable(0, true)
				def_item.set_checked(0, true)
				def_item.set_text(0, def.values()[0].children.defName.content)


func _on_defs_tree_multi_selected(item: TreeItem, column: int, selected: bool) -> void:
	if item in root.get_children():
		item.propagate_check(column)
		#for sub: TreeItem in item.get_children():
			#sub.set_checked(0, item.is_checked(0))
		#for sub: TreeItem in item.get_children():
			#print(sub.is_checked(0))


func _on_clean_button_pressed() -> void:
	for item in root.get_children():
		item.free()
	Global.packs.clear()
	
	tip.show()


func _on_select_all_button_pressed() -> void:
	for pack in root.get_children():
		pack.set_checked(0, true)
		for item in pack.get_children():
			item.set_checked(0, true)


func _on_lla_tceles_button_pressed() -> void:
	for pack in root.get_children():
		pack.set_checked(0, false)
		for item in pack.get_children():
			item.set_checked(0, false)


#func _on_filter_text_submitted(new_text: String) -> void:
	#for pack in root.get_children():
		#for item in pack.get_children():
			#if new_text == "":
				#item.visible = true
			#elif item.get_text(0).contains(new_text):
				#item.visible = true
			#else:
				#item.visible = false


func _on_filter_text_changed(new_text: String) -> void:
	for pack in root.get_children():
		for item in pack.get_children():
			if new_text == "":
				item.visible = true
			elif item.get_text(0).contains(new_text):
				item.visible = true
			else:
				item.visible = false
