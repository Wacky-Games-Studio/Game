extends State

@export var move_state: State
@export var idle_state: State
@export var fall_state: State

func enter():
	super()
	parent.jumps_remaining -= 1
	
	if not parent.is_on_wall_only():
		parent.velocity.y = parent.jump_velocity
	else:
		parent.velocity = Vector2(parent.get_wall_normal().x * parent.wall_jump_pushback, parent.jump_velocity)

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta
	
	if parent.is_on_wall_only() and InputBuffer.is_action_press_buffered("jump"):
		parent.velocity = Vector2(parent.get_wall_normal().x * parent.wall_jump_pushback, parent.jump_velocity)
	
	if parent.velocity.y >  0:
		return fall_state
		
	#if Input.is_action_just_released("jump") and parent.velocity.y < 0:
	#	parent.velocity.y *= 0.1
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * parent.speed, parent.acceleration)
		parent.sprite.flip_h = dir < 0
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.air_friction)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if dir != 0:
			return move_state
		return idle_state
	
	return null
