# player.gd   by Austin Cain @ 12/27/2024
# Player character, handles inputs, movements, and cannon fire.
extends CharacterBody2D

@export var speed = 220
@export var rotateSpeed = 4.0
@export var ionScene : PackedScene
var rotationDirection
var cannonFired
var fieldMagnitude = 10


func _ready():
	cannonFired = false
	ionScene = load("res://ion.tscn")


func _process(delta):
	# Get Mouse Input for Cannon Firing
	if Input.is_action_pressed("FirePositive"):
		fire(true)
	elif Input.is_action_pressed("FireNegative"):
		fire(false)
	
	for x in $PositivePole.get_overlapping_areas():
		magneticField(x, delta)


# Fire Ion Cannon
func fire(charge):
	if cannonFired:
		return
	
	var ion = ionScene.instantiate()
	
	if charge:
		ion.setCharge(true)
	else:
		ion.setCharge(false)
		
	owner.add_child(ion)
	ion.transform = $CannonBarrel.global_transform
	#ion.setVelocity($CannonBarrel.transform.forward)
	
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
	pass


# Affects Ions when near Negative Pole
func _on_negative_pole_area_entered(area):
	pass


func _on_cannon_timer_timeout():
	cannonFired = false


func magneticField(body, delta):
	pass
