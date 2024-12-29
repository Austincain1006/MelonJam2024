# enemy.gd
extends CharacterBody2D

signal enemyDestroyed

var fieldMagnitude = 0.2
var magneticRadius = 50
@onready var playerReference
@onready var navMesh = [] 
var ionScene : PackedScene
var speed = 100
var destination

func _ready():
	playerReference = get_tree().get_first_node_in_group("Player")
	navMesh = get_tree().get_root().get_node("Main").getNavMeshArray()
	ionScene = load("res://ion.tscn")
	destination = position

func _physics_process(delta):
	pass

# Called when Enemy is Hit
func kill():
	enemyDestroyed.emit()
	queue_free()


# Fires an Ion at the Player
func shootCannon():
	var ion = ionScene.instantiate()
	
	ion.global_position = global_position
	get_tree().get_root().get_node("Main").add_child(ion)
	
	ion.setCharge(randi_range(0,1) == 1)
	ion.setMask(2)
	ion.setVelocity( (playerReference.position - position).normalized() )
	
	ion.add_to_group("Ion")


func _on_cannon_timer_timeout():
	shootCannon()


# Returns Random NavPoint from Main as Area2D Node
func getRandomNavPoint():
	# 7 rows, 9 cols
	var row = randi_range(0, 6)
	var col = randi_range(0, 8)
	return navMesh[col][row]


# Make Enemy Move to Random Point in NavMesh
func _on_move_timer_timeout():
	destination = getRandomNavPoint()
