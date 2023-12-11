extends State

@export var idle_state: State
@export var fall_state: State
@export var wall_slide_state: State

var wall_dir := 0

func enter() -> void:
	super()
	wall_dir = parent.get_wall_normal().x
	parent.velocity = Vector2(wall_dir * parent.wall_jump_pushback, parent.wall_jump_velocity)

func process_physics(delta: float) -> State:
	# TODO wall jump fall state.
	parent.velocity.y += parent.get_wall_gravity() * delta
	parent.velocity.x += parent.get_wall_jump_friction(wall_dir) * delta
	
	if parent.velocity.y > 0:
		return fall_state

	parent.move_and_slide()
	
	if parent.is_on_wall_only() and not parent.is_moving_away_from_wall():
		return wall_slide_state
	
	if parent.is_on_floor():
		return idle_state
	
	return null
