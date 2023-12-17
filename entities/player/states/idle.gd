extends State

@export var walk_state: State

func process_input(_event: InputEvent) -> State:
	var dir := Input.get_axis("walk_left", "walk_right")
	if dir != 0:
		return walk_state

	return null

func process_physics(_delta: float) -> State:
	parent.velocity.x += parent.get_movement_velocity(0.0)
	parent.velocity.y = parent.get_clamped_gravity()
	parent.move_and_slide()
	
	return null
