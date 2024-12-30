# main.gd   by Austin Cain @ 12/29/2024
extends Node

@export var enemyScene : PackedScene
var numEnemies = 0
var score = 0
const MAX_ENEMIES = 5


func getNavMeshArray():
	var numRows = 7
	var numCols = 9
	var navMesh = []
	
	for c in numCols:
		navMesh.append( [] )
	
	navMesh[0] = $NavMesh/Col1.get_children()
	navMesh[1] = $NavMesh/Col2.get_children()
	navMesh[2] = $NavMesh/Col3.get_children()
	navMesh[3] = $NavMesh/Col4.get_children()
	navMesh[4] = $NavMesh/Col5.get_children()
	navMesh[5] = $NavMesh/Col6.get_children()
	navMesh[6] = $NavMesh/Col7.get_children()
	navMesh[7] = $NavMesh/Col8.get_children()
	navMesh[8] = $NavMesh/Col9.get_children()
	
	#for c in numCols:
		#print("----> ", c)
		#for r in numRows:
			#print(navMesh[c][r])
	
	return navMesh


func spawnEnemy():
	var enemy = enemyScene.instantiate()
	
	# Get Random Spawnpoint
	$EnemySpawner/EnemySpawnerPath.progress_ratio = randf()
	enemy.global_position = $EnemySpawner/EnemySpawnerPath.global_position
	
	# Spawn Enemey, Set Random Destination & Connect Signal
	add_child(enemy)
	enemy.setDestination(enemy.getRandomNavPoint().global_position)
	enemy.enemyDestroyed.connect(enemyDestroyedObserver)


func _on_enemy_spawn_timer_timeout():
	# Number of Enemies Scale with Score
	if (numEnemies < MAX_ENEMIES) && (numEnemies < (score / 3) + 1):
		spawnEnemy()
		numEnemies += 1


func enemyDestroyedObserver():
	$ExplosionSound.play()
	score += 1
	$HUD.setScore(score)
	numEnemies += -1


func startGame():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	$EnemySpawnTimer.start()
	$Player.global_position = $Spawnpoint.global_position
	$Player.show()
	$Player.mayFire = true
	numEnemies = 0
	score = 0
	$HUD.setScore(score)


func endGame():
	$EnemySpawnTimer.stop()
	$Player.hide()
	$Player.mayFire = false
	$HUD.showGameOver()
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.mayFire = false
	$GameOverSound.play()


func _on_hud_play_button_pressed():
	startGame()


func _on_player_player_hit():
	endGame()
