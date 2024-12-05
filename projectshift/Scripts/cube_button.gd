extends StaticBody3D


@onready var animation_player = $AnimationPlayer
#add thing you want the button to interact with as onready variable here


func _on_area_3d_body_entered(body):
	animation_player.play("pressdown")
	#trigger interact function here

func _on_area_3d_body_exited(body):
	animation_player.play("pressup")
	#and if the action only works when holding down, make it stop here
