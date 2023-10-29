extends State

@export var idle_state: State
@export var walk_state: State
@export var jump_state: State
@export var fall_state: State

var current_pushable: Pushable
var prev_dir := 0
var pushing_dir: int

func enter() -> void:
	for i in parent.get_slide_collision_count():
		var c = parent.get_slide_collision(i)
		if c.get_collider() is Pushable:
			var pushable: Pushable = c.get_collider()
			current_pushable = pushable
			pushing_dir = round(c.get_normal().x) * -1

func exit() -> void:
	prev_dir = 0
	current_pushable.force = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_floor():
		parent.spawn_jump_dust()
		return jump_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if prev_dir != 0 and dir != prev_dir:
		return walk_state
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * parent.speed, parent.acceleration)
		parent.sprite.flip_h = dir < 0
	else:
		return idle_state
	
	current_pushable.force = Vector2(100 * pushing_dir, 0)
	
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
		
	prev_dir = dir
	
	return null
