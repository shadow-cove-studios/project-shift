extends Control

@onready var shiftIndicator =  $RichTextLabel
func _process(delta):
	if PlayerVariables.canshift == true:
		shiftIndicator.text = "Can shift"
	else:
		shiftIndicator.text = "False"
