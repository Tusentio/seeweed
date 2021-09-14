extends Spatial

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

func _on_LoadArea_body_exited(body):
	var load_center: Vector3 = map.world_to_map($LoadArea.global_transform.origin);
	var move: Vector3 = map.world_to_map(body.global_transform.origin) - load_center;
	
	global_transform.origin += move * map.cell_size;
