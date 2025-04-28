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

# gearbox: the states | throttle_settings: a keyring to the states | throttle_lever: point at the keyring
const gearbox = {"Reverse": -0.5, "Neutral": 0, "Forward": 1.5, "Accelerate": 2}
var throttle_settings:Array = gearbox.keys() # This is now 0-3 & mapped to the key-words above.
var throttle_lever:int = 1 # Starting it in Neutral.

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
	# First, check if the pilot_mode mapping context is active.
	if GUIDE.is_mapping_context_enabled(pilot_mode):
		# train_throttle part:
		# The following is working. 'W' & 'S' Adjust a throttle variable up and down by an int of 1.
		if train_throttle.is_triggered():
			throttle_lever = clampi(throttle_lever + train_throttle.value_axis_1d, 0, 3)
			# Trying to see if the train_mode movement is actually being mutiplied by the hearbox values, or by zzzzzzzzzzz
			print("throttle_lever: " + str([throttle_lever]) + 
			"\nthrottle_settings: " + str(throttle_settings) + 
			"\ngearbox: " + str(gearbox))
		# Now I just have to hook that up to an actual engine mechanic.
		# train_switch_toggle part:
		# Pressing left-shift will flip the toggle between the left and right positions.
		if train_switch_toggle.is_triggered():
			track_switch_lever = !track_switch_lever
			match track_switch_lever:
				false: print("Track Switch: Left")
				true: print("Track Switch: Right")
		# train_ebrake part:
			# Hold space to dramatically decelerate - not sure how to approach this yet.
		velocity.z += -1 * SPEED * gearbox[throttle_settings[throttle_lever]]
	# Let's make sure the train can't entirely leave the player behind.
	else: # pilot_mode is NOT enabled:
		throttle_lever = 1 # Set throttle to neutral.
		# Maybe apply gentle brakes as well.
	
	
