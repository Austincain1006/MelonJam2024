# enemy.gd by Austin Cain @ 12/28/2024
# Enemy NPC that Attacks the Player
extends CharacterBody2D

signal enemyDestroyed

var fieldMagnitude = 0.3
var magneticRadius = 100
@onready var playerReference
@onready var navMesh = [] 
var ionScene : PackedScene
var speed = 4000
var destination
var targetRotation
var rotationSpeed = 0.5
var mayFire

var cannonTimer


func _ready():
	mayFire = true
	playerReference = get_tree().get_first_node_in_group("Player")
	navMesh = get_tree().get_root().get_node("Main").getNavMeshArray()
	ionScene = load("res://ion.tscn")
	destination = position
	targetRotation = 0
	setPersonality()
	$RotateTimer.timeout.emit()
	$ExplosionAnimation.hide()
	if randf() < 0.3:
		print("Shot Early!")
		$CannonTimer.wait_time = cannonTimer / 4.0
	$CannonTimer.start()


func _physics_process(delta):
	velocity = position.direction_to(destination) * speed * delta
	# Only Move when Far from Destination (Prevents Jitter)
	if !((position - destination).length() < 1):
		move_and_slide()
	rotateEnemy(delta)


# Called when Enemy is Hit
func kill():
	enemyDestroyed.emit()
	disable()
	$ExplosionAnimation.show()
	$ExplosionAnimation.play()
	await get_tree().create_timer(2.0).timeout
	hide()
	queue_free()


# Disables Enemy, to be done before queue_free() executes
func disable():
	collision_mask = 0
	collision_layer = 0
	$CharacterModel.hide()
	speed = 0
	mayFire = false
	fieldMagnitude = 0
	magneticRadius = 0


# Fires an Ion at the Player
func shootCannon():
	$CannonTimer.wait_time = cannonTimer
	$CannonTimer.start()
	var ion = ionScene.instantiate()
	
	ion.global_position = global_position
	get_tree().get_root().get_node("Main").add_child(ion)
	
	ion.setCharge(randi_range(0,1) == 1)
	ion.setMask(2)
	ion.setVelocity( (playerReference.position - position).normalized() )
	ion.creator = self
	
	$IonBlasterSound.play()
	ion.add_to_group("Ion")


func _on_cannon_timer_timeout():
	if mayFire:
		shootCannon()
		


# Returns Random NavPoint from Main as Area2D Node
func getRandomNavPoint():
	# 7 rows, 9 cols
	var row = randi_range(0, 6)
	var col = randi_range(0, 8)
	return navMesh[col][row]


# Make Enemy Move to Random Point in NavMesh
func _on_move_timer_timeout():
	destination = getRandomNavPoint().global_position


func setDestination(dest):
	destination = dest


# Sets Unique Traits to Each Enemy
func setPersonality():
	$MoveTimer.wait_time = randf_range(3, 7)
	cannonTimer = randf_range(4,7)
	$CannonTimer.wait_time = cannonTimer
	$RotateTimer.wait_time = randf_range(2, 9)
	rotationSpeed = randf_range(0.2, 1)
	speed = randi_range(3000, 5000)
	targetRotation = randf_range(0, 2 * PI)
	rotation = targetRotation


func _on_rotate_timer_timeout():
	targetRotation = randf_range(0, 2 * PI)


func rotateEnemy(delta):
	rotation = lerp_angle(rotation, targetRotation, delta * rotationSpeed)
