extends Node3D

var attack = false
var run = true

signal check_target_area

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationTree.set("parameters/conditions/attack", attack)
	$AnimationTree.set("parameters/conditions/run", run)

func attack_signal():
	check_target_area.emit()
