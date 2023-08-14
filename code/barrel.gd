extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_health_component_die() -> void:
	GlobalSfx.wood_broken.play()
	queue_free()


func _on_health_component_take_damage() -> void:
	GlobalSfx.knife_wood.play()
