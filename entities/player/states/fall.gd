extends State

@export var idle_state: State

func process_physics(delta: float) -> State:
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.is_on_floor_raycasts(): return idle_state
	return null
