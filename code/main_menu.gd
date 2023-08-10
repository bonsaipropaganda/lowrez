extends ColorRect

const proc_gen = preload("res://scenes/proc_gen.tscn")
const information = preload("res://scenes/information_menu.tscn")
const settings = preload("res://scenes/settings_menu.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _on_information_button_button_down() -> void:
	get_tree().change_scene_to_packed(information)


func _on_new_game_button_down() -> void:
	get_tree().change_scene_to_packed(proc_gen)


func _on_settings_button_button_down() -> void:
	get_tree().change_scene_to_packed(settings)
