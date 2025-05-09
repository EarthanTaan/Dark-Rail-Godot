extends Node3D

@export var basis_handle:Basis = basis

func _physics_process(delta: float) -> void:
	basis = basis_handle
