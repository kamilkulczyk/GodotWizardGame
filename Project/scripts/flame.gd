extends Node2D
class_name Flame

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_flamable_area_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.has_method("flamable"):
		body.flamable()
