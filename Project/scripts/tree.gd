extends StaticBody2D

signal flame_emitter_object(pos)

var flame_scene: PackedScene = load("res://Scenes/Flame.tscn")

const Flamable = preload("res://scripts/flamable.gd")

var health = 60
var player_in_attack_zone = false
var can_take_damage = true
var is_getting_damage = false
# TODO: decide if tree should lay always down or with direction of a hit.
var direction_to_fall = "down"
var is_shaded = false

signal fallen_tree_object(pos)

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
func deal_with_damage() -> void:
	if (player_in_attack_zone and Global.player_current_attack == true) or is_getting_damage:
		if can_take_damage == true:
			health -= 20
			$tree_take_damage_cooldown.start()
			can_take_damage = false
			print("tree health: ", health)
			$tree_damage_shader.start()
			is_shaded = true
			modulate = Color(0.9, 0.099, 0.233)
	if !is_shaded:
		modulate = Color(1,1,1)
	if health <= 0:
		self.queue_free()
		fallen_tree_object.emit($center_marker.global_position,direction_to_fall)

func react_on_spell(spell):
	# TODO: check missile/attack specific, what does it do.
	# For example: ice spell shouldnt damage
	if spell.spell_nr == 1:
		flame_emitter_object.emit(Vector2.ZERO)
	elif spell.spell_nr == 2:
		for child in get_children():
			if child is Flame:
				child.queue_free()
	elif spell.spell_nr == 3:
		print("missile")
		direction_to_fall = spell.direction
		is_getting_damage = true

func _on_tree_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true

func _on_tree_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false
	if body.has_method("missile"):
		is_getting_damage = false

func _on_tree_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func _on_tree_damage_shader_timeout() -> void:
	is_shaded = false

func _on_flame_emitter_object(pos) -> void:
	var flame = flame_scene.instantiate()
	flame.position = pos
	add_child(flame)
