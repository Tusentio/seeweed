extends Resource
class_name Block

func on_create(position: Vector3, terrain: Object, sender: Object):
	pass;
	
func on_destroy(position: Vector3, terrain: Object, sender: Object):
	pass;

func on_metadata_update(position: Vector3, terrain: Object, sender: Object):
	pass;

func get_map_item_name(position: Vector3, terrain: Object, random: RandomNumberGenerator) -> String:
	return resource_name;

func get_orientation(position: Vector3, terrain: Object, random: RandomNumberGenerator) -> int:
	return 0;
