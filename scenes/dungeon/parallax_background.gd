extends ParallaxBackground

@export var front_scaling: float
@export var middle_scaling: float
@export var back_scaling: float

var player: Player

func _ready() -> void:
	while SceneManager.player == null: pass
	player = SceneManager.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		$Front.motion_offset.x = player.global_position.x * front_scaling
		$Middle.motion_offset.x = player.global_position.x * middle_scaling
		$Back.motion_offset.x = player.global_position.x * back_scaling
