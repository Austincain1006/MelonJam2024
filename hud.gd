# hud.gd   by Austin Cain @ 12/29/2024
extends CanvasLayer

signal playButtonPressed

func _ready():
	$Score.text = "0"
	$Message.text = "Feudalactic"
	$Button.show()

func _on_button_pressed():
	playButtonPressed.emit()
	$Button.hide()

func setScore(newScore):
	$Score.text = newScore
