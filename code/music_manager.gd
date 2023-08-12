extends Node2D

# this is for the fade function
var audio_volume
# value to change the audiostream player's volume by
var fade_increment = 1

var is_playing_music

signal fade_complete

# node refs
@onready var menu_music = $Menu
@onready var main_theme_1 = $MainTheme1
@onready var main_theme_2 = $MainTheme2
var music_players = [menu_music,main_theme_1,main_theme_2]

func _process(delta: float) -> void:
	is_playing_music = check_if_music()

# fades audiostreamplayers in or out
func fade(in_or_out: String,audiostreamplayer,start_value = null):
		if in_or_out == "in":
			if start_value:
				audiostreamplayer.volume_db = start_value
			for i in 40:
				await get_tree().create_timer(.1).timeout
				audiostreamplayer.volume_db += fade_increment
		elif in_or_out == "out":
			for i in 40:
				await get_tree().create_timer(.1).timeout
				audiostreamplayer.volume_db -= fade_increment
		else: push_error("Fade in type not selected. First argument, type, must be string 'in' or 'out'.")


func _on_main_theme_1_finished() -> void:
	$MainTheme2.play()

func check_if_music():
	for player in music_players:
		if player.playing():
			return false
	return true
