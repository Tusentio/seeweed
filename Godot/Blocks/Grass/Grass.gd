extends Block

func on_tile_created(tile: Tile):
	if not tile.metadata.has("turned"):
		tile.metadata["turned"] = randf() > 0.5;
	
	if tile.metadata["turned"]:
		tile.mesh_instance.rotate_object_local(Vector3.UP, deg2rad(180));
