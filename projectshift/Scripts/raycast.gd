extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_colliding():
		var hitObj = get_collider()
		if hitObj != null and hitObj.has_method("interact") and Input.is_action_just_pressed("interact"):
			hitObj.interact()
