extends Resource
class_name Block

export (Array) var random_orientations := [];

func on_create(position: Vector3, terrain: Object, sender: Object):
	pass;
	
func on_destroy(position: Vector3, terrain: Object, sender: Object):
	pass;

func on_metadata_update(position: Vector3, terrain: Object, sender: Object):
	pass;

func get_map_item_name(position: Vector3, terrain: Object, random: RandomNumberGenerator) -> String:
	return resource_name;

func get_orientation(position: Vector3, terrain: Object, random: RandomNumberGenerator) -> int:
	if not random_orientations.empty():
		return random_orientations[random.randi_range(0, random_orientations.size() - 1)];
	else:
		return 0;
