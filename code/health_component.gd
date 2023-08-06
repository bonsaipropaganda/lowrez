extends Node3D

signal die
signal take_damage

@export var starting_health: int
var current_health:
	set(new_value):
		var took_dmg = false
		# if new value is less than the current health take damage signal
		if current_health:
			if new_value < current_health:
				took_dmg = true
		# sets the value like normal
		current_health = new_value
		# signal emitted after setting current_health
		if took_dmg:
			take_damage.emit()
		# emits a signal if entity runs out of health
		if current_health == 0:
			die.emit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = starting_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
