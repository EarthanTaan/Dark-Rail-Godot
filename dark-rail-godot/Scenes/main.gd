extends Node3D

@export var walk_mode:GUIDEMappingContext
var mouse_captured = true

func _ready():
	GUIDE.enable_mapping_context(walk_mode)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("escape_mouse"):
		cursor_toggle()

func cursor_toggle():
	match mouse_captured:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		false:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("escape_mouse"):
		mouse_captured = !mouse_captured
