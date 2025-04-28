extends Node3D
# Introduce the GUIDE mapping contexts.
@export var walk_mode:GUIDEMappingContext
@export var shared_context:GUIDEMappingContext
@export var pilot_mode:GUIDEMappingContext

# Start with the mouse captured by default.
@onready var mouse_captured = true

# "T" key toggles control modes between walk and pilot mapping contexts.
# Ultimately I will want this to only trigger when inside the train engine.
@export var mode_swap:GUIDEAction
# Context mode Toggle begins in off position.
@onready var pilot_mode_active = true

func _ready():
	GUIDE.enable_mapping_context(pilot_mode)
	GUIDE.enable_mapping_context(shared_context)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# This lets me recover the mouse cursor while the game is running.
	if event.is_action_pressed("escape_mouse"):
		cursor_toggle()

#func _process(delta):
	#if mode_swap.is_triggered():
		#swap_modes()

func cursor_toggle():
	if Input.is_action_just_pressed("escape_mouse"):
		mouse_captured = !mouse_captured
	match mouse_captured:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		false:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Disabling mode swapping. No walking allowed.
#func swap_modes():
	#pilot_mode_active = !pilot_mode_active
	#match pilot_mode_active :
		#true:
			#GUIDE.enable_mapping_context(pilot_mode)
			#GUIDE.disable_mapping_context(walk_mode)
		#false:
			#GUIDE.enable_mapping_context(walk_mode)
			#GUIDE.disable_mapping_context(pilot_mode)
			

	
