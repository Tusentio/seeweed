extends Resource
class_name Block

func on_create(x: int, y: int, z: int, sender: Object):
	pass;
	
func on_destroy(x: int, y: int, z: int, sender: Object):
	pass;

func on_metadata_update(x: int, y: int, z: int, sender: Object):
	pass;

func get_map_item_name(x: int, y: int, z: int, random: RandomNumberGenerator) -> String:
	return resource_name;

func get_orientation(x: int, y: int, z: int, random: RandomNumberGenerator) -> int:
	return 0;
