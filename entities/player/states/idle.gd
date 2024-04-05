extends State

@export var walk_state: State
@export var jump_state: State
@export var fall_state: State

func enter() -> void:
	super()
	parent.has_jumped = false

func process_input(_event: InputEvent) -> State:
	var dir := Input.get_axis("walk_left", "walk_right")
	if dir != 0: return walk_state
	
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_floor_raycasts(): return jump_state
	
	return null

func process_physics(delta: float) -> State:	
	parent.velocity.x += parent.get_movement_velocity(0.0)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.velocity.y > 0.0: return fall_state
	
	return null
