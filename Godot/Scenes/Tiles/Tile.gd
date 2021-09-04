extends Storable
class_name Tile

export (float) var random_rotation_step: float = 0;
export (float, 1) var min_random_scale: float = 1;

func _ready():
	# Randomize rotation
	var new_rotation = floor(rand_range(0, 360)) * random_rotation_step;
	$Origin.set_rotation_degrees(Vector3(0, new_rotation, 0));
	
	# Randomize scale
	var new_scale = rand_range(min_random_scale, 1);
	$Origin.scale_object_local(Vector3(new_scale, new_scale, new_scale));
