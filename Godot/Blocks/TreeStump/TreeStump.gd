extends Block

func on_tile_created(tile: Tile):
	if not tile.metadata.has("rotation"):
		tile.metadata["rotation"] = randi() % 4;
	
	tile.mesh_instance.rotate_object_local(Vector3.UP,
			deg2rad(90 * tile.metadata["rotation"]));
	
	if not tile.metadata.has("offset"):
		tile.metadata["offset"] = Vector3(int(rand_range(-3, 3)), 0,
				int(rand_range(-3, 3)));
	
	tile.mesh_instance.transform.origin += tile.metadata["offset"] + Vector3.ONE * 0.1;
