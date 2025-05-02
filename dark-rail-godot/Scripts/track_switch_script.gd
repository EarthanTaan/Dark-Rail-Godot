extends Area3D



# This switch-point, the executor, will reparent the train onto the appropriate
# track, according to which preswitch was tripped beforehand.

# Whether this switch-point is "looking" the switch-state or ignoring it.
# Altered by tripping one of three pre-switches.
# If approaching the junction as a merge, this should be false.
@onready var switch_look:bool = false
@onready var train_mover: PathFollow3D = %train_mover


func _on_body_entered(body: Node3D) -> void:

	if switch_look:
		pass
		# "switch" (reparent) track onto track determined by switch_toggle state
		
	else:
		# merge (reparent) train to track A
		pass
