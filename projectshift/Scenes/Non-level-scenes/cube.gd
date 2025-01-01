extends RigidBody3D

var picked_up = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if picked_up and player:
		# Update the cube's position to follow the player's camera
		global_transform.origin = player.get_node("Camera3D").global_transform.origin + player.get_node("Camera3D").global_transform.basis.z * -2

func interact():
	if not picked_up:
		pick_up()
	else:
		drop()

func pick_up():
	picked_up = true
	player = get_tree().get_nodes_in_group("player")[0]  # Assuming the player is in the "player" group
	set_physics_process(false)
	gravity_scale = 0
	collision_layer = 0
	collision_mask = 0

func drop():
	picked_up = false
	player = null
	set_physics_process(true)
	gravity_scale = 1
	collision_layer = 1
