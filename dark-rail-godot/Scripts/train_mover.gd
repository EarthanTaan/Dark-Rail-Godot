extends PathFollow3D

# const SPEED = 5.0 # This was for character-walking, which is probably getting cut.

@onready var railroad_a: Path3D = $/root/Main/Railroad_A
@onready var railroad_b: Path3D = $/root/Main/Railroad_B
@onready var junc_range:Dictionary = {false : "Left", true : "Right"} # false = left / true = right
@onready var junc_lever:bool = false
@onready var weirdo_offset: Node3D = $/root/Main/WeirdoOffset
@onready var player: CharacterBody3D = $train_mesh/Player

@export var max_speed:float = 0.25 # The train's max speed, (future feature: upgradable through play)
@export var pilot_mode:GUIDEMappingContext
#@export var move:GUIDEAction # Not using this right now, might delete on a  later pass.
@export var train_throttle:GUIDEAction
@export var train_ebrake:GUIDEAction
@export var train_switch_toggle:GUIDEAction

# gearbox: the states | throttle_settings: a keyring to the states | throttle_lever: point at the keyring
const gearbox = {"Reverse": -0.5, "Neutral": 0, "Forward": 1.5, "Accelerate": 2}
var throttle_settings:Array = gearbox.keys() # This is now 0-3 & mapped to the key-words above.
var throttle_lever:int = 1 # Starting it in Neutral.

func _physics_process(delta):
	# Disabling walk controls until I can make them behave (or indefinitely).
	#velocity = basis * move.value_axis_3d * SPEED
	
	# Call functions here.
	control_train() # Control the train when train-context is enabled.


## Define functions below here.

# Train controls.
func control_train():
	# Used to check if pilot_mode was active here at the top, but that's now the only valid mode.
	
	## Train Throttle part:
	# W & S keys ratchet the train throttle up or down by one full setting along the scale.
	if train_throttle.is_triggered():
		throttle_lever = clampi(throttle_lever + train_throttle.value_axis_1d, 0, 3)
		# Printing what's going on so I can be sure the mechanics are happening the way I think.
		print("\nthrottle_setting: " + str(throttle_settings[throttle_lever]) + " " + 
		"\nSpeed modifier: " + str(max_speed) + " * " + str(gearbox[throttle_settings[throttle_lever]]))

	## Train Switch Toggle part:
	# Pressing left-shift will flip the toggle between the left and right positions. (But doesn't do anything yet.)
	if train_switch_toggle.is_triggered():
		junc_lever = !junc_lever
		if junc_lever: print("Track Switch: Right")
		else: print("Track Switch: Left")
		
	## Train Emergency Brake part:
	# Hold spacebar to dramatically decelerate - not sure how to approach this yet.
	#if train_ebrake.is_ongoing(): # ...something something...
		#pass
	progress += max_speed * gearbox[throttle_settings[throttle_lever]]
	weirdo_offset.rotation = Vector3(progress * 0.1, progress * -0.01, progress * 0.001)

## Now we have signals.
#func _on_track_switch_1_body_entered(body: Node3D) -> void:
	## Reminder: Left = False <=|=> True = Right
	#print("A Body entered Track Switch 1: it was " + str(body.name))
	#if junc_lever:
		#reparent(railroad_a)
	#else:
		#reparent(railroad_b)
	#print("Track Switch was " + str(junc_range[junc_lever]))


func _on_track_switch_2_body_entered(body: Node3D) -> void:
	reparent(railroad_a)
