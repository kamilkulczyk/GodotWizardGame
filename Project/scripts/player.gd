extends CharacterBody2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 160
var player_alive = true

var attack_in_progress = false
var spell_in_progress = false

const speed = 100
var current_dir = "down"

signal spell_missile_object(pos)

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")
	position = Vector2(10 ,10)

func _physics_process(delta: float) -> void:
	attack()
	player_movement(delta)
	enemy_attack()
	
	if health <= 0:
		player_alive = false # death, do something like respawn
		print("player has been killed!")
		self.queue_free()

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		if attack_in_progress:
			velocity = Vector2(speed/2, 0)
		else:
			velocity = Vector2(speed, 0)
		play_animation(1)
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		if attack_in_progress:
			velocity = Vector2(-speed/2, 0)
		else:
			velocity = Vector2(-speed, 0)
		play_animation(1)
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		if attack_in_progress:
			velocity = Vector2(0, speed/2)
		else:
			velocity = Vector2(0, speed)
		play_animation(1)
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		if attack_in_progress:
			velocity = Vector2(0, -speed/2)
		else:
			velocity = Vector2(0, -speed)
		play_animation(1)
	else:
		play_animation(0)
		velocity = Vector2(0, 0)
		
	move_and_slide()

func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if attack_in_progress:
		play_animation_attack(movement)
	elif spell_in_progress:
		play_animation_spell(movement)
	else:
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		elif dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		elif dir == "down":
			anim.flip_h = false
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				anim.play("front_idle")
		elif dir == "up":
			anim.flip_h = false
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				anim.play("back_idle")

func play_animation_attack(movement):
	var anim = $AnimatedSprite2D
	if current_dir == "right":
		anim.flip_h = false
		anim.play("side_attack")
	if current_dir == "left":
		anim.flip_h = true
		anim.play("side_attack")
	if current_dir == "down":
		anim.flip_h = false
		anim.play("front_attack")
	if current_dir == "up":
		anim.flip_h = true
		anim.play("back_attack")

func play_animation_spell(movement):
	var anim = $AnimatedSprite2D
	if current_dir == "right":
		anim.flip_h = false
		anim.play("side_idle")
	if current_dir == "left":
		anim.flip_h = true
		anim.play("side_idle")
	if current_dir == "down":
		anim.flip_h = false
		anim.play("front_idle")
	if current_dir == "up":
		anim.flip_h = true
		anim.play("back_idle")

func player() -> void:
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack() -> void:
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health -= 20;
		enemy_attack_cooldown = false
		$take_damage_cooldown.start()
		print("health: ", health)

func _on_take_damage_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack() -> void:
	# sword attack
	if Input.is_action_just_pressed("attack"):
		if attack_in_progress == false:
			Global.player_current_attack = true
			attack_in_progress = true
			$deal_attack_timer.start()
	# spell attack
	if Input.is_action_just_pressed("spell1"):
		cast_spell(1)
	if Input.is_action_just_pressed("spell2"):
		cast_spell(2)
	if Input.is_action_just_pressed("spell3"):
		cast_spell(3)

func cast_spell(spell_nr):
	if spell_in_progress == false:
			#Global.player_current_attack = true
			spell_in_progress = true
			if spell_in_progress:
				# Move spell to in front of a player. 
				var v = Vector2(0,0)
				if current_dir == "right": v.x = 5
				elif current_dir == "left": v.x = -5
				elif current_dir == "down": v.y = 5
				else: v.y = -5
				spell_missile_object.emit($MissileStartPos.global_position + v, current_dir, spell_nr)
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false
	spell_in_progress = false
