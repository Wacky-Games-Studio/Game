extends State

@export var move_state: State
@export var idle_state: State
@export var fall_state: State

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y < 0:
		return fall_state
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	var movement = Input.get_axis('walk_left', 'walk_right')
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * speed, acceleration)
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = jump_speed
