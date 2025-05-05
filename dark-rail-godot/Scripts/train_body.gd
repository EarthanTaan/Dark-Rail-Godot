extends CharacterBody3D

@export var train:PathFollow3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform = train.global_transform
