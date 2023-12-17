extends State

@export var idle_state: State
@export var fall_state: State

func enter() -> void:
	super()
	parent.velocity.y = parent.jump_velocity

func process_physics(delta: float) -> State:
	var dir = Input.get_axis("walk_left", "walk_right")
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.velocity.y > 0: return fall_state
	return null
