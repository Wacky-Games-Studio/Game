extends State

@export var idle_state: State
@export var move_state: State
@export var fall_state: State
@export var wall_slide_state: State
@export var falling_animation: String

@onready var wall_jump_timer: Timer = %WallJumpTime

var wall_direction: int

func enter() -> void:
	super()
	wall_jump_timer.start()
	
	wall_direction = 1 if parent.wall_raycasts.right else -1
	parent.velocity.y = parent.jump_velocity
	parent.velocity.x = parent.data.wall_jump_pushback * wall_direction * -1
	parent.sprite.scale = Vector2(0.7, 1.3)
	
	if parent.get_wall_normal_rays_x() != (1.0 if parent.sprite.flip_h else -1.0):
		parent.flip_opposite()

func process_physics(delta: float) -> State:
	var dir = Input.get_axis("walk_left", "walk_right")
	 
	parent.velocity.x += parent.get_movement_velocity(dir, parent.data.wall_jump_lerp if not wall_jump_timer.is_stopped() else 1.0)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.velocity.y > 0 and parent.animator.current_animation != falling_animation:
		parent.animator.play(falling_animation)
	
	if ((dir == 1 and parent.is_on_wall_right()) or (dir == -1 and parent.is_on_wall_left())) and wall_jump_timer.is_stopped():
		return wall_slide_state
	
	if (parent.wall_raycasts.left or parent.wall_raycasts.right) and Input.is_action_just_pressed("jump"):
		return self
	
	if parent.is_on_floor_raycasts():
		parent.has_jumped = false
		parent.sprite.scale = Vector2(1.3, 0.7)
		return idle_state if dir == 0 else move_state
	return null
