extends Area2D#RigidBody2D

var direction = "none"
var speed = 100
var spell_nr = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, 'scale', Vector2(1,1), 0.4).from(Vector2(0.5, 0.5))
func missile():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta)
	#move_and_collide(Vector2(0,0))

func movement(delta):
	if speed > 0:
		play_animation(1)
	else:
		play_animation(0)
	if direction == "right":
		position += Vector2(speed*delta, 0)
	if direction == "left":
		position += Vector2(-speed*delta, 0)
	if direction == "down":
		position += Vector2(0, speed*delta)
	if direction == "up":
		position += Vector2(0, -speed*delta)

func play_animation(state):
	if state == 1:
		if spell_nr == 1:
			$AnimatedSprite2D.play("fire_shuriken")
		elif spell_nr == 2:
			$AnimatedSprite2D.play("ice_attack")
		elif spell_nr == 3:
			$AnimatedSprite2D.play("temp")
	else:
		if spell_nr == 1:
			$AnimatedSprite2D.play("fire_ends")
		elif spell_nr == 2:
			$AnimatedSprite2D.play("ice_attack")
		elif spell_nr == 3:
			$AnimatedSprite2D.play("explosion")

func _on_missile_hitbox_body_entered(body: Node2D) -> void:
	if !body.has_method("missile"):
		get_node("CollisionShape2D").set_deferred("disabled", true)
		if body.has_method("react_on_spell"):
			body.react_on_spell(self)
		# TODO: make it into center of the body 
		# issue: tileMap is a one node, so eg. tree will be 0.0
		# issue: layers don't work, for enemy it's behind it
		#position = body.position
		speed = 0
		#var tween = create_tween()
		#tween.tween_property($AnimatedSprite2D, 'scale', Vector2(1,1), 1).from(Vector2(1.5, 1.5))
		
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
