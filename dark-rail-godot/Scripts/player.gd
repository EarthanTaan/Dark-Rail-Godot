extends CharacterBody3D

@export var look:GUIDEAction
@onready var camera: Camera3D = $player_camera

func _physics_process(delta: float) -> void:
	mouse_look()

# Use mouse to look around.
func mouse_look():
	# Mouse's Y position relative to screen size is scaled to 360 (for degrees):
	rotation_degrees.y += look.value_axis_2d.x
	# Mouse's X position relative to screen size is scaled to 180 (for degrees):
	camera.rotation_degrees.x += look.value_axis_2d.y
	# Prevent vertical look past straight up or down:
	if camera.rotation_degrees.x > 90:
		camera.rotation_degrees.x = 90
	if camera.rotation_degrees.x < -90:
		camera.rotation_degrees.x = -90
