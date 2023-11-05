extends Area2D

@onready var spawn_location = $SpawnLoaction
@onready var animation_player = $AnimationPlayer

var spawn_pos: Vector2 = Vector2(0, 0)
var has_passed := false

func _ready():
	spawn_pos = spawn_location.global_position
	has_passed = CheckpointManager.has_collected(self)
	
	if has_passed:
		animation_player.play("already_captured")
	else:
		animation_player.play("RESET")

func _on_body_entered(body):
	if body is Player and not has_passed:
		animation_player.play("captured")
		
		has_passed = true
		CheckpointManager.collect_checkpoint(self)
