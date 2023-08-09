extends Node2D

signal close_shop


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_yes_button_pressed() -> void:
	close_shop.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.shop_open = false
	Global.heal_player.emit()

func _on_no_button_pressed() -> void:
	close_shop.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.shop_open = false
