extends Item

export (float) var cooldown := 1;

var current_cooldown = 1;

func _process(delta):
	current_cooldown += delta;
	
func cooled_down() -> bool:
	return current_cooldown > cooldown;

func reset_cooldown():
	current_cooldown = 0;

func on_item_use(player, pos, slot):
	var terrain = player.get_tree().get_nodes_in_group("Terrain")[0];
	var chunk_pos = terrain.local_to_chunk(terrain.to_local(pos));
	var chunk = terrain.get_chunk(terrain.vec_to_id(chunk_pos));
	
	if chunk:
		chunk.map.remove(chunk.map.world_to_map(pos));
