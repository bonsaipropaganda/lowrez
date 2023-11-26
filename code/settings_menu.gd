extends ColorRect

signal show_pause_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MouseSpeed.text = str(Global.SENSITIVITY)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_down() -> void:
	GlobalSfx.click.play()
	await get_tree().create_timer(.2).timeout
	show_pause_menu.emit()
	hide()


func _on_music_button_down() -> void:
	GlobalSfx.click.play()
	if MusicManager.music_bus_on:
		AudioServer.set_bus_mute(1,true)
		MusicManager.music_bus_on = false
		$Label2.text = "Music off"
	else: 
		MusicManager.music_bus_on = true
		AudioServer.set_bus_mute(1,false)
		$Label2.text = "Music on"



func _on_sfx_button_down() -> void:
	GlobalSfx.click.play()
	if MusicManager.sfx_bus_on:
		AudioServer.set_bus_mute(2,true)
		MusicManager.sfx_bus_on = false
		$Label3.text = "SFX off"
	else: 
		MusicManager.sfx_bus_on = true
		AudioServer.set_bus_mute(2,false)
		$Label3.text = "SFX on"


func _on_plus_button_down() -> void:
	Global.SENSITIVITY += .001
	$MouseSpeed.text = str(Global.SENSITIVITY)


func _on_minus_button_down() -> void:
	Global.SENSITIVITY -= .001
	$MouseSpeed.text = str(Global.SENSITIVITY)
