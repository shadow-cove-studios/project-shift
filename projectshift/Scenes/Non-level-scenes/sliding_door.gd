extends Node3D

var open = false
@onready var AnimPlayer = $doorhinge/AnimationPlayer

func triggered():
	if open == false:
		AnimPlayer.play("doorOpen")
		open = true
	elif open == true:
		AnimPlayer.play("doorClose")
		open = false
