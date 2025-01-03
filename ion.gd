# ion.gd   by Austin Cain @ 12/27/2024
# Simulates charged particle. Has collisions and is affected by magnetic fields.
extends Area2D

@export var speed = 170
var velocity
var isPositiveCharge = true
var immunityMask
var fieldMagnitude = 0.05
var magneticRadius = 64
var creator


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
		$Sprite2D.texture = load("res://Art/Sprites/IonNegative.png")
		$MagneticField.add_to_group("NegativeField")
	else:
		$Sprite2D.texture = load("res://Art/Sprites/IonPositive.png")
		$MagneticField.add_to_group("PositiveField")


func setVelocity(newVel):
	velocity = newVel


func setSpeed(newSpeed):
	speed = newSpeed


# Collision Handler
func _on_body_entered(body):
	if body.is_in_group("Player") && immunityMask != 1:
		body.killPlayer()
		queue_free()
	if body.is_in_group("Enemy") && immunityMask != 2:
		body.kill()
		queue_free()
	else:
		pass


# Handle Ion-to-Ion Collisions
func _on_area_entered(area):
	if area.is_in_group("Ion"):
		if area != $MagneticField && (area.isPositiveCharge != isPositiveCharge):
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func magneticForce(array):
	var netForce = Vector2.ZERO
	
	for field in array:
		# Determine if current Area2D should affect this Ion
		if !field.is_in_group("PositiveField") && !field.is_in_group("NegativeField"):
			continue
		if field.get_parent().is_in_group("Player") && immunityMask == 1:
			continue
		if field.get_parent().is_in_group("Enemy") && immunityMask == 2:
			continue
		
		
		# Get Direction of Magnetic Force
		var difference = global_position - field.global_position
		var force = difference.normalized() * field.get_parent().fieldMagnitude
		
		# Determine Polarity & Distance Scaling
		if !shouldAttract(isPositiveCharge, field.is_in_group("PositiveField")):
			force *= -1
		var distance = field.get_parent().magneticRadius - difference.length() 
		distance /= field.get_parent().magneticRadius
		if distance <= 0:
			distance = 0
		
		netForce += force * distance
	
	setVelocity(velocity + netForce)


func shouldAttract(ionCharge, fieldCharge):
	if ionCharge == fieldCharge:
		return true
	else:
		return false

func setMask(m):
	immunityMask = m


func _on_immunity_timer_timeout():
	if !$MagneticField.get_overlapping_bodies().has(creator):
		setMask(0)
