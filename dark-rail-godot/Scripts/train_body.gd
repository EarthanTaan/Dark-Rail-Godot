extends CharacterBody3D

@onready var junction = get_node("res://Scenes/Junction_Scene.tscn")
@onready var remote_transform_3d: RemoteTransform3D = %train/RemoteTransform3D
@onready var flipper:bool = false

func _ready() -> void:
	junction

func _on_junction_train_flip():
	flipper = !flipper
	
func _physics_process(delta: float) -> void:
	if flipper:
		rotation_degrees.y = remote_transform_3d.rotation_degrees.y + 180
	else:
		rotation_degrees.y = remote_transform_3d.rotation_degrees.y
