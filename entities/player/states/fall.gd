extends State

@export var idle_state: State
@export var move_state: State

func process_physics(delta: float) -> State:
	var dir = Input.get_axis("walk_left", "walk_right")
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.is_on_floor_raycasts(): return idle_state if dir == 0 else move_state
	return null
