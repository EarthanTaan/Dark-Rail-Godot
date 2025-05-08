extends Node3D
class_name junction_class_script

@export var track_L:Path3D
@export var track_R:Path3D
@export var track_merge:Path3D

@onready var train: PathFollow3D = %train
@onready var junction: Area3D = $junction
@onready var preswitch: Area3D = $preswitch
@onready var main: Node3D = $/root/Main
@onready var current_curve: Curve3D = train.get_parent_node_3d().curve

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
			print(str(body.name) + " reparented to [" + str(track_L.name) + "], which should be the Left Track. train.junc_lever is [" + str(train.junc_lever) + "].")
		elif train.junc_lever: # true, aka Right
			if train.movement < 0: # moving backwards
				dest_track = track_L
			else: # moving forward
				dest_track = track_R
			print(str(body.name) + "reparented to [" + str(track_R.name) + "] which should be the Right Track. train.junc_lever is [" + str(train.junc_lever) + "].")
	elif !switch_look:
		dest_track = track_merge
		print("Merged to track [" + str(track_merge.name) + "]. train.junc_lever == [" + str(train.junc_lever) + "].")
	switch_look = false
	flipit()
	train.reparent(dest_track)
	print("switch_look is now [" + str(switch_look) + "].")
	train.set_progress(current_curve.get_closest_offset(train.position))
	print("Train Progress set to [" + str(train.progress) + "].")
	
	# If the train enters at the end of a curve, reverse the curve's point-sequence. 
	#if train.get_progress_ratio() > 0.5:
		#current_curve.get_baked_points()

func _on_exit_zone_body_exited(body: Node3D) -> void:
	main.junctions_on = true
	print("junctions_on is now [" + str(main.junctions_on) + "].")
	
func flipit():
	var scout = dest_track.curve.sample_baked_with_rotation(dest_track.curve.get_closest_offset(train.position)).basis.z
	var facing = train.basis.z
	if facing >= scout:
		pass
	
