extends Node3D
class_name junction_class_script

@export var track_L:Path3D
@export var track_R:Path3D
@export var track_merge:Path3D

@onready var train_body: CharacterBody3D = %train_body
@onready var train: PathFollow3D = %train
@onready var junction: Area3D = $junction
@onready var preswitch: Area3D = $preswitch
@onready var main: Node3D = $/root/Main

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
	
	## If true, check junc_lever on train, reparent accordingly, then set to false.
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
	train.reparent(dest_track)
	train.set_progress(dest_track.curve.get_closest_offset(train.position))
	print("Reparented to track [" + str(dest_track.name) + "]. Junction Lever is [" + str(train.junc_lever) + "].")
	print("switch_look is now [" + str(switch_look) + "].")
	print("Train Progress set to [" + str(train.progress) + " on track [" + str(train.get_parent_node_3d().name) + "].")
	
	## The following technically works, but is so calculation-intense that it hangs the entire
	## process if it doesn't outright lockup.
	# If the train enters at the end of a curve, reverse the curve's point-sequence. 
	#if train.get_progress_ratio() > 0.5:
		#current_curve.get_baked_points()

func _on_exit_zone_body_exited(body: Node3D) -> void:
	main.junctions_on = true
	print("junctions_on is now [" + str(main.junctions_on) + "].")
