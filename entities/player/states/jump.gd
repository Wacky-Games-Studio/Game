extends State

@export var fall_state: State
@export var wall_jump_state: State

func enter() -> void:
	super()
	parent.velocity.y = parent.jump_velocity
	parent.has_jumped = true
	parent.sprite.scale = Vector2(0.7, 1.3)

func process_input(_event: InputEvent) -> State:
	if parent.walljump_enabled and parent.is_on_wall_custom() and Input.is_action_just_pressed("jump"):
		return wall_jump_state
	
	return null

func process_physics(delta: float) -> State:	
	var dir = Input.get_axis("walk_left", "walk_right")
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	
	parent.nudge()
	parent.move_and_slide()
	
	if parent.was_nudged:
		parent.velocity.x = parent.nudge_keep_velocity.x
	
	if parent.velocity.y > 0: return fall_state
	return null
