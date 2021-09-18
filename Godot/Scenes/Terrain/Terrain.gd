extends Spatial

onready var chunk := preload("res://Scenes/Chunk/Chunk.tscn")

export (int) var view_distance := 1
export (int) var height := 1
export (int) var max_cache_size := 18
export (int) var user_seed : int;

var world_seed : int;

var _map := {}
var _cache := {}

func _ready():
	randomize();
	world_seed = randi() if not user_seed else user_seed;
	print("World Seed: ", world_seed)
	
	for x in 1 + view_distance * 2:
		for y in height:
			for z in 1 + view_distance * 2:
				load_chunk(Vector3(x - view_distance, y, z - view_distance))

func load_chunk(pos: Vector3):
	var id := vec_to_id(pos)
	
	if has_chunk(id):
		pass
	elif try_reload_cached_chunk(id):
		pass
	else:
		var new_chunk = chunk.instance().init(id, world_seed)
		_map[id] = new_chunk
		add_child(new_chunk)
		new_chunk.transform.origin = pos.floor() * Chunk.SIDE_LENGTH

func queue_unload_chunk(id):
	var chunk := get_chunk(id)
	if is_instance_valid(chunk):
		_map.erase(id)
		_cache[id] = chunk
		remove_child(chunk)

func get_chunk(id: String) -> Chunk:
	return _map[id] if has_chunk(id) else null

func has_chunk(id: String) -> bool:
	return _map.has(id) and is_instance_valid(_map[id])

func try_reload_cached_chunk(id: String) -> bool:
	if _cache.has(id) and is_instance_valid(_cache[id]):
		var chunk = _cache[id]
		_cache.erase(id)
		_map[id] = chunk
		add_child(chunk)
		return true
	else:
		return false

static func xyz_to_id(x: int, y: int, z: int) -> String:
	return String(x) + "_" + String(y) + "_" + String(z)

static func vec_to_id(v: Vector3) -> String:
	v = v.floor()
	return xyz_to_id(v.x, v.y, v.z)

func local_to_chunk(v: Vector3) -> Vector3:
	return (v / Chunk.SIDE_LENGTH).floor()

func chunk_to_local(v: Vector3):
	return v.floor() * Chunk.SIDE_LENGTH

func _on_LoadArea_body_exited(body):
	var new_position: Vector3 = local_to_chunk(to_local(body.global_transform.origin))
	$LoadOrigin.transform.origin = chunk_to_local(new_position)
	
	# Save chunks that are still to be loaded in this dictionary
	var keep_loaded := {}
	
	# Keep chunks around the new player position
	for x in 1 + view_distance * 2:
		for y in height:
			for z in 1 + view_distance * 2:
				var pos := Vector3(x - view_distance + new_position.x,
						y, z - view_distance + new_position.z)
				var id = vec_to_id(pos)
				
				var chunk = get_chunk(id)
				if not chunk:
					load_chunk(pos)
				chunk = get_chunk(id)
				
				if chunk:
					_map.erase(id)
					keep_loaded[id] = chunk
	
	# Queue unload remaining chunks
	for id in _map.keys():
		queue_unload_chunk(id)
	
	# Copy back the kept chunks
	for id in keep_loaded.keys():
		_map[id] = keep_loaded[id]

func _on_UnloadTimer_timeout():
	if _cache.size() > max_cache_size:
		for id in _cache.keys().slice(0, _cache.size() - max_cache_size - 1):
			_cache[id].queue_free()
			_cache.erase(id)
