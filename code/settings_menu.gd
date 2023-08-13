extends ColorRect

signal show_pause_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_down() -> void:
	show_pause_menu.emit()
	hide()


func _on_music_button_down() -> void:
	if MusicManager.music_bus_on:
		AudioServer.set_bus_mute(1,true)
		MusicManager.music_bus_on = false
		$Label2.text = "Music off"
	else: 
		MusicManager.music_bus_on = true
		AudioServer.set_bus_mute(1,false)
		$Label2.text = "Music on"



func _on_sfx_button_down() -> void:
	if MusicManager.sfx_bus_on:
		AudioServer.set_bus_mute(2,true)
		MusicManager.sfx_bus_on = false
		$Label3.text = "SFX off"
	else: 
		MusicManager.sfx_bus_on = true
		AudioServer.set_bus_mute(1,false)
		$Label3.text = "SFX on"
