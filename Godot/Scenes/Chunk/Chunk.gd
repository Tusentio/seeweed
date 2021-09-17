extends Spatial
class_name Chunk

onready var map = $NodeMap;

const grass_block = preload("res://Blocks/Grass/Grass.tres");
const tree_stump_block = preload("res://Blocks/TreeStump/TreeStump.tres");

const SIDE_LENGTH := 16

var id : String;

func init(id: String):
	self.id = id;
	return self;

func _ready():
	var path := "user://" + id + ".tres";
	if File.new().file_exists(path):
		var data: ChunkData = ResourceLoader.load(path, "", true);
		load_data(data);
	else:
		generate();
		ResourceSaver.save(path, get_data());

func generate():
	for x in map.map_width:
		for y in map.map_height:
			if y == 0:
				for z in map.map_length:
					map.add(Tile.create(grass_block), Vector3(x, y, z));
			elif y == 1:
				for z in map.map_length:
					if x % 2 and z % 2 and randf() > 0.9:
						map.add(Tile.create(tree_stump_block), Vector3(x, y, z));

func load_data(data: ChunkData):
	var blocks := [];
	for block in data.blocks:
		blocks.append(load(block));
	
	var i: int = 0;
	for x in range(0, map.map_width):
		for y in range(0, map.map_height):
			for z in range(0, map.map_length):
				var index = data.tiles[i];
				if not index:
					i += 1;
					continue;
				
				var block_index := 0;
				var metadata_index := 0;
				if index is Array:
					block_index = index[0];
					metadata_index = index[1] + 1;
				else:
					block_index = index;
				
				var block = blocks[block_index - 1];
				var metadata = data.metadata[metadata_index - 1] if metadata_index else {};
				
				map.add(Tile.create(block, metadata), Vector3(x, y, z));
				i += 1;
	
	return self;

func get_data():
	var data = ChunkData.new();
	
	for layer in map.grid:
		for row in layer:
			for tile in row:
				if tile and tile.block:
					var block_index = data.blocks.find(tile.block.resource_path) + 1;
					if not block_index:
						data.blocks.append(tile.block.resource_path);
						block_index = data.blocks.size();
					
					if tile.metadata.size():
						data.tiles.append([block_index, data.metadata.size()]);
						data.metadata.append(tile.metadata);
					else:
						data.tiles.append(block_index);
				else:
					data.tiles.append(0);
	
	return data;
