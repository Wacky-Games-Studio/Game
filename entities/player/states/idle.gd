extends State

@export var walk_state: State
@export var jump_state: State
@export var fall_state: State

func process_input(event: InputEvent) -> State:
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_floor():
		return jump_state
	
	if Input.get_axis("walk_left", "walk_right") != 0:
		return walk_state
	
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.friction)
	
	if parent.velocity.x != 0:
		parent.sprite.flip_h = parent.velocity.x < 0
	
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
	
	return null
