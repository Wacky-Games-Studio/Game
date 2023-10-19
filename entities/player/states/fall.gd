extends State

@export var move_state: State
@export var idle_state: State
@export var jump_state: State

func process_input(event: InputEvent) -> State:
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_wall_only():
		return jump_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if parent.is_on_wall_only():
		parent.velocity.y = min(parent.velocity.y, wall_slide_gravity)
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * speed, acceleration)
		parent.sprite.flip_h = dir < 0
	
	parent.velocity.x =  lerp(parent.velocity.x, dir * speed, acceleration)

	parent.move_and_slide()
	
	if parent.is_on_floor():
		if dir != 0:
			return move_state
		return idle_state
	
	return null
