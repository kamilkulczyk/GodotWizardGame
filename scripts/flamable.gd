class_name Flamable extends Node

signal flame_emiter_object(pos)
var flame_scene: PackedScene = load("res://Scenes/Flame.tscn")

func flamable(tree, pos):
	flame_emiter_object.emit(tree, pos)

func _on_flame_emiter_object(tree, pos: Variant) -> void:
	print("l")
	var flame = flame_scene.instantiate()
	flame.position = pos
	tree.add_child(flame)
