extends CharacterBody2D

# the bigger value, the slower movement.
@export var speed : int = 50
var player_chase = false
var player = null
var current_dir = "none"
var is_getting_damage = false
var is_shaded = false

var health = 100
var player_in_attack_zone = false
var can_take_damage = true

# TODO: actually everything
# how it interacts with the environment
# what does it do and how does it behave when damaged e.g. is in area of fire
# should there be more enemy types with a basic enemy class?

func _ready() -> void:
	add_to_group("enemies")
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	deal_with_damage()
	player_chase_movement()

func player_chase_movement() -> void:
	if player_chase:
		var position_delta = (player.position - position) / speed
		position += position_delta
		if abs(position_delta.x) > abs(position_delta.y):
			current_dir = "right" if position_delta.x > 0 else "left"
		else:
			current_dir = "up" if position_delta.y < 0 else "back"
		play_animation(1)
	else:
		play_animation(0)
		
	move_and_collide(Vector2(0,0))

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
		player_chase = false

func play_animation(movement):
	var anim = $AnimatedSprite2D
	
	if movement == 1:
		if current_dir == "right":
			anim.flip_h = false
			anim.play("side_walk")
		elif current_dir == "left":
			anim.flip_h = true
			anim.play("side_walk")
		elif current_dir == "down":
			anim.flip_h = false
			anim.play("front_walk")
		elif current_dir == "up":
			anim.flip_h = false
			anim.play("back_walk")
	else:
		anim.play("idle")

func enemy() -> void:
	pass

func react_on_spell(spell):
	is_getting_damage = true
	deal_with_damage()
	is_getting_damage = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false

# TODO: deal with a strange conditioning and variable names
func deal_with_damage() -> void:
	if (player_in_attack_zone and Global.player_current_attack == true) or is_getting_damage:
		if can_take_damage == true:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health: ", health)
			
			$demage_shader.start()
			is_shaded = true
			modulate = Color(0.9, 0.099, 0.233)
	if !is_shaded:
		modulate = Color(1,1,1)
	
	if health <= 0:
		remove_from_group("enemies")
		self.queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func _on_demage_shader_timeout() -> void:
	is_shaded = false

func flamable():
	is_getting_damage = true
