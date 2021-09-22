extends Node
class_name DeferredInstanciator

onready var tile := preload("res://Scenes/Tile/Tile.tscn");

var thread := Thread.new();
var calls := [];

func _ready():
	thread.start(self, "_instanciator_thread");

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		var _thread := thread;
		thread = null;
		_thread.wait_to_finish();

func _instanciator_thread():
	while thread:
		while not calls.empty():
			var call = calls.pop_back();
			var instance = call[0].instance();
			instance.call_deferred("callv", call[1], call[2]);
	OS.delay_msec(100);

func instanciate(scene, then_method, then_arg_array):
	calls.append([scene, then_method, then_arg_array]);
