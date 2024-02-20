extends CharacterBody3D

#How fast the character moves in mps
@export var speed = 14

#The downward acceleretion while in the air, in mps squrt
@export var fall_acceleration = 75

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
	
	#moving character
	velocity = target_velocity
	move_and_slide()
