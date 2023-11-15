extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var wall_jump_state: State

func process_input(_event: InputEvent) -> State:
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_wall_only_raycast():
		parent.spawn_dust(Player.ParticlesType.Jump)
		parent.flip(not parent.sprite.flip_h)
		return wall_jump_state
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta
	parent.velocity.y = min(parent.velocity.y, parent.wall_slide_gravity)
	
	parent.move_and_slide()
	
	var dir = Input.get_axis("walk_left", "walk_right")
	dir *= -1
	
	if dir != parent.get_wall_normal().x and dir != 0:
		return fall_state
	
	if parent.is_on_wall_only_raycast():
		return null
	
	if parent.is_on_floor():
		return idle_state

	return fall_state
