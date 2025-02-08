extends RigidBody3D

var player
var node3d: PackedScene

func _ready():
	player = get_node("res://Scenes/Non-level-scenes/character_body_3d.tscn") # Adjust the path to your player node
	node3d = preload("res://Scenes/node_3d.tscn") # Adjust the path to your cube scene

func interact():
	# Remove the cube from the scene
	queue_free()

func drop():
	# Instance a new cube and add it in front of the player
	var new_cube = node3d.instance()
	get_tree().root.add_child(new_cube)
	new_cube.global_transform.origin = player.global_transform.origin + player.global_transform.basis.z * -2
