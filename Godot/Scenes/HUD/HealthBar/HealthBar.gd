extends TextureRect

# Get player
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];

func _ready():
	player.connect("health_update", self, "_on_health_update");
	_on_health_update(player.health);

func _on_health_update(new_health):
	$Progress.max_value = player.max_health;
	$Progress.value = new_health;
