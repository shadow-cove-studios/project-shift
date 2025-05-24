extends StaticBody3D


@onready var animation_player = $AnimationPlayer

signal buttonTriggered

var interactable = true
	
func interact():
	if interactable == true:
		animation_player.play("pushdown")
		emit_signal("buttonTriggered")
		interactable = false 
		await get_tree().create_timer(0.2, false).timeout
		animation_player.play("pushup")
		await get_tree().create_timer(0.2, false).timeout
		interactable = true


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
