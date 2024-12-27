extends CharacterBody2D


@export var speed = 220
@export var rotateSpeed = 4.0
var rotationDirection


func _physics_process(delta):
	getInput()
	rotation += rotationDirection * rotateSpeed * delta
	move_and_slide()


func getInput():
	rotationDirection = Input.get_axis("RotateLeft", "RotateRight")
	velocity = transform.x * Input.get_axis("MoveForward", "MoveBackward") * speed
