extends StaticBody3D


@onready var animation_player = $AnimationPlayer



	
func interact():
	animation_player.play("pushdown")
	#insert what you want the button to do here via a method on something added as a onready variable
	await get_tree().create_timer(0.2, false).timeout
	animation_player.play("pushup")


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
