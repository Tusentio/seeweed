extends Spatial

export (int) var map_width: int = 16;
export (int) var map_length: int = 16;
export (int) var map_height: int = 1;

export (float) var cell_size: float = 1;

export (bool) var center_x: bool = false;
export (bool) var center_y: bool = false;
export (bool) var center_z: bool = false;

var grid : Array = [];

# Fill grid array
func _ready() -> void:
	for x in map_width:
		grid.append([]);
		for y in map_height:
			grid[x].append([]);
			for z in map_length:
				grid[x][y].append(null);

	# Center map
	translate(-Vector3(
		map_width if center_x else 0,
		map_height if center_y else 0,
		map_length if center_z else 0
	) * cell_size / 2);

# Get node at coordinates
func node_at(pos: Vector3) -> Node:
	return grid[pos.x][pos.y][pos.z];

# Add node to NodeMap
func add(node: Node, pos: Vector3) -> void:
	grid[pos.x][pos.y][pos.z] = node;
	add_child(node);
	
	# Set position
	node.transform.origin = Vector3.ZERO;
	node.translate(Vector3(pos.x * cell_size, pos.y * cell_size, pos.z * cell_size));

# Remove node from NodeMap
func remove(pos: Vector3) -> void:
	var node: Node = node_at(pos);
	if is_instance_valid(node):
		node.queue_free();

# Convert map coordinates to world coordinates
func map_to_world(pos: Vector3) -> Vector3:
	return pos * cell_size + transform.origin;

# Convert world coordinates to map coordinates
func world_to_map(pos: Vector3) -> Vector3:
	return ((pos - transform.origin) / cell_size).floor();
