extends Node3D

signal die
signal take_damage

@export var starting_health: int
var current_health:
	set(new_value):
		# sets the value like normal
		current_health = new_value
		# emits a signal if entity runs out of health
		if current_health == 0:
			die.emit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = starting_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
