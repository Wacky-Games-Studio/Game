class_name Door
extends StaticBody2D

func open():
	$AnimationPlayer.play("open")
	
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer2D.stop()

func close():
	$AnimationPlayer.play("close")
