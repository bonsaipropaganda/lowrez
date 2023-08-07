extends Node3D

var body_to_damage

func _on_area_3d_body_entered(body: Node3D) -> void:
	for component in body.get_children():
			if component.name == "HealthComponent":
				component.current_health -= 1
	
	$DamageTimer.start()
	body_to_damage = body


# this will continue to damage bodies that sit in the spikes
func _on_damage_timer_timeout() -> void:
	if body_to_damage:
		for component in body_to_damage.get_children():
			if component.name == "HealthComponent":
				component.current_health -= 1


func _on_area_3d_body_exited(body: Node3D) -> void:
	body_to_damage = null
	$DamageTimer.stop()
