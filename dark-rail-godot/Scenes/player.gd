extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var move:GUIDEAction


func _physics_process(delta: float) -> void:
	velocity = basis * move.value_axis_3d * SPEED
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()
