extends Node

signal packs_change(new_packs: Array[Pack])
signal theme_change(theme)

const CONFIG_DIR = "res://config/"
const PREFERENCE_PATH = "res://config/preference.ini"
const THEME_DIR = "res://theme/"
const LANGUEGE: Array[String] = [
	"en_US",
	"es_ES",
	"zh_CN"
]

enum PROJECT_FILE_STYLE {
	Tight,
	Loose
}
enum DEFINETION_MANAGE_PACK_NODE_TEXT {
	Pack_Name,
	Pack_ID
}


var steam_mods_dir_path: String
var local_mods_dir_path: String
var theme: Theme
var theme_index: int:
	set(v):
		theme_index = v
		
		theme = load(FileFunction.get_file_list(THEME_DIR).values()[v])
		theme_change.emit(theme)
var language_index: int:
	set(v):
		language_index = v
		
		TranslationServer.set_locale(LANGUEGE[v])
var project_file_style_index: int
var definetion_manage_pack_node_text_index: int

var packs: Array[Pack]
var skip_defs: Array[String]
var pack_generator: PackGenerator = PackGenerator.new()

@onready var file_import: FileDialog = $FileImport
@onready var path_assign: FileDialog = $PathAssign


func _init() -> void:
	config_load()

func _ready() -> void:
	get_tree().root.files_dropped.connect(add_pack)


func add_pack(paths: Array[String]):
	for path: String in paths:
		packs.append(pack_generator.parse_pack(path))
	packs_change.emit(packs)

func project_generator(project_config: Dictionary):
	var project_path = project_config.get("project_path")
	project_config.erase("project_path")
	var languages = project_config.get("target_languages")
	project_config.erase("target_languages")
	
	var filtered_packs: Array[Pack]
	for pack: Pack in packs:
		var filtered_pack: Pack = Pack.new()
		filtered_pack.about = pack.about
		filtered_pack.apis = pack.apis
		for def: Dictionary in pack.defs:
			if !def.values()[0].children.defName.content in skip_defs:
				filtered_pack.defs.append(def)
		
		filtered_packs.append(filtered_pack)
	
	pack_generator.pack_generator(filtered_packs, project_config, [languages], project_path)

func set_steam_mods_dir_path(path):
	steam_mods_dir_path = path
	path_assign.dir_selected.disconnect(set_steam_mods_dir_path)

func set_local_mods_dir_path(path):
	local_mods_dir_path = path
	path_assign.dir_selected.disconnect(set_local_mods_dir_path)

func config_save():
	var config = ConfigFile.new()
	config.set_value("preference", "theme", theme_index)
	config.set_value("preference", "language", language_index)
	config.set_value("preference", "project_file_style", project_file_style_index)
	config.set_value("preference", "definetion_manage_pack_node_text", definetion_manage_pack_node_text_index)
	config.set_value("preference", "steam_mods_dir_path", steam_mods_dir_path)
	config.set_value("preference", "local_mods_dir_path", local_mods_dir_path)
	config.save(PREFERENCE_PATH)

func config_load():
	var config = ConfigFile.new()
	var file = config.load(PREFERENCE_PATH)
	
	if file != OK:
		return
	theme_index = config.get_value("preference", "theme", 0)
	language_index = config.get_value("preference", "language", 0)
	project_file_style_index = config.get_value("preference", "project_file_style", 0)
	definetion_manage_pack_node_text_index = config.get_value("preference", "definetion_manage_pack_node_text", 0)
	steam_mods_dir_path = config.get_value("preference", "steam_mods_dir_path", "")
	local_mods_dir_path = config.get_value("preference", "local_mods_dir_path", "")


func _on_file_dialog_dir_selected(dir: String) -> void:
	file_import.hide()
	add_pack([dir])


func _on_tree_exiting() -> void:
	config_save()
