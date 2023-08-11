extends ColorRect

const ProcGen = preload("res://scenes/proc_gen.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_new_game_button_down():
	get_tree().change_scene_to_packed(ProcGen)

func _on_exit_button_down():
	get_tree().quit()
