extends State

@export var move_state: State
@export var idle_state: State
@export var fall_state: State

func enter():
	parent.velocity.y = jump_speed

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y >  0:
		return fall_state
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * speed, acceleration)
		parent.sprite.flip_h = dir < 0
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if dir != 0:
			return move_state
		return idle_state
	
	return null
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = jump_speed
