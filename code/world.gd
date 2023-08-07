extends Node3D

@onready var player = $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
