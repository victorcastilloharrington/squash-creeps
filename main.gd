extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()


func _on_mob_timer_timeout():
	#Create a new instance of mob scene
	var mob = mob_scene.instantiate()
	
	#Choose a random location along the spawn path
	#We store the reference to the SpawnLocation node
	
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	
	mob.initialize(mob_spawn_location.position, player_position)
	
	#Spawn the mob by adding it to the main scene
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		#Restart current scene
		get_tree().reload_current_scene()
