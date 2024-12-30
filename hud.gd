# hud.gd   by Austin Cain @ 12/29/2024
extends CanvasLayer

signal playButtonPressed
signal gameOver

var highScore
var newHighScore

func _ready():
	$Score.text = "0"
	$Message.text = "Feudalactic"
	$HighScore.hide()
	$NewHighScore.hide()
	$Button.show()
	newHighScore = false
	highScore = 0

func _on_button_pressed():
	playButtonPressed.emit()
	$Button.hide()
	$Message.hide()
	$HighScore.hide()
	$NewHighScore.hide()

func setScore(newScore):
	$Score.text = str(newScore)
	if newScore > highScore:
		highScore = newScore
		$HighScore.text = "High Score: " + str(highScore)

func showGameOver():
	$Message.text = "Game over!"
	$Message.show()
	if highScore > 0:
		$HighScore.text = "High Score: " + str(highScore)
		$HighScore.show()
	if newHighScore:
		$NewHighScore.show()
	
	await get_tree().create_timer(2).timeout
	$Button.show()
