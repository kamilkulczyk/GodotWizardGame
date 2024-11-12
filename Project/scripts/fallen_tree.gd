extends CharacterBody2D
signal flame_emitter_object(pos)

var flame_scene: PackedScene = load("res://Scenes/Flame.tscn")
var is_moving = false
var can_move_from_start = false
var direction_to_roll = Vector2.ZERO
var is_on_fire = false

func _ready() -> void:
	$time_from_fall.start()

func _physics_process(delta: float) -> void:
	move_fallen_tree(delta)

func react_on_spell(spell):
	if spell.has_method("missile"):
		if spell.spell_nr == 1:
			flamable()
		elif spell.spell_nr == 2:
			is_on_fire = false
			for child in get_children():
				if child is Flame:
					child.queue_free()
		elif spell.spell_nr == 3:
			is_moving = true
			direction_to_roll = Vector2(1, 0) if spell.direction == "right" else (Vector2(-1, 0) if spell.direction == "left" else Vector2.ZERO)

func _on_fallen_tree_hitbox_body_entered(body: Node2D) -> void:
	# Stop movement upon collision
	is_moving = false
	velocity = Vector2.ZERO

func _on_flame_emitter_object(position) -> void:
	var flame = flame_scene.instantiate()
	flame.position = position
	add_child(flame)

func move_fallen_tree(delta: float):
	if can_move_from_start and is_moving:
		var movement = direction_to_roll * 50 * delta
		var collision = move_and_collide(movement)
		# Stop movement on collision
		if collision:
			is_moving = false

func _on_time_from_fall_timeout() -> void:
	can_move_from_start = true
	
func flamable():
	if is_on_fire:
		return
	is_on_fire = true
	flame_emitter_object.emit(Vector2(0, 0))
	flame_emitter_object.emit(Vector2(0, 10))
	flame_emitter_object.emit(Vector2(0, 20))
