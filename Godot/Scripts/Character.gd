extends KinematicBody

signal health_update;

export (int) var speed: int = 4;

# Health
export (int) var max_health: int;
export (int) var health: int;

func change_health(delta: int):
	health = clamp(health + delta, 0, max_health);
	emit_signal("health_update", health);
