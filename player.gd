# player.gd   by Austin Cain @ 12/27/2024
# Player character, handles inputs, movements, and cannon fire.
extends CharacterBody2D

@export var speed = 220
@export var rotateSpeed = 4.0
@onready var ionScene : PackedScene
var rotationDirection
var cannonFired


func _ready():
	cannonFired = false
	ionScene = load("res://ion.tscn")


func _process(delta):
	# Get Mouse Input for Cannon Firing
	if Input.is_action_pressed("FirePositive"):
		fire(true)
	elif Input.is_action_pressed("FireNegative"):
		fire(false)


# Fire Ion Cannon
func fire(charge):
	if cannonFired:
		return
	
	if charge:
		print("+")
	else:
		print("-")
	
	cannonFired = true
	$CannonTimer.start()


func _physics_process(delta):
	getInput()
	rotation += rotationDirection * rotateSpeed * delta
	move_and_slide()


func getInput():
	rotationDirection = Input.get_axis("RotateLeft", "RotateRight")
	velocity = transform.x * Input.get_axis("MoveForward", "MoveBackward") * speed


# Affects Ions when near Positive Pole
func _on_positive_pole_area_entered(area):
	if area.is_in_group("Ion"):
		if area.isPositiveCharge:
			print("Positive")
		else:
			print("Negative")
	else:
		print("Other Body Entered")


# Affects Ions when near Negative Pole
func _on_negative_pole_area_entered(area):
	if area.is_in_group("Ion"):
		if area.isPositiveCharge:
			print("Positive")
		if !area.isPositiveCharge:
			print("Negative")
	else:
		print("Other Body Entered")


func _on_cannon_timer_timeout():
	cannonFired = false
