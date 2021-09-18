extends Spatial
class_name Chunk

const grass_block = preload("res://Blocks/Grass/Grass.tres");
const tree_stump_block = preload("res://Blocks/TreeStump/TreeStump.tres");

const SIDE_LENGTH := 16;
const PLANE_SIZE := SIDE_LENGTH * SIDE_LENGTH;
const VOLUME_SIZE := SIDE_LENGTH * SIDE_LENGTH * SIDE_LENGTH;

var id : String;
var world_seed : int;
var tiles := [];

func _init():
	tiles.resize(VOLUME_SIZE);

func init(id: String, world_seed: int):
	self.id = id;
	self.world_seed = world_seed;
	return self;

func _ready():
	var path := "user://" + id + ".res";
	if File.new().file_exists(path):
		var data: ChunkData = ResourceLoader.load(path, "", true);
		load_data(data);
	else:
		generate();
		ResourceSaver.save(path, get_data(),
				ResourceSaver.FLAG_COMPRESS);

func set_tile(index: int, tile: Tile):
	delete_tile(index);
	if tile and is_instance_valid(tile):
		add_child(tile);
		tile.transform.origin = index_to_vec(index);
		tiles[index] = tile;

func delete_tile(index: int):
	if not is_air(index):
		tiles[index].queue_free();
		tiles[index] = null;

func get_tile(index: int) -> Tile:
	return tiles[index] if not is_air(index) else null;

func is_air(index: int) -> bool:
	var tile = tiles[index];
	if not tile:
		return true;
	elif not is_instance_valid(tile):
		remove_child(tile);
		tiles[index] = null;
		return true;
	else:
		return false;

func generate():
	var random_seed = id.hash() ^ world_seed;
	for i in VOLUME_SIZE:
		var y := y_of_index(i);
		if y == 0:
			seed(random_seed ^ i);
			set_tile(i, Tile.create(grass_block));
		elif y == 1:
			var x := x_of_index(i);
			var z := z_of_index(i);
			if x % 2 and z % 2 and randf() > 0.9:
				seed(random_seed ^ i);
				set_tile(i, Tile.create(tree_stump_block));

func load_data(data: ChunkData):
	var random_seed = id.hash() ^ world_seed;
	var tile_index := -1;
	for index in data.tiles:
		tile_index += 1;
		if not index:
			continue;
		
		var block_index := 0;
		var metadata_index := 0;
		if index is Array:
			if index[0] == 0:
				tile_index += index[1];
				continue;
			else:
				block_index = index[0];
				metadata_index = index[1] + 1;
		else:
			block_index = index;
		
		var block = data.blocks[block_index - 1];
		var metadata = data.metadata[metadata_index - 1] if metadata_index else {};
		
		seed(random_seed ^ tile_index);
		set_tile(tile_index, Tile.create(block, metadata));
	return self;

func get_data():
	var data = ChunkData.new();
	for i in VOLUME_SIZE:
		var tile := get_tile(i);
		if tile and tile.block:
			var block_index = data.blocks.find(tile.block) + 1;
			if not block_index:
				data.blocks.append(tile.block);
				block_index = data.blocks.size();
			
			if tile.metadata.size():
				data.tiles.append([block_index, data.metadata.size()]);
				data.metadata.append(tile.metadata);
			else:
				data.tiles.append(block_index);
		else:
			# Save single "air blocks" as 0 and consecutive
			# air blocks as [ 0, number_of_air_blocks - 1 ]
			if data.tiles.size() > 0:
				var back = data.tiles.back();
				if back is Array and back[0] == 0:
					back[1] += 1;
				elif back == 0:
					data.tiles.pop_back();
					data.tiles.append([0, 1]);
				else:
					data.tiles.append(0);
			else:
				data.tiles.append(0);
	return data;

static func x_of_index(index: int) -> int:
	return int((index % PLANE_SIZE) / SIDE_LENGTH);

static func y_of_index(index: int) -> int:
	return int(index / PLANE_SIZE);

static func z_of_index(index: int) -> int:
	return index % SIDE_LENGTH;

static func xyz_to_index(x: int, y: int, z: int) -> int:
	return y * PLANE_SIZE + x * SIDE_LENGTH + z;

static func vec_to_index(v: Vector3) -> int:
	v = v.floor();
	return xyz_to_index(v.x, v.y, v.z);

static func index_to_vec(index: int) -> Vector3:
	return Vector3(x_of_index(index),
			y_of_index(index),
			z_of_index(index));
