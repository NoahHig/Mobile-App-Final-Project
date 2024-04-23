extends CanvasLayer
class_name HUD

@onready var health_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Health
@onready var health_gauge = $Control/MarginContainer/VBoxContainer/HBoxContainer/HealthGauge
var health = 10:
	set(new_health):
		health = new_health
		_update_health_label()

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_health_label()

func _update_health_label():
	health_label.text = str(health)
	health_gauge.value = health

func _on_damaged(enemy) -> void:
	if enemy:
		health -= enemy.get_damage()
