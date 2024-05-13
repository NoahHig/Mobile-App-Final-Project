extends CanvasLayer
class_name HUD

@onready var health_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Health
@onready var health_gauge = $Control/MarginContainer/VBoxContainer/HBoxContainer/HealthGauge
@onready var score_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Score
@onready var menu = $CenterContainer/Menu

var health = 10:
	set(new_health):
		health = new_health
		_update_health_label()
var score = 0:
	set(new_score):
		score = new_score
		_update_score_label()

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_health_label()
	_update_score_label()

func _update_health_label():
	health_label.text = str(health)
	health_gauge.value = health
	
func _update_score_label():
	score_label.text = "Score:" + str(score)

func _on_damaged(enemy) -> void:
	if enemy:
		health -= enemy.get_damage()

func _on_scored(num) -> void:
	if num:
		score += num

func _on_button_pressed():
	get_tree().paused=true
	menu.show()


func _on_attack_pressed():
	var player = get_parent().get_node("Player")
	player.input_attack()


func _on_sheild_pressed():
	var player = get_parent().get_node("Player")
	player.input_shield()
	
