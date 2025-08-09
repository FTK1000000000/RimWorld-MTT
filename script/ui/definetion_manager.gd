extends PanelContainer


@onready var tip: Label = $Tip
@onready var defs_tree: Tree = $VBoxContainer/DefsTree

var root: TreeItem


func _ready() -> void:
	Global.packs_change.connect(tree_generator)


func tree_generator(packs: Array[Pack]):
	tip.hide()
	
	defs_tree.clear()
	root = defs_tree.create_item()
	for pack: Pack in packs:
		var pack_item: TreeItem = root.create_child()
		pack_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		pack_item.set_editable(0, true)
		pack_item.set_checked(0, true)
		if Global.definetion_manage_pack_node_text_index == Global.DEFINETION_MANAGE_PACK_NODE_TEXT.Pack_Name:
			pack_item.set_text(0, pack.about.name)
		else:
			pack_item.set_text(0, pack.about.packageId)
		for def: Dictionary in pack.defs:
			if "defName" in def.values()[0].children:
				var def_item: TreeItem = pack_item.create_child()
				def_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
				def_item.set_editable(0, true)
				def_item.set_checked(0, true)
				def_item.set_text(0, def.values()[0].children.defName.content)

func get_skip_defs() -> Array[String]:
	var checked_defs: Array[String]
	for pack_node: TreeItem in root.get_children():
		if !pack_node.is_checked(0):
			for def_node: TreeItem in pack_node.get_children():
				checked_defs.append(def_node.get_text(0))
		else:
			for def_node: TreeItem in pack_node.get_children():
				if !def_node.is_checked(0):
					checked_defs.append(def_node.get_text(0))
	
	return checked_defs


func _on_defs_tree_item_selected() -> void:
	await get_tree().process_frame
	
	Global.skip_defs = get_skip_defs()


func _on_clean_button_pressed() -> void:
	if root:
		for item in root.get_children():
			item.free()
		Global.packs.clear()
		
		tip.show()


func _on_select_all_button_pressed() -> void:
	if root:
		for pack in root.get_children():
			pack.set_checked(0, true)
			for item in pack.get_children():
				item.set_checked(0, true)


func _on_lla_tceles_button_pressed() -> void:
	if root:
		for pack in root.get_children():
			pack.set_checked(0, false)
			for item in pack.get_children():
				item.set_checked(0, false)


func _on_filter_text_changed(new_text: String) -> void:
	if root:
		for pack in root.get_children():
			for item in pack.get_children():
				if new_text == "":
					item.visible = true
				elif item.get_text(0).contains(new_text):
					item.visible = true
				else:
					item.visible = false
