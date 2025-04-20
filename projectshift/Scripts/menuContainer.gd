extends VBoxContainer

const LEVEL_SELECT = preload("res://Scenes/Menus/chapterselect_menu.tscn")

#choose level button stuff
func _on_level_select_button_pressed():
	get_tree().change_scene_to_packed(LEVEL_SELECT)
	
func _on_level_select_button_mouse_entered():
	$LevelSelectButton.text = "Should we begin testing?"
func _on_level_select_button_mouse_exited():
	$LevelSelectButton.text = "Choose level"



#quit button stuff
func _on_quit_button_pressed():
	get_tree().quit()

func _on_quit_button_mouse_entered():
	$QuitButton.text = "You ready to leave this place?"

func _on_quit_button_mouse_exited():
	$QuitButton.text = "Quit game"


#Credits button stuff
func _on_credits_button_mouse_entered():
	$CreditsButton.text = "This doesn't work yet."


func _on_credits_button_mouse_exited():
	$CreditsButton.text = "Roll credits"
	

#settings button stuff

func _on_settings_button_mouse_entered():
	$SettingsButton.text = "Wanna customize your gear?\n(this button doesnt work yet)"


func _on_settings_button_mouse_exited():
	$SettingsButton.text = "Settings"
