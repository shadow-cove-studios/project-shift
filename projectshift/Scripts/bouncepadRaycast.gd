extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():#if your raycast is hitting something
		var hitObj = get_collider()#see what it is
		if hitObj != null and hitObj.has_method("bounce"):#and if it has the method "interact", and you press the interact key
			hitObj.bounce(8) #trigger the interact method on it
			
