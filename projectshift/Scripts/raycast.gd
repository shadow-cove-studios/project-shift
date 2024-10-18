extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame
#this script basically makes it so that:
func _process(_delta):
	if is_colliding():#when your raycast hits something
		var hitObj = get_collider()#check what it is
		if hitObj != null and hitObj.has_method("interact") and Input.is_action_just_pressed("interact"):#and if you can interact with it, and you press the interact key,
			hitObj.interact()#trigger the interact method in the thing you hit
