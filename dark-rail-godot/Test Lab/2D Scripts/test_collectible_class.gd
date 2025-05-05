extends Area2D
class_name collectible


func _on_body_entered(body: Node2D) -> void:
	queue_free()
