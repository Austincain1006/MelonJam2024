# player.gd   by Austin Cain @ 12/27/2024
# Player character, handles inputs, movements, and cannon fire.
extends CharacterBody2D

signal playerHit

@export var speed = 200
@export var rotateSpeed = 4.0
@export var ionScene : PackedScene
var rotationDirection
var cannonFired
var fieldMagnitude = 0.3
var magneticRadius = 100
var mayFire
var boundaryStart
var boundaryEnd

func _ready():
	cannonFired = false
	mayFire = false
	ionScene = load("res://ion.tscn")
	var playerRadius = $PlanetPrototype.get_rect().size.x / 2
	boundaryStart = Vector2(0 + playerRadius, 0 + playerRadius)
	boundaryEnd = Vector2(get_viewport_rect().size.x - playerRadius, get_viewport_rect().size.y - playerRadius)
	hide()


func _process(delta):
	# Get Mouse Input for Cannon Firing
	if Input.is_action_pressed("FirePositive") && mayFire:
		fire(true)
	elif Input.is_action_pressed("FireNegative") && mayFire:
		fire(false)


func _physics_process(delta):
	getInput()
	rotation += rotationDirection * rotateSpeed * delta
	move_and_slide()
	
	global_position = global_position.clamp(boundaryStart, boundaryEnd)
 #+ $PlanetPrototype.get_rect().size.x

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
	ion.setMask(1)
	ion.setVelocity(-$CannonBarrel.global_transform.x)
	
	$IonBlasterSound.play()
	
	cannonFired = true
	$CannonTimer.start()


# Get Mouse Input from Player
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

func killPlayer():
	playerHit.emit()
