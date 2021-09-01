extends Spatial

onready var grass = preload("res://Scenes/MapObjects/Grass/Grass.tscn");
onready var map = $NodeMap;

func _ready():
	for x in map.map_width:
		for y in map.map_height:
			for z in map.map_length:
				map.add(grass.instance(), Vector3(x, y, z));
