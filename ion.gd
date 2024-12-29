# ion.gd   by Austin Cain @ 12/27/2024
# Simulates charged particle. Has collisions and is affected by magnetic fields.
extends Area2D

signal playerHit

@export var speed = 200
var velocity
var isPositiveCharge = true
var immunityMask


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(1,0)
	immunityMask = 0

func _process(delta):
	magneticForce(get_overlapping_areas())
	position += velocity.normalized() * speed * delta


func setCharge(charge):
	isPositiveCharge = charge
	# Set Texture of Ion to Match Charge
	if charge == false:
		$Sprite2D.texture = load("res://Art/IonNegative.png")
	else:
		$Sprite2D.texture = load("res://Art/IonPositive.png")


func setVelocity(newVel):
	velocity = newVel

func setSpeed(newSpeed):
	speed = newSpeed

# Collision Handler
func _on_body_entered(body):
	if body.is_in_group("Player") && immunityMask != 1:
		playerHit.emit()
		print("AAH")
		queue_free()
	if body.is_in_group("Enemy") && immunityMask != 2:
		body.kill()
		print("AAH")
		queue_free()
	else:
		print("Collision!")


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("left")
	queue_free()


func magneticForce(fields):
	
	var netForce = Vector2.ZERO
	for f in fields:
		if !f.is_in_group("PositiveField") && !f.is_in_group("NegativeField"):
			continue
		if f.get_parent().is_in_group("Player") && immunityMask == 1:
			continue
		if f.get_parent().is_in_group("Enemy") && immunityMask == 2:
			continue
		
		var fPos = f.global_position
		var difference = global_position - fPos
		print("Diff", difference)
		var force = difference.normalized() * f.get_parent().fieldMagnitude
		
		if !shouldAttract(isPositiveCharge, f.is_in_group("PositiveField")):
			force *= -1
		print(force)
		var distance = f.get_parent().magneticRadius - difference.length() 
		distance /= f.get_parent().magneticRadius
		if distance <= 0:
			distance = 0
			
		netForce += force * distance
		
	setVelocity(velocity + netForce)
	print("=================")


func shouldAttract(ionCharge, fieldCharge):
	if ionCharge == fieldCharge:
		return true
	else:
		return false

func setMask(m):
	immunityMask = m
