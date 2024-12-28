extends Area2D

signal playerHit

@export var speed = 200
var velocity
var isPositiveCharge

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO
	setCharge(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta


func setCharge(charge):
	isPositiveCharge = charge
	if charge == false:
		$Sprite2D.texture = load("res://Art/IonNegative.png")
	else:
		$Sprite2D.texture = load("res://Art/IonPositive.png")


func setVelocity(newVel):
	velocity = newVel


func _on_body_entered(body):
	if body.is_in_group("Player"):
		playerHit.emit()
		queue_free()
	else:
		print("Collision!")
