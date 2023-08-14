extends CharacterBody3D

# node refs
@onready var mage_mesh = $MageMesh
@onready var col_shape = $CollisionShape3D
@onready var dialog = $DialogBox

var player_in_range = false
var dead = false

func _on_health_component_take_damage() -> void:
	if $HealthComponent.current_health > -1:
		$ow.play()
	mage_mesh.idle = false
	mage_mesh.hit = true
	await get_tree().create_timer(.9).timeout
	mage_mesh.hit = false
	mage_mesh.idle = true
	dead = true

func _on_health_component_die() -> void:
	$death.play()
	mage_mesh.idle = false
	mage_mesh.death = true
	# this changes the collision shape so it matches the death animation
	col_shape.position = Vector3(0,0.319,0.299)
	col_shape.rotation = Vector3(90,0,0)
	await get_tree().create_timer(1.2).timeout
	$Thud.play()

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if !dead:
		if body.name == "Player":
			$EIndicator.visible = true
			player_in_range = true

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		$EIndicator.visible = false
		player_in_range = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("e") and player_in_range:
		$DialogBox.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.shop_open = true


func _on_dialog_box_close_shop() -> void:
	dialog.visible = false
	
