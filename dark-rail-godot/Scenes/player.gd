extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera = $player_camera
@onready var track_switch_lever = false # false = left / true = right

@export var pilot_mode:GUIDEMappingContext
@export var move:GUIDEAction
@export var look:GUIDEAction
@export var train_throttle:GUIDEAction
@export var train_ebrake:GUIDEAction
@export var train_switch_toggle:GUIDEAction

var throttle_setting:int

func _physics_process(delta):
	# Move with WASD
	# 'velocity' is built-in body-motion from move_and_slide(); 'basis' is built-in for relative rotation;
	# 'move' creates direction (x, x, 0) relative to basis; multiply by SPEED to move
	velocity = basis * move.value_axis_3d * SPEED
	
	# Call my functions.
	mouse_look() # Look with the mouse.
	control_train() # Control the train when train-context is enabled.
	
	# I don't really know what this does it's one of Godot's built-in functions.
	move_and_slide()


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

# Suite of train controls; assigning GUIDEActions to game functions.
func control_train():
	# train_throttle
	if GUIDE.is_mapping_context_enabled(pilot_mode):
		# This is working. 'W' & 'S' Adjust a throttle var up and down by 1 int.
		# Now I just have to hook that up to an actual engine mechanic.
		if train_throttle.is_triggered():
			throttle_setting += train_throttle.value_axis_1d
			# Need to lock this between a range of 4 settings.
			print(throttle_setting)
		# train_ebrake
		# train_switch_toggle
		if train_switch_toggle.is_triggered():
			track_switch_lever = !track_switch_lever
			match track_switch_lever:
				false: print("Track Switch: Left")
				true: print("Track Switch: Right")
	
	
