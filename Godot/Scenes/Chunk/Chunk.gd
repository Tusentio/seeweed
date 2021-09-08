extends Spatial

onready var map = $NodeMap;

const grass_block = preload("res://Blocks/Grass/Grass.tres");
const log_pile_block = preload("res://Blocks/LogPile/LogPile.tres");
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
					if randf() > 0.975:
						map.add(tile.instance().init(log_pile_block), Vector3(x, y, z));
