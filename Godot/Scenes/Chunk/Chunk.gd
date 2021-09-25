extends Spatial
class_name Chunk

const GRASS_BLOCK = preload("res://Blocks/Grass/Grass.tres");
const TREE_STUMP_BLOCK = preload("res://Blocks/TreeStump/TreeStump.tres");

const SIDE_LENGTH := 16;
const PLANE_SIZE := SIDE_LENGTH * SIDE_LENGTH;
const VOLUME_SIZE := SIDE_LENGTH * SIDE_LENGTH * SIDE_LENGTH;

var id : String;
var path : String;
var chunk_seed : int;
var terrain: Object;
var random := RandomNumberGenerator.new();

var tiles := [];
onready var tile_map := $GridMap;

func _init():
	tiles.resize(VOLUME_SIZE);

func init(id: String, terrain: Object):
	self.id = id;
	chunk_seed = terrain.world_seed ^ id.hash();
	path = "user://" + id + ".res";
	self.terrain = terrain;
	return self;

func _ready():
	_load();

func _load(_userdata = null):
	if File.new().file_exists(path):
		load_data(ResourceLoader.load(path, "", true));
	else:
		generate();

func _on_SaveTimer_timeout():
	if is_inside_tree():
		save();

func _exit_tree():
	save();

func set_tile(index: int, tile: Dictionary, sender: Object = null):
	var block: Block = tile.block if tile.has("block") else null;
	if block and not block is Block:
		block = null;
		
	var metadata = tile.metadata if tile.has("metadata") else null;
	if not metadata or not metadata is Dictionary or metadata.empty():
		tiles[index] = block;
	else:
		tiles[index] = [block, metadata];
	
	if block:
		var position = index_to_world(index);
		block.on_create(position, terrain, sender);
	
	update_cell(index);

func set_metadata(index: int, metadata: Dictionary, sender: Object = null):
	var block: Block;
	
	var data = tiles[index];
	if data is Array:
		block = data[0];
		data[1] = metadata.duplicate();
	else:
		block = data;
		tiles[index] = [data, metadata];
	
	if block:
		var position = index_to_world(index);
		block.on_metadata_update(position, terrain, sender);

func get_block(index: int) -> Block:
	var data = tiles[index];
	if data is Array:
		return data[0];
	else:
		return data;

func get_metadata(index: int) -> Dictionary:
	var data = tiles[index];
	if data is Array:
		return data[1].duplicate();
	else:
		return {};

func update_cell(index: int):
	var item_name: String;
	var orientation := 0;
	var position := index_to_world(index);
	
	var block := get_block(index);
	if block:
		var seeds := preseed(index, 2);
		
		random.seed = seeds.pop_back();
		item_name = block.get_map_item_name(position, terrain, random);
		
		random.seed = seeds.pop_back();
		orientation = block.get_orientation(position, terrain, random);
	
	if item_name:
		var item = tile_map.mesh_library.find_item_by_name(item_name);
		tile_map.set_cell_item(position.x, position.y, position.z, item,
				orientation);
	else:
		tile_map.set_cell_item(position.x, position.y, position.z, -1);

func preseed(index: int, count: int) -> Array:
	random.seed = chunk_seed ^ index;
	var seeds := [];
	for i in count:
		seeds.append(random.randi());
	return seeds;

func delete_tile(index: int, sender: Object = null):
	var block = get_block(index);
	if block:
		var position := index_to_world(index);
		block.on_destroy(position, terrain, sender);
	tiles[index] = null;
	update_cell(index);

func generate():
	for i in VOLUME_SIZE:
		var y := y_of_index(i);
		
		if y == 0:
			set_tile(i, {
				block = GRASS_BLOCK,
			});
		elif y == 1:
			var x := x_of_index(i);
			var z := z_of_index(i);
			
			random.seed = chunk_seed ^ i;
			if x % 2 and z % 2 and random.randf() > 0.9:
				set_tile(i, {
					block = TREE_STUMP_BLOCK,
				});

func load_data(data: ChunkData):
	for i in VOLUME_SIZE:
		var tile = data.tiles[i];
		
		if tile:
			var block: Block = null;
			var metadata := {};
			
			if tile is Array:
				block = tile[0];
				metadata = tile[1];
			else:
				block = tile;
			
			set_tile(i, {
				block = block,
				metadata = metadata,
			});
	return self;

func save():
	var chunk_data = ChunkData.new();
	chunk_data.tiles = tiles.duplicate();
	ResourceSaver.save(path, chunk_data,
			ResourceSaver.FLAG_COMPRESS);

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

func chunk_to_world(x: int, y: int, z: int) -> Vector3:
	return tile_map.map_to_world(x, y, z);

func index_to_world(index: int) -> Vector3:
	return chunk_to_world(x_of_index(index), y_of_index(index),
			z_of_index(index));
