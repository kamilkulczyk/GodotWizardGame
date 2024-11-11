extends Node2D

var is_ice = false
var water_color = Color(0.113, 0.382, 0.679)
var ice_color = Color(0.62, 0.781, 0.981)

func water():
	pass
func _ready() -> void:
	modulate = water_color
	
func _process(delta: float) -> void:
	change()

func react_on_spell(spell):
	if spell.spell_nr == 2:
		is_ice = true
	elif spell.spell_nr == 1:
		is_ice = false
			
func _on_area_2d_body_entered(body: Node2D) -> void:
	pass

func change():
	if is_ice == true:
		modulate = Color(1,1,1)
		modulate = ice_color
	elif is_ice == false:
		modulate = Color(1,1,1)
		modulate = water_color
