extends CharacterBody3D

# @tutorial:https://www.youtube.com/watch?v=A3HLeyaBCq4
# @tutorial:https://www.youtube.com/watch?v=ZzUsKizhb8o&list=PL_vkVwrwck3NJ9ajMQv7Y-DfX9gVAk5in&index=1
#
# Please understand the following, and when something breaks, insert the why below, and tick the crash counter:
#
# Crash counter:0

var speed

const WALK_SPEED = 4.0 #please, resist the urge to change this to 99999999
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.003
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 11

#headbob variables
var BOB_FREQ = 2.0
var BOB_AMP = 0.08
var t_bob = 0.0



@onready var head = $Head
@onready var camera = $Head/Camera3D

# i use arch by the way. well actually i don't.\

#this function allows you to move your camera
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-65), deg_to_rad(60))

func _ready(): #this stole your mouse(hehe)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#AHHH IM SO ANNOYED
func _physics_process(delta):
	# Add the gravity. -- godot, you should not of given me this power
	if not is_on_floor():
		velocity.y -= gravity * delta #still don't know  what this math does

	#makes player jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():#this little param checker right there stops people from infjumping
		velocity.y = JUMP_VELOCITY# please don't remove it

	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	#head bob part that makes the head bob work ig
	t_bob += delta *velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP +1
	pos.x = sin(time * BOB_FREQ / 2) * BOB_AMP 
	return pos

# hashtag only in ohios
