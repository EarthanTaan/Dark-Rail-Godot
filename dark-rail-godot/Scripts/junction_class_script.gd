extends Area3D
class_name junction

@export var track_L:Path3D
@export var track_R:Path3D
@export var track_merge:Path3D

var switch_look:bool

func _on_preswitch_body_entered(body: Node3D) -> void:
	print("preswitch tripped: " + str(body.name))
	switch_look = true

func _on_body_entered(body: Node3D) -> void:
	print("junction passed: " + str(body.name))

	if switch_look:
		pass # Check switch_toggle on train, shift accordingly.
		# [get train node]
		switch_look = false
	else:
		pass #[get train node].reparent(track_merge)
