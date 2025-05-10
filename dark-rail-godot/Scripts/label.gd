extends Label

@onready var arrow: MeshInstance3D = $"../../MeshInstance3D"

func _process(delta: float) -> void:
	text = "x: " + str(arrow.basis.x) + "\ny: " + str(arrow.basis.y) + "\nz: " + str(arrow.basis.z)
