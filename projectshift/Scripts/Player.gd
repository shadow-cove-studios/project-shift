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
var SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.003
var walljumpcount: int = 0
const MAX_STEP_HEIGHT = 0.45
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF


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
@onready var collisionShape = $CollisionShape3D

#pickup system variables(ya know the first lines of this code are basically a header file but 4 godot)
var holding_object = null
var hold_position = Vector3(0, 1.5, 2)

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
	PlayerVariables.canshift = true
	
#AHHH IM SO ANNOYED. btw that comment was random. it was made like a month ago from now(current date is 8/26 2024)
#this function includes all movement and controls, such as gravity, jumping, sprinting, moving, and part of head bob
func _physics_process(delta):
	if not is_on_floor():# Adds the gravity.
		velocity.y -= gravity * delta #still don't know  what this math does

	#makes player jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():#this little param checker right there stops people from infjumping
		velocity.y = JUMP_VELOCITY# please don't remove it
	
	#this makes the player walljump
	if Input.is_action_just_pressed("ui_accept") and is_on_wall() and not is_on_floor() and walljumpcount < 2:
		velocity.y = JUMP_VELOCITY
		walljumpcount = walljumpcount +1

	#this is the biggest if condition known to man. It checks if you should be wallrunning or not.
	if Input.is_action_pressed("sprint") and is_on_wall() and not is_on_floor() and velocity.y <0 and ((velocity.x >3 or velocity.x <-3 ) or (velocity.z <-3 or velocity.z > 3)):
		velocity.y= -1
		SPRINT_SPEED = 6.5
	
	
	
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames()
		
		
	#code that makes you shift. Very simple
	if Input.is_action_just_pressed("shift") and PlayerVariables.canshift:
		if PlayerVariables.shifted == false: 
			global_position.y =  global_position.y - 50
			PlayerVariables.shifted = true
			
		elif PlayerVariables.shifted == true:
			global_position.y = global_position.y + 50
			PlayerVariables.shifted = false
	
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
	if carried_object:
		carried_object.global_position = $CarryPosition.global_position
	if not _snap_up_stairs_check(delta):
		#the holy move and slide
		move_and_slide()
		#it makes you move in the first place, and it is ran at the the physics process, after EVERYTHING ELSE
		_snap_down_to_stairs_check()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP +1
	pos.x = sin(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	


func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle


func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)
	
func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	var floor_below : bool = %StairsBelowRayCast3D.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0,-MAX_STEP_HEIGHT,0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	var down_check_result = PhysicsTestMotionResult3D.new()
	#nevermind i think this is the biggest if condition ever
	if (_run_body_test_motion(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT*2,0), down_check_result)) and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D")):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		if step_height > MAX_STEP_HEIGHT or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_collision_point() + Vector3(0, MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
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
	



@export var pickup_range: float = 3.0
@export var pickup_mask: int = 1  # Adjust this to match your cube's collision layer

var carried_object: RigidBody3D = null


func _process(_delta):
	if is_on_floor():
		walljumpcount = 0
		SPRINT_SPEED = 5.0
	if Input.is_action_just_pressed("pickup"):
		if carried_object:
			drop_object()
		else:
			pickup_object()

func pickup_object():
	var space_state = get_world_3d().direct_space_state
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()

	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * pickup_range

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = pickup_mask

	var result = space_state.intersect_ray(query)

	if result:
		var collider = result["collider"]
		if collider is RigidBody3D:
			carried_object = collider
			carried_object.freeze = true
			carried_object.global_position = $CarryPosition.global_position

func drop_object():
	if carried_object:
		carried_object.freeze = false
		carried_object = null


	if carried_object:
		carried_object.global_position = $CarryPosition.global_position
# hashtag only in ohios
#i think im loosing my mental integrity


#func _input (event):
#	if event.is_action_pressed("ui_cancel"):
#		get_tree().quit() im not using this code anymore

#type " exit or quit" in the dev console to close the debugging window


func _on_area_3d_area_entered(area):
	if area.is_in_group("Shiftblocker"):
		PlayerVariables.canshift = false


func _on_area_3d_area_exited(area):
	if area.is_in_group("Shiftblocker"):
		PlayerVariables.canshift = true
