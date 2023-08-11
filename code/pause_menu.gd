extends ColorRect

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			get_tree().paused = true
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_button_down():
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_menu_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_sound_button_down() -> void:
	$PauseMenu.hide()
	$SettingsMenu.show()


func _on_settings_menu_show_pause_menu() -> void:
	$PauseMenu.show()


func _on_controls_button_down() -> void:
	$PauseMenu.hide()
	$Information.show()


func _on_information_show_menu() -> void:
	$Information.hide()
	$PauseMenu.show()
