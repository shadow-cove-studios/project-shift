extends Node


# These are the commands for the devconsole
func _ready() -> void:
	Console.pause_enabled = true
	Console.add_command("maximize", console_maximize)
	Console.add_command("minimize", console_minimize)
	Console.add_command("freemouse", console_freemouse)
	Console.add_command("lockmouse", console_lockmouse)
	Console.add_command("changelevel", console_changelevel, 1)
	
	
func console_maximize():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	
func console_minimize():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	

func console_freemouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func console_lockmouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func console_changelevel(param : String):
	get_tree().change_scene_to_file("res://Scenes/" + str(param) + ".tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
