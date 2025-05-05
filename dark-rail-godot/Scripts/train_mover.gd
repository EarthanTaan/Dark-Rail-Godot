extends PathFollow3D

#region Onreadies
## Junction Lever: false <=Left | Right=> true
@onready var junc_lever:bool = false
#endregion

#region Exports
## I think I need to change the whole way train speed works, for it to be upgradeable. Fortunately it is not currently upgradeable.
@export var max_speed:float = 0.25 # The train's max speed, (future feature: upgradable through play)
@export var pilot_mode:GUIDEMappingContext
#@export var move:GUIDEAction # Not using this right now, might delete on a  later pass.
@export var train_throttle:GUIDEAction
@export var train_ebrake:GUIDEAction
@export var junction_toggle:GUIDEAction
#endregion

#region Engine vars
# gearbox: the states | throttle_settings: a keyring to the states | throttle_lever: point at the keyring
#const gearbox = {"Reverse": -0.5, "Neutral": 0, "Forward": 1.5, "Accelerate": 2}
## Temporary Debug Gearbox. Has five steps: fback < back < stop > fwd > ffwd
const gearbox = {"Fast Reverse": -2, "Slow Reverse": -0.5, "Neutral": 0, "Slow Forward": 0.5, "Accelerate": 2}
var throttle_settings:Array = gearbox.keys() # This is now 0-3 & mapped to the key-words above.
@onready var throttle_lever:int =  throttle_settings.find("Neutral") # Starting it in Neutral.
#endregion

func _physics_process(delta):	
	control_train() # Control the train when train-context is enabled.


# NOTE: Define functions below here.

# Train controls.
func control_train():
	# Used to check if pilot_mode was active here at the top, but that's now the only valid mode.
	
	## Train Throttle part:
	# W & S keys ratchet the train throttle up or down by one full setting along the scale.
	if train_throttle.is_triggered():
		throttle_lever = clampi(throttle_lever + train_throttle.value_axis_1d, 0, gearbox.size()-1)
		# Printing what's going on so I can be sure the mechanics are happening the way I think.
		print("\nthrottle_setting: [" + str(throttle_settings[throttle_lever]) + "].")

	## Junction Toggle part:
	# Pressing left-shift will flip the toggle between the left and right positions. (But doesn't do anything yet.)
	if junction_toggle.is_triggered():
		junc_lever = !junc_lever
		if junc_lever: print("Track Switch: Right. [junc_lever == " + str(junc_lever) + "].")
		else: print("Track Switch: Left. [junc_lever == " + str(junc_lever) + "].")
		
	## Train Emergency Brake part:
	# Hold spacebar to dramatically decelerate - not sure how to approach this yet.
	#if train_ebrake.is_ongoing(): # ...something something...
		#pass
	
	# This is the part that actually moves the train around the track.
	progress += max_speed * gearbox[throttle_settings[throttle_lever]]
	print("Progress: [" + str(progress) + "]")
	
# Now we have signals:

#Probably going to delete this soon, as I'll be executing the track switch inside the junction.
#func WARNING: busted signal line on_body_entered(body: Node3D) -> void:
	## Reminder: Left = False <=|=> True = Right
	#print("A Body entered Track Switch 1: it was " + str(body.name))
	#if junc_lever:
		#reparent(railroad_a)
	#else:
		#reparent(railroad_b)
	#print("Track Switch was " + str(junc_range[junc_lever]))
