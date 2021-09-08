extends StaticBody

export (Resource) var block: Resource;

func _ready():
	set_block(block);

func init(block: Block):
	self.block = block;
	return self;

func set_block(block: Block):
	self.block = block;
	$Origin/Mesh.set_mesh(block.mesh);

	# Randomize rotation
	var new_rotation = floor(rand_range(0, 360)) * block.random_rotation_step;
	$Origin.set_rotation_degrees(Vector3(0, new_rotation, 0));

func get_block():
	return block;
