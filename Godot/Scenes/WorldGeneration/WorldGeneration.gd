extends Node

onready var chunk = preload("res://Scenes/Chunk/Chunk.tscn");
onready var map = $NodeMap;

func _ready():
	seed(0);
	var world_seed := randi();
	seed(world_seed);
	print("World Seed: ", world_seed);
	
	for x in map.map_width:
		for z in map.map_length:
			map.add(chunk.instance().init(world_seed ^ (x * map.map_width + z)), Vector3(x, 0, z));
