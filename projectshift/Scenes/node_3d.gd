extends Node3D

var areas: Array
@export var group: StringName

# Called when the node enters the scene tree for the first time.
#func _ready():
#	areas = get_tree().get_nodes_in_group("player")
#	
#	for i: Area3D in areas:
#		i.body_entered.connect(triggered)
#		
#func triggered(body) -> void:
#	if body.is_in_group("player"):
#		body.velocity.y = 5.0
#		print("player contact")
