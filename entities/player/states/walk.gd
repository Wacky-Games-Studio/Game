extends State

@export var idle_state: State

func process_physics(_delta: float) -> State:
	var dir := Input.get_axis("walk_left", "walk_right")
	if dir == 0: return idle_state
	
	parent.flip(dir)
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity()
	parent.move_and_slide()
	
	return null


