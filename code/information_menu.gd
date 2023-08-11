extends ColorRect

const menu = preload("res://scenes/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_menu_button_button_down() -> void:
	get_tree().change_scene_to_packed(menu)


func _on_exit_button_button_down() -> void:
	get_tree().quit()
