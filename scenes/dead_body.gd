extends Node3D

const BodyPart = preload("res://scenes/body_part.tscn")
var material = preload('res://art/slicer_material.tres')

static var mesh_slicer = MeshSlicer.new()

@onready
var slicer = $Slicer

func _ready():
	for mesh_inst in $Meshes.get_children():
		slicer.rotate_y(2*PI*randf())
		var t = Transform3D.IDENTITY
		t.origin = mesh_inst.to_local((slicer.global_transform.origin))
		t.basis.x = mesh_inst.to_local((slicer.global_transform.basis.x))
		t.basis.y = mesh_inst.to_local((slicer.global_transform.basis.y))
		t.basis.z = mesh_inst.to_local((slicer.global_transform.basis.z))
		var meshes = mesh_slicer.slice_mesh(t, mesh_inst.mesh, material)
		for mesh in meshes:
			if len(meshes[0].get_faces()) <= 2:
				continue
			if mesh.get_aabb().size.length() < 0.3:
				continue
			var body = BodyPart.instantiate()
			body.transform = mesh_inst.transform
			add_child(body)
			body.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
			body.center_of_mass = body.to_local(mesh_inst.to_global(calculate_center_of_mass(mesh)))
			body.init(mesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate_center_of_mass(mesh:ArrayMesh):
	#Not sure how well this work
	var meshVolume = 0
	var temp = Vector3(0,0,0)
	for i in range(len(mesh.get_faces())/3):
		var v1 = mesh.get_faces()[i]
		var v2 = mesh.get_faces()[i+1]
		var v3 = mesh.get_faces()[i+2]
		var center = (v1 + v2 + v3) / 3
		var volume = (Geometry3D.get_closest_point_to_segment_uncapped(v3,v1,v2).distance_to(v3)*v1.distance_to(v2))/2
		meshVolume += volume
		temp += center * volume
	
	if meshVolume == 0:
		return Vector3.ZERO
	return temp / meshVolume
