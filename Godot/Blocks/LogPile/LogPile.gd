extends Block

func on_tile_created(tile: Tile):
	if not tile.metadata.has("rotation"):
		tile.metadata["rotation"] = rand_range(0, 360);
	
	tile.mesh_instance.rotate_object_local(Vector3.UP,
			deg2rad(tile.metadata["rotation"]));
