extends Node3D

const MIN_SIZE = 10
const MAX_SIZE = 20
const REPEAT_CHILD = 5
const MIN_INTER = 5

const Block = preload("res://scenes/block.tscn")

@onready
var parent = $NavigationRegion3D
@onready
var player = $Player


var rooms = []
var doors = []

func _ready():
	init_map()
	populate()
	populate()
	expand_plane()
	make_mesh()
	# rooms[-1] is the starting room
	var start = rooms[-1].position + rooms[-1].size/2

	player.position = Vector3(start.x, 0, start.y)


func _on_navigation_region_3d_bake_finished():
	pass # Replace with function body.

func init_map():
	rooms = []
	doors = []
	rooms.append(Rect2(Vector2(), rand_size()))

func populate():
	for r in rooms.duplicate():
		for i in REPEAT_CHILD:
			var ret = gen_child(r)
			var s = ret[0]
			var d = ret[1]
			var flag = true
			for t in rooms:
				if intersects(s, t):
					flag = false
					break
			if flag:
				rooms.append(s)
				doors.append(d)

func rand_size():
	return Vector2(
		randi_range(MIN_SIZE, MAX_SIZE),
		randi_range(MIN_SIZE, MAX_SIZE)
	)

func gen_child(r):
	var size = rand_size()
	var pos
	var rng = 4*randf()
	var d
	if rng < 1:
		pos = Vector2(
			r.end.x + 2,
			r.position.y + randi_range(MIN_INTER - size.y, r.size.y - MIN_INTER)
		)
		d = Vector2(
			r.end.x + 1,
			randi_range(
				max(r.position.y, pos.y) + 2,
				min(r.end.y, pos.y + size.y) - 2
			)
		)
	elif rng < 2:
		pos = Vector2(
			r.position.x + randi_range(MIN_INTER - size.x, r.size.x - MIN_INTER),
			r.end.y + 2
		)
		d = Vector2(
			randi_range(
				max(r.position.x, pos.x) + 2,
				min(r.end.x, pos.x + size.x) - 2
			),
			r.end.y + 1
		)
	elif rng < 3:
		pos = Vector2(
			r.position.x - size.x - 2,
			r.position.y + randi_range(MIN_INTER - size.y, r.size.y - MIN_INTER)
		)
		d = Vector2(
			r.position.x - 1,
			randi_range(
				max(r.position.y, pos.y) + 2,
				min(r.end.y, pos.y + size.y) - 2
			)
		)
	else:
		pos = Vector2(
			r.position.x + randi_range(MIN_INTER - size.x, r.size.x - MIN_INTER),
			r.position.y - size.y - 2
		)
		d = Vector2(
			randi_range(
				max(r.position.x, pos.x) + 2,
				min(r.end.x, pos.x + size.x) - 2
			),
			r.position.y - 1
		)
	return [Rect2(pos, size), d]

func intersects(r, s):
	if r.end.x + 1 < s.position.x or s.end.x + 1 < r.position.x:
		return false
	if r.end.y + 1 < s.position.y or s.end.y + 1 < r.position.y:
		return false
	return true

func expand_plane():
	var pos = Vector2()
	var end = Vector2()
	for r in rooms:
		pos.x = min(pos.x, r.position.x)
		pos.y = min(pos.y, r.position.y)
		end.x = max(end.x, r.end.x)
		end.y = max(end.y, r.end.y)
	var size = Vector2(
		2*max(abs(pos.x), abs(end.x)) + 10,
		2*max(abs(pos.y), abs(end.y)) + 10
	)

	$NavigationRegion3D/StaticBody3D/CollisionShape3D.shape.size = Vector3(
		size.x,
		1,
		size.y
	)
	$NavigationRegion3D/StaticBody3D/MeshInstance3D.mesh.size = size



func make_mesh():
	for r in rooms:
		for x in range(r.position.x - 1, r.end.x + 1):
			place_block(Vector2(x, r.position.y - 1))
			place_block(Vector2(x, r.end.y + 1))
		for y in range(r.position.y - 1, r.end.y + 1):
			place_block(Vector2(r.position.x - 1, y))
			place_block(Vector2(r.end.x + 1, y))
	parent.bake_navigation_mesh(false)



func place_block(pos):
	for d in doors:
		if d.x - 1 <= pos.x and d.y - 1 <= pos.y and d.x + 1 >= pos.x and d.y +1 >= pos.y:
			return
	for y in 3:
		var b = Block.instantiate()
		b.position = Vector3(pos.x, y, pos.y)
		parent.add_child(b)


