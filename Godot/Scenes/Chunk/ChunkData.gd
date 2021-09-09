extends Resource
class_name ChunkData

export (Array) var blocks: Array;
export (Array) var metadata: Array;
export (Array) var tiles: Array;

func _init():
	blocks = [];
	metadata = [];
	tiles = [];
