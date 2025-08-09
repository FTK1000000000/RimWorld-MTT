extends Control


func _ready() -> void:
	change_theme(Global.theme)
	Global.theme_change.connect(change_theme)


func change_theme(new_theme: Theme):
	theme = new_theme
