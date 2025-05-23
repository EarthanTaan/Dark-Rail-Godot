extends Node3D
class_name junction_class_script

#region The Exports
@export var track_L:Path3D
@export var track_R:Path3D
@export var track_merge:Path3D
#endregion

#region The Onreadies
## The train's physical manifestation. (CharaterBody3D)
@onready var train_body: CharacterBody3D = %train_body
## The train's locational data-source. (PathFollow3D)
@onready var train: PathFollow3D = %train
## The remote-transform governing the orientation of the train-body from within the train-PathFollow.
@onready var remote: RemoteTransform3D = %train/RemoteTransform3D
## The specific locus of the track-switching logic within the greater 'junction_scene'
@onready var junction: Area3D = $junction
## Tripping this primes the 'junction' node to use the track-switching logic. If this isn't tripped first, 'junction' will default to the 'merge track.'
@onready var preswitch: Area3D = $preswitch
@onready var main: Node3D = $/root/Main
#@onready var flipped:bool = false
@onready var max_speed = train.max_speed
#endregion

## The track that the train will exit the junction onto.
var dest_track:Path3D

## If true, check junc_lever on train, reparent accordingly, then set to false.
var switch_look:bool = false

func _physics_process(delta: float) -> void:
	junction.monitoring = main.junctions_on
	preswitch.monitoring = main.junctions_on

func _on_preswitch_body_entered(body: Node3D) -> void:
	print("\nPreswitch tripped by [" + str(body.name) + "].")
	switch_look = true
	print("switch_look is now [" + str(switch_look) + "].")

func _on_junction_body_entered(body: Node3D) -> void:
	# Immediately deactivate monitoring, which will only be switched back on 
	# after the train leaves the broader junction area.
	main.junctions_on = false
	print("\nJunction tripped by [" + str(body.name) + "] with switch_look [" + str(switch_look) + "].")
	print("junc_lever: " + str(train.junc_lever) + " and junctions_on is [" + str(main.junctions_on) + "].")
	
	junc_eval()
	
	## The following technically works, but is so calculation-intense that it hangs the entire
	## process if it doesn't outright lockup.
	# If the train enters at the end of a curve, reverse the curve's point-sequence. 
	#if train.get_progress_ratio() > 0.5:
		#current_curve.get_baked_points()

func _on_exit_zone_body_exited(body: Node3D) -> void:
	main.junctions_on = true
	print("junctions_on is now [" + str(main.junctions_on) + "].")
	
func junc_eval():
	## If switch_look is true, check junc_lever on train, reparent accordingly, then set to false.
	if switch_look:
		if !train.junc_lever: # false, aka Left
			if train.movement < 0: # moving backwards
				dest_track = track_R
			else: # moving forwward
				dest_track = track_L
		elif train.junc_lever: # true, aka Right
			if train.movement < 0: # moving backwards
				dest_track = track_L
			else: # moving forward
				dest_track = track_R
	elif !switch_look:
		dest_track = track_merge
	switch_look = false
	flipper()
	train.reparent(dest_track)
	train.set_progress(dest_track.curve.get_closest_offset(train.position))
	print("Reparented to track [" + str(dest_track.name) + "]. Junction Lever is [" + str(train.junc_lever) + "].")
	print("switch_look is now [" + str(switch_look) + "].")
	print("Train Progress set to [" + str(train.progress) + " on track [" + str(train.get_parent_node_3d().name) + "].")

	return dest_track

func flipper():
	## The basis.z vector of a point on the destination-track that is "ahead of" where the train WILL be after it changes over.
	var scout = dest_track.curve.sample_baked_with_rotation(dest_track.curve.get_closest_offset(train.position)).basis.z
	## The basis.z vector of the train's body.
	var loc = train.position
	# DANGER: There is no more time to solve this problem. You just can't reverse the train's direction on a track.
	# 1. Change scout to a point AHEAD of hypothetical switch point.
	# 2. draw line from train loc to scout point
	# 3. .dot() the line against the train's facing normal
	# Maybe THIS will cause the trigger to fire!?
	var facing = train_body.basis.z
	
	
	#if flipped == false: # NOT flipped
	#if facing.dot(scout) < 0: # If the range between these two vectors is greater than 90 deg. (Not Aligned)
		#remote.rotation_degrees.y = 180 # rotate the remote 180deg
		#train.max_speed *= -1
		#print("max_speed is now [" + str(max_speed) + "].")
	#else:
		#print("\nflipper didn't fire")
		#flipped = !flipped
	#elif flipped == true: # IS flipped
	#if facing.dot(scout) > -1: # If the range between these two vectors is less than 180 deg. (Unite-aligned)
		#remote.rotation_degrees.y = 0 # reset the remote rotation
		#train.max_speed *= -1 # invert the max_speed
		#flipped = !flipped
