extends Node2D

var spell_missile_scene: PackedScene = load("res://Scenes/Spell_missile.tscn")
var fallen_tree_scene: PackedScene = load("res://Scenes/Fallen_tree.tscn")
var flame_scene: PackedScene = load("res://Scenes/Flame.tscn")

func _on_player_spell_missile_object(position, direction, spell_nr) -> void:
	var spell_missile = spell_missile_scene.instantiate()
	spell_missile.spell_nr = spell_nr
	spell_missile.position = position
	spell_missile.direction = direction
	$Spell_missiles.add_child(spell_missile)

func _on_tree_fallen_tree_object(position, direction) -> void:
	var fallen_tree = fallen_tree_scene.instantiate()
	fallen_tree.position = position
	# TODO: coppied issue: decide if tree should lay always down or with direction of a hit.
	#fallen_tree.direction = direction
	$Fallen_tree_emitter.add_child(fallen_tree)
	fallen_tree.connect("flame_emiter_object", Callable(self, "_on_fallen_tree_flame_emiter_object"))
