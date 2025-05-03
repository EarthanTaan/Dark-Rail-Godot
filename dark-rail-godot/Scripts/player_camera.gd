extends Camera3D

@export var look:GUIDEAction

func _physics_process(delta: float) -> void:
	mouse_look()

# Use mouse to look around.
func mouse_look():
	# Mouse's Y position relative to screen size is scaled to 360 (for degrees):
	rotation_degrees.y += look.value_axis_2d.x
	# Mouse's X position relative to screen size is scaled to 180 (for degrees):
	rotation_degrees.x += look.value_axis_2d.y
	# Prevent vertical look past straight up or down:
	if rotation_degrees.x > 90:
		rotation_degrees.x = 90
	if rotation_degrees.x < -90:
		rotation_degrees.x = -90
