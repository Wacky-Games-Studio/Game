extends Area2D

@export var region_off: Rect2
@export var region_on: Rect2

var spawn_pos: Vector2i = Vector2i(0, 0)
var already_passed := false

func _ready():
	spawn_pos = $SpawnLoaction.position
	
	if not GlobalState.has_died:
		return
	
	var index = -1	
	for i in $"..".get_children():
		index += 1
		if i != self: 
			continue

		if GlobalState.checkpoints_state.size() <= index:
			already_passed = false
			break

		already_passed = GlobalState.checkpoints_state[index]
		
	
	if already_passed:
		$Eyes.region_rect = region_on
	else:
		$Eyes.region_rect = region_off

func _on_body_entered(body):
	if body is Player and not already_passed:
		already_passed = true
		GlobalState.checkpoint_collected()
		$Eyes.region_rect = region_on
		$AnimationPlayer.play("captured")
		
		var index = -1
		for i in $"..".get_children():
			index += 1
			if i != self: 
				continue
			
			if GlobalState.checkpoints_state.size() <= index:
				for j in range(index + 1):
					GlobalState.checkpoints_state.push_back(false)
			
			print("index: ", index)
			GlobalState.checkpoints_state[index] = already_passed
