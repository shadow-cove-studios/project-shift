extends StaticBody3D

var toggle = false
var interactable = true
@export var animation_player: AnimationPlayer


func interact():
	if interactable == true: #if interactable is true
		interactable = false  #interactable is set to false to avoid multiple interaction
		toggle = !toggle #it then makes the toggle the opposite of what it was before
		if toggle == false: #if toggle is false then it plays the close door animation
			animation_player.play("doorClose")
		if toggle == true:# and if it is true it  plays the open door animation
			animation_player.play("doorOpen")
		#after the animation starts it waits 1 sec before it can be toggled again
		await get_tree().create_timer(1.0, false).timeout
		interactable = true
