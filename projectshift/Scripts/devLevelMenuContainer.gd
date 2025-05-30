extends VBoxContainer

const MainTestLevel = preload("res://Scenes/node_3d.tscn")
const levelprototyping = preload("res://Scenes/levelPrototyping.tscn")


func _on_main_test_level_button_pressed():
		get_tree().change_scene_to_packed(MainTestLevel)
func _on_lvlproto_pressed():
	get_tree().change_scene_to_packed(levelprototyping)
