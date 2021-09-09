extends StaticBody
class_name Tile

export (Resource) var block: Resource;

var metadata: Dictionary = {};
onready var mesh_instance: MeshInstance = $Mesh;

func _ready():
	if block:
		$Mesh.set_mesh(block.mesh);
		block.on_tile_created(self);
	else:
		queue_free();

func init(block: Resource, metadata: Dictionary = {}):
	self.block = block;
	self.metadata = metadata;
	return self;
