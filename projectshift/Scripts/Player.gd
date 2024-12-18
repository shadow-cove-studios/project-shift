extends CharacterBody3D

# @tutorial:https://www.youtube.com/watch?v=A3HLeyaBCq4
# @tutorial:https://www.youtube.com/watch?v=ZzUsKizhb8o&list=PL_vkVwrwck3NJ9ajMQv7Y-DfX9gVAk5in&index=1
#
# Please understand the following, and when something breaks, insert the why below, and tick the crash counter:
#
# Crash counter:2
# the grab script still isint working

# i know the variable name "speed" is very indescriptive, but it is basically changed from 
var speed: float # walkspeed to sprintspeed depending on if you're walking or sprinting.

#please, resist the urge to change these to 99999999
const WALK_SPEED = 3.0 
const SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.003
# Get the gravity from the project settings to be synced with RigidBody nodes.
#EDIT: it was supposed to, but i couldn't call it from projectsettings so it's just hard coded in now
var gravity = 11

#headbob variables
var BOB_FREQ = 3.0
var BOB_AMP = 0.08
var t_bob = 0.0

#variables that make the head kinda exist in the code, ya know
@onready var head = $Head
@onready var camera = $Head/Camera3D

# i use arch by the way. well actually i don't.

#this function allows you to move your camera
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-65), deg_to_rad(60))
		


func _ready(): #this stole your mouse(hehe)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
#AHHH IM SO ANNOYED. btw that comment was random. it was made like a month ago from now(current date is8/26 2024)
#this function includes all movement and controls, such as gravity, jumping, sprinting, moving, and part of head bob
func _physics_process(delta):
	if not is_on_floor():# Adds the gravity.
		velocity.y -= gravity * delta #still don't know  what this math does

	#makes player jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():#this little param checker right there stops people from infjumping
		velocity.y = JUMP_VELOCITY# please don't remove it

	if Input.is_action_pressed("sprint"):#default sprint key is SHIFT
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Gets the input direction and handles the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	#one of the head bob parts that makes the head bob work ig
	t_bob += delta *velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	#the holy move and slide
	move_and_slide()
	#it makes you move in the first place, and it is ran at the the physics process, after EVERYTHING ELSE

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP +1
	pos.x = sin(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	

#these functions are triggered when the player hits bouncepads

func bounce(bounceVelocity: float):#vertical bounce function
	velocity.y = bounceVelocity

func xzbounce(bounceVelocityx: float, bounceVelocityz: float):#horizontal bounce function
	velocity.x = velocity.x + bounceVelocityx
	velocity.z = velocity.z + bounceVelocityz

func xyzbounce(bounceVelocityx: float, bounceVelocityy: float, bounceVelocityz: float):#vertical and horizontal bounce function
	velocity.x = velocity.x + bounceVelocityx
	velocity.y = velocity.y + bounceVelocityy
	velocity.z = velocity.z + bounceVelocityz




# hashtag only in ohios
#i think im loosing my mental integrity


#func _input (event):
#	if event.is_action_pressed("ui_cancel"):
#		get_tree().quit() im not using this code anymore

#type " exit or quit" in the dev console to close the debugging window
