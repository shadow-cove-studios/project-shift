extends Control
@onready var crosshair = $Crosshair

var mainCrosshair = preload("res://Assets/images/pShift_crosshair_main(2).png");
var altCrosshair = preload("res://Assets/images/pShift_crosshair_alt.png");
var blockedCrosshair = preload("res://Assets/images/pShift_crosshair_main(3).png")
func _process(delta):
	if PlayerVariables.shifted == true:
		crosshair.texture = altCrosshair
	if PlayerVariables.shifted == false:
		crosshair.texture = mainCrosshair
	if PlayerVariables.canshift == false:
		crosshair.texture = blockedCrosshair
