extends CharacterBody3D

signal hit

#How fast the character moves in mps
@export var speed = 14

#The downward acceleretion while in the air, in mps squrt
@export var fall_acceleration = 75

# Vertical impulse applied to the character upon jumping in mps.
@export var jump_impulse = 20

# Vertical impulse applied to the character upon bouncing over a mob in
# meters per second.
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	#Local direction var to store input direction
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#setting the basis will affect the rotation of the node
		$Pivot.basis = Basis.looking_at(direction)
	
	#Ground speed
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#Vertical speed
	if not is_on_floor(): #if in air, fall down
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	#Jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	#Iterate through all collisions that happened this frame
	for index in range(get_slide_collision_count()):
		
		#We get one collision with the player
		var collision = get_slide_collision(index)
		
		#If collision is with ground
		if collision.get_collider() == null:
			continue;
		
		#If collider is a mob
		if collision.get_collider().is_in_group('mob'):
			var mob = collision.get_collider()

			#We check that we are hitting it from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				#Squash and bounce
				mob.squash()
					
				target_velocity.y = bounce_impulse
				
				break;
	#moving character
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(_body):
	die()
