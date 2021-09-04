extends Spatial

onready var grass = preload("res://Scenes/Tiles/Grass/Grass.tscn");
onready var log_pile = preload("res://Scenes/Tiles/LogPile/LogPile.tscn");
onready var map = $NodeMap;

func _ready():
	for x in map.map_width:
		for y in map.map_height:
			for z in map.map_length:
				
				if y == 0:
					map.add(grass.instance(), Vector3(x, y, z));
				elif y == 1 and randf() > 0.975:
					map.add(log_pile.instance(), Vector3(x, y, z));
