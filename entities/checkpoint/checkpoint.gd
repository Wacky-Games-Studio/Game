extends Area2D

var spawn_pos: Vector2i = Vector2i(0, 0)

func _ready():
	spawn_pos = $SpawnLoaction.position 

func _on_body_entered(body):
	if body is Player:
		GlobalState.checkpoint_collected()
