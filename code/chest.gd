extends StaticBody3D

# whether the player is within range
var player_present = false
var chest_open = false

# node refs
@onready var chest_mesh = $chest_mesh
@export var coin_scene: PackedScene
@onready var spawn_point = $SpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_present and not chest_open:
		$EIndicator.visible = true
	else: $EIndicator.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("e") and player_present and not chest_open:
		chest_mesh.open_animation()
		spawn_coins()
		chest_open = true

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_present = true


func _on_player_detection_area_body_exited(body: Node3D) -> void:
	print(body.name)
	if body.name == "Player":
		player_present = false


func _on_health_component_die() -> void:
	queue_free()

func spawn_coins():
	for spawner in spawn_point.get_children():
		var coin = coin_scene.instantiate()
		coin.position = spawner.position
		add_child(coin)
