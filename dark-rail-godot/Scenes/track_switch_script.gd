extends Area3D

@onready var train_mover: PathFollow3D = $"/root/Main/Railroad*/train_mover"
@onready var junk_range = $"/root/Main/Railroad*/train_mover:junk_range"
var junk_lever

@export var left_track:Path3D
@export var right_track:Path3D

func _ready() -> void:
	print(train_mover)
	
	#junk_lever = train_mover.junk_lever

#func _on_body_entered(body: Node3D) -> void:
		## Reminder: Left = False <=|=> True = Right
	#print("A Body entered Track Switch 1: it was " + str(body.name))
	#if junc_lever:
		#body.reparent(railroad_a)
	#else:
		#body.reparent(railroad_b)
	#print("Track Switch was " + str(junc_range[junc_lever]))
