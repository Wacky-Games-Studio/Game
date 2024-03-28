extends Node2D

@onready var player: Player = $Player

func _ready():
	player.disable_walljump()

	DirAccess.remove_absolute("user://savegame.save")

func change_to_credits():
	SceneManager.change_level_specific("res://scenes/ending_credits.tscn", true, true)

func _on_button_pressed(body:Node2D):
	$AnimationPlayer.play("explode_factory")
