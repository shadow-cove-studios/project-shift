extends VBoxContainer

const MainTestLevel = preload("res://Scenes/node_3d.tscn")



func _on_main_test_level_button_pressed():
		get_tree().change_scene_to_packed(MainTestLevel)
