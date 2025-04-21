extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera = $player_camera
@export var free_mouse:GUIDEAction
@export var move:GUIDEAction
@export var look:GUIDEAction


func _physics_process(delta: float) -> void:
	velocity = basis * move.value_axis_3d * SPEED
	rotation_degrees.y += look.value_axis_1d
	
	
	
	move_and_slide()
