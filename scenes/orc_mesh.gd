extends Node3D

var attack = false
var run = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("orc attack = " + str(attack))
	$AnimationTree.set("parameters/conditions/attack", attack)
	$AnimationTree.set("parameters/conditions/run", run)

