class_name SceneManager
extends Node2D

@export var levels: Array[PackedScene]

@onready var current_scene: Node2D = $CurrentScene
@onready var transition_screen = $TransitionScreen

var level_index := 0

func _ready():
	var level = levels[level_index].duplicate().instantiate()
	current_scene.add_child(level)
	spawn_player(level)

func spawn_player(level: Node2D):
	# HACK: player and camera code should be handled by the player, sure move the player. But make the player move the camera
	var player: Player = level.get_node("Player")
	player.global_position = level.get_node("PlayerSpawn").global_position
	var camera: Camera2D = player.get_node("Camera")
	camera.unlock()
	camera.update_position()

func restart_level():
	transition_screen.transition()
	await transition_screen.transitioned
	
	GlobalState.has_died = true
	
	current_scene.get_child(0).queue_free()
	
	await current_scene.get_child_count() > 0
	
	var level = levels[level_index].duplicate().instantiate()
	current_scene.add_child(level)
	
	# spawn the player at checkpoint
	CheckpointManager.spawn_at_checkpoint(level)
	
	transition_screen.remove_transition()

func finnish_level():
	# reset state
	GlobalState.has_died = false
	CheckpointManager.reset()
	
	current_scene.get_child(0).hide()
	
	# start player fall
	var player: Player = get_node("Player")
	var viewport_size := get_viewport_rect().size
	var player_offset_x = fposmod(player.global_position.x, viewport_size.x)
	var player_offset_y = fposmod(player.global_position.y, viewport_size.y)
	
	# player offset
	var player_pos = Vector2(player_offset_x - viewport_size.x, player_offset_y - viewport_size.y)
	player.global_position = player_pos
	
	var camera: Camera2D = player.get_node("Camera")
	camera.update_position()
	camera.lock()
	
	current_scene.get_child(0).queue_free()
	
	var screen_notifier: VisibleOnScreenNotifier2D = player.get_node("OnScreenNotifier")
	screen_notifier.connect("screen_exited", screen_exit)
	
	level_index += 1
	var level = levels[level_index].duplicate().instantiate()
	current_scene.add_child(level)
	

func screen_exit():
	if current_scene.get_child_count() == 0:
		return
	
	var level = current_scene.get_child(0)
	spawn_player(level)
