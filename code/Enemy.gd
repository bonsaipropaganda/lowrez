extends CharacterBody3D


const SPEED = 1
var gravity = 9.8

# signals
signal attack_player

# determines whether the enemy will follow the player
var should_follow = true
var attack_range = 1.8

# node refs
@onready var health = $HealthComponent
@onready var target_area = $TargetArea
@onready var animation_player = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../Player"
@onready var orc_mesh = $"character-orc"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
	nav_agent.set_velocity(new_velocity)
	
	# conditions
	if target_in_range():
		orc_mesh.attack = true
		orc_mesh.run = false
	else: 
		orc_mesh.run = true
		orc_mesh.attack = false

func _on_health_component_die() -> void:
	animation_player.play("die")
	# finishs animaiton before getting rid of the enemy
	await get_tree().create_timer(1).timeout
	queue_free()

func attack():
	# first get anything in the target area
	var bodies = target_area.get_overlapping_bodies()
	# checks if it has health component and
	#if so subtracts health from that things current health
	for body in bodies:
		if body is Player:
			print("hit player")
			body.health.current_health -= 1

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _on_health_component_take_damage() -> void:
	$AnimationPlayer.play("hit")

func _on_navigation_agent_3d_target_reached() -> void:
	attack_player.emit()
	should_follow = false

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func target_in_range():
	return global_position.distance_to(player.global_position) < attack_range

# this signal triggers when the orc's attack animation is at it's hit point
func _on_characterorc_check_target_area() -> void:
	attack()
