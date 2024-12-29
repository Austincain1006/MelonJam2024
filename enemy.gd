# enemy.gd
extends CharacterBody2D

signal enemyDestroyed

var fieldMagnitude = 0.2
var magneticRadius = 50
@onready var playerReference
var ionScene : PackedScene

func _ready():
	playerReference = get_tree().get_first_node_in_group("Player")
	ionScene = load("res://ion.tscn")

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
