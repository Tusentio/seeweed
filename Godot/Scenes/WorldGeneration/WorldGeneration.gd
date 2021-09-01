extends Node

onready var chunk = preload("res://Scenes/Chunk/Chunk.tscn");
onready var map = $NodeMap;

func _ready():
	for x in map.map_width:
		for z in map.map_length:
			map.add(chunk.instance(), Vector3(x, 0, z));
