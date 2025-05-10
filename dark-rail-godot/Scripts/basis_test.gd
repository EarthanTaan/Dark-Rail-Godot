extends MeshInstance3D

@export var basis_handle:Basis = basis
@export var rotation_handle:Vector3

func _physics_process(delta: float):
	basis = basis_handle.orthonormalized()
	global_rotation = rotation_handle
