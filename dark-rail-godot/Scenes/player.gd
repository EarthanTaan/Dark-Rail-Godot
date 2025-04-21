extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera = $player_camera
@export var move:GUIDEAction
@export var look:GUIDEAction

func _physics_process(delta: float) -> void:
	velocity = basis * move.value_axis_3d * SPEED
	
	# Use mouse to look around, escape key toggles cursor visibility.
	mouse_look()
	
	# I don't really know what this does it's one of Godot's built-in functions.
	move_and_slide()

func mouse_look():
	# Mouse's Y position relative to screen size is scaled 360 degrees:
	rotation_degrees.y += look.value_axis_2d.x
	# Mouse's X position relative to screen size is scaled to 180 degrees:
	camera.rotation_degrees.x += look.value_axis_2d.y
	# Stop looking up or down when you get to straight up or straight down:
	if camera.rotation_degrees.x > 90:
		camera.rotation_degrees.x = 90
	if camera.rotation_degrees.x < -90:
		camera.rotation_degrees.x = -90
