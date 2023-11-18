extends State

@export var idle_state: State
@export var fall_state: State
@export var wall_slide_state: State

func enter() -> void:
	super()
	parent.velocity = Vector2(parent.get_wall_normal().x * parent.wall_jump_pushback, parent.jump_velocity)

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.wall_jump_gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	parent.move_and_slide()
	
	if parent.is_on_wall_only() and not parent.is_moving_away_from_wall():
		return wall_slide_state
	
	if parent.is_on_floor():
		return idle_state
	
	return null
