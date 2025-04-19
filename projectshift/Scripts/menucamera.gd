extends Camera3D

func _ready():
	await get_tree().create_timer(0.1).timeout
	rotation.x = -20
	rotation.y = -121.5
	rotation.x = clamp(rotation.x, deg_to_rad(-15), deg_to_rad(5))
	
func _process(delta):
	rotation = lerp(rotation, rotation, 0.01)
func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	if event is InputEventMouseMotion:
		rotate_object_local(Vector3.UP, event.relative.x * -0.0004)
		rotate_object_local(Vector3.LEFT, event.relative.y * 0.0005)
		rotation.x = clamp(rotation.x, deg_to_rad(-15), deg_to_rad(5))
