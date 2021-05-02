extends Control


onready var play = $PlayButton
onready var credits = $CreditsButton
onready var back = $BackButton
onready var creditstext = $Credits


var message = "Would you like to receive a vaccine?"
var curchar = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _on_CreditsButton_pressed():
	play.hide()
	credits.hide()
	creditstext.show()
	back.show()


func _on_BackButton_pressed():
	play.show()
	credits.show()
	creditstext.hide()
	back.hide()


func _on_PlayButton_pressed():
	credits.hide()
	play.hide()
	$VaccineQuestion.show()
	
	$TextTimer.start()


func _on_TextTimer_timeout():
	$VaccineQuestion.text += message[curchar]
	curchar += 1
	if curchar == message.length():
		$TextTimer.stop()
		$VaccineButton.show()
		$NoVaccineButton.show()


func _on_VaccineButton_pressed():
	get_tree().change_scene("res://Cutscene.tscn")
	God.vaccine = true


func _on_NoVaccineButton_pressed():
	get_tree().change_scene("res://World.tscn")
