#asteroid.gd
extends Area2D

var isPositiveCharge
@export var speed = 200
var velocity
var fieldMagnitude = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	isPositiveCharge = null
	setVelocity( Vector2(1,0) )


func _physics_process(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta


func setVelocity(vel):
	velocity = vel
	velocity = velocity.normalized() * speed


func setCharge(charge):
	isPositiveCharge = charge
	if charge:
		$Sprite2D.texture = load("res://Art/asteroidPositive.png")
		$MagneticField.add_to_group("PositiveField")
		$MagneticField.remove_from_group("NegativeField")
	if !charge:
		$Sprite2D.texture = load("res://Art/asteroidNegative.png")
		$MagneticField.add_to_group("NegativeField")
		$MagneticField.remove_from_group("PositiveField")



func _on_area_2d_area_entered(area):
	if isPositiveCharge == null || !area.is_in_group("Ion"):
		return


# Main Collision Hitbox
func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
