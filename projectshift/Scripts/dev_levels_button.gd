extends Button

const DEVLEVELSMENU = preload("res://Scenes/Menus/devlevels_menu.tscn")



func _on_pressed():
		get_tree().change_scene_to_packed(DEVLEVELSMENU)
