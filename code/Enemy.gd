extends CharacterBody3D


const SPEED = 5.0
var gravity = 9.8


@onready var health = $HealthComponent
@onready var target_area = $TargetArea


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

#	var direction
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_health_component_die() -> void:
	queue_free()

func attack():
	# first get anything in the target area
	var bodies = target_area.get_overlapping_bodies()
	# checks if it has health component and
	#if so subtracts health from that things current health
	for body in bodies:
		if body is Player:
			body.health.current_health -= 1
