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

func kill():
	enemyDestroyed.emit()
	queue_free()


func shootCannon():
	var ion = ionScene.instantiate()
	ion.position = global_position

	get_tree().get_root().add_child(ion)
	
	ion.setCharge(randi_range(0,1) == 1)
	ion.setMask(2)
	ion.setVelocity( playerReference.global_position - global_position )
	print(ion.immunityMask)


func _on_cannon_timer_timeout():
	shootCannon()
