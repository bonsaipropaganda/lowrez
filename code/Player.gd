extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = .03

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 9.8

# references to nodes
@onready var head = $Head
@onready var camera = $Head/Camera
@onready var health = $HealthComponent
@onready var target_area = $Head/TargetArea

# variables
var starting_pos

func _ready() -> void:
	starting_pos = position
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# lets the mouse go
	if Input.is_action_just_pressed("ui_end"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
	if Input.is_action_just_pressed("ui_accept"):
		attack()


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

func _on_health_component_die() -> void:
	reset_player()

func reset_player():
	health.current_health = health.starting_health
	position = starting_pos

func attack():
	# first get anything in the target area
	var bodies = target_area.get_overlapping_bodies()
	# checks if it has health component and
	#if so subtracts health from that things current health
	for body in bodies:
		print(body.get_children())
