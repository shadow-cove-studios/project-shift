extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):#this is the script for the interact raycast, heres how it works
	if is_colliding():#if your raycast is hitting something
		var hitObj = get_collider()#see what it is
		if hitObj != null and hitObj.has_method("interact") and Input.is_action_just_pressed("interact"):#and if it has the method "interact", and you press the interact key
			hitObj.interact() #trigger the interact method on it
