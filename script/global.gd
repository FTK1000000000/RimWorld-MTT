extends Node

signal packs_change(new_packs: Array[Pack])

const PREFERENCE_PATH = "res://config/preference.ini"
const CURRENT_THEME_DIR = "res://theme_resource//current/"
const THEME_FILE_DIR: Array[String] = [
	"res://theme_resource//theme//dark/",
	"res://theme_resource//theme//light/"
	]


var theme_index: int:
	set(v):
		theme_index = v
		change_theme(v)
var language_index: int
var project_file_style_index: int

var packs: Array[Pack]
var pack_generator: PackGenerator = PackGenerator.new()

@onready var file_dialog: FileDialog = $FileDialog


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
	
	pack_generator.pack_generator(packs, project_config, [languages], project_path)

func change_theme(index: int):
	var target_theme: Dictionary = FileFunction.get_file_list(THEME_FILE_DIR[index])
	for path: String in FileFunction.get_file_list(CURRENT_THEME_DIR):
		var file = FileAccess.open(path, FileAccess.WRITE)
		var target_file = FileAccess.open(target_theme.get(path), FileAccess.READ)
		file.store_string(target_file.get_as_text())
		file.flush()
		#print(target_file.get_as_text())
		print(file.get_as_text())
		pass

func save_dic(config: ConfigFile, section: String, dic: Dictionary):
	for key: String in dic.keys():
		config.set_value(section, key, dic.get(key))

func config_save():
	var config = ConfigFile.new()
	var dic: Dictionary = {
		"theme": theme_index,
		"language": language_index,
		"project_file_style": project_file_style_index,
	}
	save_dic(config, "preference", dic)
	config.save(PREFERENCE_PATH)

func config_load():
	var config = ConfigFile.new()
	var file = config.load(PREFERENCE_PATH)
	
	if file != OK:
		return
	theme_index = config.get_value("preference", "theme")
	language_index = config.get_value("preference", "language")
	project_file_style_index = config.get_value("preference", "project_file_style")


func _on_file_dialog_dir_selected(dir: String) -> void:
	file_dialog.hide()
	add_pack([dir])


func _on_tree_exiting() -> void:
	config_save()
