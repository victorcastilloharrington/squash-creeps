extends CharacterBody3D

signal squashed

#Min speed of the mob in mps
@export var min_speed = 10

#Max speed of the mob in mps
@export var max_speed = 18


func _physics_process(_delta):
	move_and_slide()

func initialize(start_position, player_position):
	# We position the mob at start_position
	# and rotate it towards the player's position, so it looks at the player
	look_at_from_position(start_position, player_position, Vector3.UP)
	
 	# We rotate the mob randomly between -45 to 45deg
	# So that it doesn't move directly towards the player
	rotate_y(randf_range(-PI /4, PI / 4))
	
	# Calc a random speed
	var random_speed = randi_range(min_speed, max_speed)
	
	# calc a forward velocity that reps speed
	velocity = Vector3.FORWARD * random_speed
	
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed

func squash():
	squashed.emit()
	queue_free()
	
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
