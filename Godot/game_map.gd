extends Node2D

@export var difficulty := 3

# Called when the node enters the scene tree for the first time.
func _ready():
	var num = difficulty * 3
	create_enemies(num)

func create_enemies(num):
	var enemy : PackedScene = load("res://Enemy.tscn")
	for x in num:
		var new_enemy = enemy.instantiate()
		new_enemy.set_process(true)
		new_enemy.position.x = randi_range(-200, 200)
		new_enemy.position.y = randi_range(-200, 200)
		$Enemies.add_child(new_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
