extends ColorRect

const ProcGen = preload("res://scenes/proc_gen.tscn")


func _ready():
	GlobalCanvasLayer.fade_in()
	if $OrcsKilled:
		$OrcsKilled.text += str(Global.orcs_killed)
	# play music if one of the two music songs is not playing
	if !MusicManager.music_playing:
		MusicManager.main_theme_1.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_new_game_button_down():
	GlobalSfx.click.play()
	GlobalCanvasLayer.transition()
	await get_tree().create_timer(1).timeout
#	MusicManager.fade("out",MusicManager.menu_music)
	get_tree().change_scene_to_packed(ProcGen)

func _on_exit_button_down():
	GlobalSfx.click.play()
	get_tree().quit()
