extends RigidBody3D


func init(mesh: Mesh):
	$MeshInstance3D.mesh = mesh
	$CollisionShape3D.shape = mesh.create_convex_shape()
	$Timer.start()

func _on_timer_timeout():
	queue_free()
