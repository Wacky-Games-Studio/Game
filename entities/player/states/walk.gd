extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor_raycasts(): return jump_state
	return null

func process_physics(delta: float) -> State:
	var dir := Input.get_axis("walk_left", "walk_right")
	if dir == 0: return idle_state
	
	parent.flip(dir)
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.velocity.y > 0.0: return fall_state
	
	return null


