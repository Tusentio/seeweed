extends Spatial

onready var map = $NodeMap;

const grass_block = preload("res://Blocks/Grass/Grass.tres");
const tree_stump_block = preload("res://Blocks/TreeStump/TreeStump.tres");
const tile = preload("res://Scenes/Tile/Tile.tscn");

func _ready():
	for y in map.map_height:
		if y == 0:
			for x in map.map_width:
				for z in map.map_length:
					map.add(tile.instance().init(grass_block), Vector3(x, y, z));
		else:
			for x in map.map_width:
				for z in map.map_length:
					if x % 2 and z % 2 and randf() > 0.9:
						map.add(tile.instance().init(tree_stump_block), Vector3(x, y, z));
