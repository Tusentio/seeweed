extends Spatial

const CHUNK := preload("res://Scenes/Chunk/Chunk.tscn")

export (int) var view_distance := 1
export (int) var height := 1
export (int) var user_seed : int;

var world_seed : int;
var _map := {}

func _ready():
	randomize();
	world_seed = randi() if not user_seed else user_seed;
	print("World Seed: ", world_seed)
	
	for x in 1 + view_distance * 2:
		for y in height:
			for z in 1 + view_distance * 2:
				load_chunk(Vector3(x - view_distance, y, z - view_distance))

func get_block_at(pos: Vector3) -> Block:
	var chunk := get_chunk(vec_to_id(local_to_chunk(pos)))
	if chunk:
		var tile_pos := pos - chunk.transform.origin
		var tile_index := Chunk.vec_to_index(tile_pos)
		return chunk.get_block(tile_index)
	else:
		return null

func get_metadata_at(pos: Vector3) -> Dictionary:
	var chunk := get_chunk(vec_to_id(local_to_chunk(pos)))
	if chunk:
		var tile_pos := pos - chunk.transform.origin
		var tile_index := Chunk.vec_to_index(tile_pos)
		return chunk.get_metadata(tile_index)
	else:
		return {}

func set_tile_at(pos: Vector3, tile: Dictionary, sender: Object = null) -> bool:
	var chunk := get_chunk(vec_to_id(local_to_chunk(pos)))
	if chunk:
		var tile_pos := pos - chunk.transform.origin
		var tile_index := Chunk.vec_to_index(tile_pos)
		chunk.set_tile(tile_index, tile, sender)
		return true
	else:
		return false

func set_metadata_at(pos: Vector3, metadata: Dictionary,
		sender: Object = null) -> bool:
	var chunk := get_chunk(vec_to_id(local_to_chunk(pos)))
	if chunk:
		var tile_pos := pos - chunk.transform.origin
		var tile_index := Chunk.vec_to_index(tile_pos)
		chunk.set_metadata(tile_index, metadata, sender)
		return true
	else:
		return false

func delete_tile_at(pos: Vector3, sender: Object = null) -> bool:
	var chunk := get_chunk(vec_to_id(local_to_chunk(pos)))
	if chunk:
		var tile_pos := pos - chunk.transform.origin
		var tile_index := Chunk.vec_to_index(tile_pos)
		chunk.delete_tile(tile_index, sender)
		return true
	else:
		return false

func load_chunk(pos: Vector3):
	var id := vec_to_id(pos)
	
	if has_chunk(id):
		pass
	else:
		var new_chunk = CHUNK.instance()
		new_chunk.transform.origin = pos.floor() * Chunk.SIDE_LENGTH
		_map[id] = new_chunk
		new_chunk.init(id, self)
		add_child(new_chunk)

func unload_chunk(id):
	var chunk := get_chunk(id)
	if is_instance_valid(chunk):
		_map.erase(id)
		chunk.queue_free()

func get_chunk(id: String) -> Chunk:
	return _map[id] if has_chunk(id) else null

func has_chunk(id: String) -> bool:
	return _map.has(id) and is_instance_valid(_map[id])

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
		unload_chunk(id)
	
	# Copy back the kept chunks
	for id in keep_loaded.keys():
		_map[id] = keep_loaded[id]
