extends CharacterBody3D

class_name Player

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = .03

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 9.8

# references to nodes
@onready var head = $Head
@onready var camera = $Head/Camera
@onready var health = $HealthComponent
@onready var target_area = $Head/Camera/TargetArea
@onready var coin_label = $Label

# variables
var starting_pos
var coin_count:
	set(new_value):
		if new_value > 999:
			new_value = 999
		coin_count = new_value
		if coin_label:
			coin_label.text = str(coin_count)

func _ready() -> void:
	starting_pos = position
	coin_count = 0
	Global.heal_player.connect(heal_player)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(40))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Attack the thing in the Target Area!!
	if Input.is_action_just_pressed("left_mb"):
		# only attack if the shop isn't open
		if !Global.shop_open: 
			attack()

	if Input.is_action_pressed("run"):
		SPEED = 7
	else: SPEED = 5

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	push_rigid_body()

func _on_health_component_die() -> void:
	reset_player()

func reset_player():
	coin_count = 0
	health.current_health = health.starting_health
	$Heart.show()
	$Heart2.show()
	$Heart3.show()
	position = starting_pos
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func attack():
	# first get anything in the target area
	var bodies = target_area.get_overlapping_bodies()
	# checks if it has health component and
	#if so subtracts health from that things current health
	for body in bodies:
		for component in body.get_children():
			if component.name == "HealthComponent":
				component.current_health -= 1
		if body is Enemy:
			var v = body.position - position
			if v:
				body.velocity += 10 * v.normalized()


func _on_health_component_take_damage():
	if health.current_health < 3:
		$Heart3.hide()
	if health.current_health < 2:
		$Heart2.hide()
	if health.current_health < 1:
		$Heart.hide()

func push_rigid_body():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		for j in collision.get_collision_count():
			var obj = collision.get_collider(j)
			if obj is RigidBody3D:
				obj.apply_central_impulse(position.direction_to(obj.position)/2)

func heal_player():
	if coin_count >= 10:
		coin_count -= 10
		health.current_health = 3
		$Heart3.show()
		$Heart2.show()
