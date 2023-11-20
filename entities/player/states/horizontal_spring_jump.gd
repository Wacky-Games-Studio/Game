extends State

@export var move_state: State
@export var idle_state: State
@export var fall_state: State
@export var wall_slide_state: State

var return_state: State = null 

func enter() -> void:
	super()
	return_state = null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta if min(parent.velocity.y, parent.terminal_fall_velocity) != parent.terminal_fall_velocity else 0.0
	
	if parent.velocity.y > 0:
		return_state = fall_state
	
	if parent.is_on_wall_only() and not parent.is_moving_away_from_wall():
		return wall_slide_state
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.air_friction)

	parent.move_and_slide()
	
	if parent.is_on_floor():
		var dir = Input.get_axis("walk_left", "walk_right")	
		parent.jumps_remaining = parent.max_jumps
		parent.spawn_dust(Player.ParticlesType.Land)
		parent.is_spring_jump = false
		if dir != 0:
			return move_state
		return idle_state
	
	return return_state
