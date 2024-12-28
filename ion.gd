# ion.gd   by Austin Cain @ 12/27/2024
# Simulates charged particle. Has collisions and is affected by magnetic fields.
extends Area2D

signal playerHit

@export var speed = 200
var velocity
var isPositiveCharge


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO
	setCharge(true)


func _physics_process(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta


func setCharge(charge):
	isPositiveCharge = charge
	# Set Texture of Ion to Match Charge
	if charge == false:
		$Sprite2D.texture = load("res://Art/IonNegative.png")
	else:
		$Sprite2D.texture = load("res://Art/IonPositive.png")


func setVelocity(newVel):
	velocity = newVel


# Collision Handler
func _on_body_entered(body):
	if body.is_in_group("Player"):
		playerHit.emit()
		queue_free()
	else:
		print("Collision!")
