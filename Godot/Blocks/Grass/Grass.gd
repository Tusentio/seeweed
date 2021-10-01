extends Block

const random_orientations := [0, 10];

func get_orientation(position: Vector3, terrain: Object, random: RandomNumberGenerator) -> int:
	return random_orientations[random.randi_range(0, random_orientations.size() - 1)];
