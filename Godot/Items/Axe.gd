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
	terrain.delete_tile_at(pos);
