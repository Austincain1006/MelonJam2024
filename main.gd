# main.gd   by Austin Cain @ 12/29/2024
# Composes the other Scenes together to make Feudalactic
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
	if numEnemies < enemyCap():
		spawnEnemy()
		numEnemies += 1
	
	$EnemySpawnTimer.start()
	
	# Chance to Spawn Multiple Enemies if allowed
	if (numEnemies < enemyCap() && randf() < 0.5):
		await get_tree().create_timer($EnemySpawnTimer.wait_time / randf_range(3, 8)).timeout
		spawnEnemy()
		numEnemies += 1


func enemyDestroyedObserver():
	$ExplosionSound.play()
	score += 1
	$HUD.setScore(score)
	numEnemies += -1


# Sets up the Level for a New Run
func startGame():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	$EnemySpawnTimer.start()
	$Player.global_position = $Spawnpoint.global_position
	$Player.rotation = 0
	$MusicPlayer.play()
	unFreezePlayer()
	numEnemies = 0
	score = 0
	$EnemySpawnTimer.wait_time = 6
	$HUD.setScore(score)


# Resets the Stage and Displays Game Over
func endGame():
	$EnemySpawnTimer.stop()
	freezePlayer()
	
	# Adjust & Save High Score
	if score > $HUD.highScore:
		$HUD.newHighScore = true
		$HUD.highScore = score
	else:
		$HUD.newHighScore = false
	
	$MusicPlayer.stop()
	$HUD.showGameOver()
	$GameOverSound.play()
	
	# Prevent Enemies from Firing in Game Over Screen
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.mayFire = false


func _on_hud_play_button_pressed():
	startGame()


func _on_player_player_hit():
	endGame()


# Returns the Enemy Cap, Scales with Player Score
func enemyCap():
	if score >= 5:
		$EnemySpawnTimer.wait_time = 5.5
		return 2
	if score >= 10:
		$EnemySpawnTimer.wait_time = 5
		return 3
	if score >= 16:
		$EnemySpawnTimer.wait_time = 4.5
		return 4
	if score >= 25:
		$EnemySpawnTimer.wait_time = 4
		return 5
	else:
		$EnemySpawnTimer.wait_time = 6
		return 1


# "Deletes" the Player without actually Deleting them
func freezePlayer():
	$Player.TogglePlayerModel()
	$Player.mayFire = false
	$Player.collision_layer = 0
	$Player.collision_mask = 0
	$Player.speed = 0


# Re-enables the player
func unFreezePlayer():
	$Player.TogglePlayerModel()
	$Player.mayFire = true
	$Player.collision_layer = 1
	$Player.collision_mask = 1
	$Player.speed = 169
