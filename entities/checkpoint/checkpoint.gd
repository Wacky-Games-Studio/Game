@tool
extends Area2D

@export var size: Vector2i = Vector2i(20, 20) : set = _set_size, get = _get_size
@export var spawn_pos: Vector2i = Vector2i(0, 0) : set = _set_spawn_pos, get = _get_spawn_pos

var _size := Vector2i(20, 20)
var _spawn_pos := Vector2i(0, 0)

func _set_size(value):
	_size = value
	$CollisionShape2D.shape.size = value

func _get_size():
	return _size

func _set_spawn_pos(value):
	_spawn_pos = value
	$SpawnLoaction.position = value
	
func _get_spawn_pos():
	return _spawn_pos

func _ready():
	$CollisionShape2D.shape.size = _size
	$SpawnLoaction.position = _spawn_pos

func _on_body_entered(body):
	if body is Player:
		GlobalState.checkpoint_collected()
