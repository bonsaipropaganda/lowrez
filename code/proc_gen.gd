extends Node3D

const MIN_SIZE = 10
const MAX_SIZE = 20
const REPEAT_CHILD = 5
const MIN_INTER = 5
const MIN_ROOMS = 5
const MAX_ROOMS = 10

enum {
	START_ROOM,
	ENEMY_ROOM,
	HEALTH_ROOM
}

const Block = preload("res://scenes/block.tscn")
const EnemyScene = preload("res://scenes/enemy.tscn")
const SpikeScene = preload("res://scenes/spikes.tscn")
const CoinScene = preload("res://scenes/coin.tscn")
const BarrelScene = preload("res://scenes/barrel.tscn")
const ChestScene = preload("res://scenes/chest.tscn")
const RockScene = preload("res://scenes/rocks.tscn")
const MageScene = preload("res://scenes/mage.tscn")
const TutorialScene = preload("res://scenes/tutorial_npc.tscn")


@onready
var parent = $NavigationRegion3D
@onready
var player = $Player


var rooms = []
var doors = []
var spawn_list = []

var num_enemies = 0

func _ready():
	Global.orcs_killed = 0
	gen_map()
	expand_plane()
	make_mesh()
	# rooms[-1] is the starting room
	var start = rooms[-1].position + rooms[-1].size/2

	player.position = Vector3(start.x, 0, start.y)
	player.starting_pos = player.position
	var d = doors[-1]
	player.head.look_at(Vector3(d.x, 0, d.y))
	spawn_list.resize(len(rooms))
	for i in len(rooms):
		spawn_list[i] = []

	for i in len(rooms): #-1:
		var r = rooms[i]
		
		# if it's the starting room
		if r == rooms[-1]:
			for p in get_spawnpnts(i, randi_range(1, 1)):
				var obj = TutorialScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)
		else:
			for p in get_spawnpnts(i, randi_range(1, 3)):
				var obj = EnemyScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)
				num_enemies += 1
			for p in get_spawnpnts(i, randi_range(1, 3)):
				var obj = SpikeScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)
			for p in get_spawnpnts(i, randi_range(0, 1)):
				var obj = CoinScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)
			for p in get_spawnpnts(i, randi_range(1, 3)):
				var obj = BarrelScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				obj.add_coin.connect(spawn_coin)
				add_child(obj)
			for p in get_spawnpnts(i, randi_range(0, 1)):
				var obj = ChestScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)
			for p in get_spawnpnts(i, randi_range(1, 3)):
				var obj = RockScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)
			for p in get_spawnpnts(i, randi_range(0, 1)):
				var obj = MageScene.instantiate()
				obj.position = Vector3(p.x, 0.05, p.y)
				add_child(obj)

func _process(delta):
	# this makes the enemies follow the player
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)

func on_enemy_death():
	num_enemies -= 1
	if num_enemies <= 0:
		GlobalCanvasLayer.transition()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/menus/victory_menu.tscn")

func get_spawnpnts(i, n):
	var room = rooms[i]
	var ret = []
	for j in n:
		while true:
			var p = Vector2(
				randi_range(room.position.x + 2, room.end.x - 2),
				randi_range(room.position.y + 2, room.end.y - 2),
			)
			if p not in spawn_list[i]:
				ret.append(p)
				spawn_list[i].append(p)
				break
	return ret

func _on_navigation_region_3d_bake_finished():
	pass # Replace with function body.

func gen_map():
	while true:
		init_map()
		populate()
		populate()
		if len(rooms) >= MIN_ROOMS and len(rooms) <= MAX_ROOMS:
			break

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
	var size3 = Vector3(
		size.x,
		1,
		size.y
	)
	$NavigationRegion3D/StaticBody3D/CollisionShape3D.shape.size = size3
	$NavigationRegion3D/StaticBody3D/MeshInstance3D.mesh.size = size
	$StaticBody3D/CollisionShape3D.shape.size = size3



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


func spawn_coin(pos):
	var coin_inst = CoinScene.instantiate()
	coin_inst.global_position = pos
	add_child(coin_inst)
