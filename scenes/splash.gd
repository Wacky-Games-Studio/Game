extends Node2D

func freeze():
    get_tree().paused = true

func defrozt():
    get_tree().paused = false