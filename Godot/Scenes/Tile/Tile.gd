extends StaticBody
class_name Tile

export (Resource) var block: Resource;

var metadata: Dictionary = {};
onready var mesh_instance: MeshInstance = $Mesh;

func _ready():
	if block:
		mesh_instance.mesh = block.mesh;
		block.on_tile_created(self);
	else:
		queue_free();

func init(block: Resource, metadata: Dictionary = {}):
	self.block = block;
	self.metadata = metadata;
	return self;

static func create(block: Resource, metadata: Dictionary = {}):
	return load("res://Scenes/Tile/Tile.tscn").instance().init(block, metadata);
