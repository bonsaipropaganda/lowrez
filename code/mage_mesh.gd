extends Node3D

var idle = true
var interact = false
var hit = false
var death = false

func _process(delta: float) -> void:
	$AnimationTree.set("parameters/conditions/idle", idle)
	$AnimationTree.set("parameters/conditions/interact", interact)
	$AnimationTree.set("parameters/conditions/hit", hit)
	$AnimationTree.set("parameters/conditions/death", death)
