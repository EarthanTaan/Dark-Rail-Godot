extends Node3D

@export var walk_mode:GUIDEMappingContext
@export var free_mouse:GUIDEAction

func _ready() -> void:
	GUIDE.enable_mapping_context(walk_mode)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
