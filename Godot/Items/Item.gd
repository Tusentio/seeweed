extends Resource
class_name Item

export (int) var item_id: int;

export (String) var title: String;
export (String) var description: String;
export (Mesh) var mesh: Mesh;
export (Texture) var icon: Texture;

export (int) var max_stack_size: int = 999;
export (float) var drop_size: float = 0.4;
export (float) var held_size: float = 0.3;
export (float) var weight: float = 1.0;

func calc_max_mesh_dimension() -> float:
	# Get new item's mesh bounding box size
	var bb: Vector3 = mesh.get_aabb().size;
	# New scale from largest value in bb vector
	return max(bb.x, max(bb.y, bb.z));

func calc_drop_scale() -> Vector3:
	var ns = drop_size / calc_max_mesh_dimension();
	return Vector3(ns, ns, ns);

func calc_held_scale() -> Vector3:
	var ns = held_size / calc_max_mesh_dimension();
	return Vector3(ns, ns, ns);

func on_item_use(player, pos, slot) -> void:
	pass;
