extends Node3D

@export var track_L:Path3D
@export var track_R:Path3D
@export var track_merge:Path3D

@onready var train: PathFollow3D = %train
@onready var junction: Area3D = $junction
@onready var preswitch: Area3D = $preswitch

var switch_look:bool

func _on_preswitch_body_entered(body: Node3D) -> void:
	preswitch.monitoring = false
	print("\nPreswitch tripped by [" + str(body.name) + "].")
	switch_look = true
	print("switch_look is now [" + str(switch_look) + "].")


func _on_junction_body_entered(body: Node3D) -> void:
	junction.monitoring = false
	print("\nJunction tripped by [" + str(body.name) + "]. Monitoring [" + str(junction.monitoring) + "].")
	print("junc_lever: " + str(train.junc_lever))
	# Check switch_toggle on train, reparent accordingly.
		
	if switch_look:
		if !train.junc_lever: # false, aka Left
			if train.movement < 0: # moving backwards
				train.reparent(track_R)
			else:
				train.reparent(track_L)
			print(str(body.name) + " reparented to [" + str(track_L.name) + "], which should be the Left Track. train.junc_lever is [" + str(train.junc_lever) + "].")
		else:				# true, aka Right
			if train.movement < 0: # moving backwards
				train.reparent(track_L)
			else:
				train.reparent(track_R)
			print(str(body.name) + "reparented to [" + str(track_R.name) + "] which should be the Right Track. train.junc_lever is [" + str(train.junc_lever) + "].")
		print("switch_look is now [" + str(switch_look) + "].")
		switch_look = false
	elif !switch_look:
		train.reparent(track_merge)
		print("Merged to track [" + str(track_merge.name) + "]. train.junc_lever == [" + str(train.junc_lever) + "].")


func _on_junction_body_exited(body: Node3D = train) -> void:
	junction.monitoring = true
	print("Junction exited. junction.monitoring == " + str(junction.monitoring))
