extends ColorRect

signal show_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_menu_button_button_down() -> void:
	GlobalSfx.click.play()
	await get_tree().create_timer(.2).timeout
	show_menu.emit()


func _on_exit_button_button_down() -> void:
	GlobalSfx.click.play()
	await get_tree().create_timer(.2).timeout
	get_tree().quit()
