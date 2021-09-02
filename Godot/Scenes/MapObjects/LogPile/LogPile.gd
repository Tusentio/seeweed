extends StaticBody

# Randomize rotation
func _ready():
	$Origin.set_rotation_degrees(Vector3(0, rand_range(0, 360), 0));
