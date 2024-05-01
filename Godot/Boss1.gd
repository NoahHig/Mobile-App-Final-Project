extends StaticBody2D

var move := 0
var direction := 1
var attack := 0
var swing_direction := 1
var health := 10
var iframes := 0
var stun := 0
var power := [1, 60]
var speed := 3

func _ready():
	set_process(true)

func _process(delta):
	if iframes == 0:
		position.x += direction * speed
		move += direction
		if move == 100:
			direction = -1
		elif move == -100:
			direction = 1
		get_node("Sword").rotate(swing_direction * 0.04)
		attack += swing_direction
		if attack == 40:
			swing_direction = -1
		elif attack == -40:
			swing_direction = 1
		if Vector2(get_node("../../Player").position.x - position.x, get_node("../../Player").position.y - position.y).length() < 200 && randi_range(0,100) == 0:
			new_enemy()
	else:
		iframes -= 1
	if health == 0:
		queue_free()

func _physics_process(delta):
	pass

func get_damage():
	if iframes == 0:
		return power[0]
	else:
		return 0
	
func get_knockback():
	return power[1]

func swing():
	if attack == 10:
		get_node("Sword").rotate(-2.8)
	get_node("Sword").rotate(0.28)
	attack -= 1

func take_damage(damage):
	if iframes == 0:
		health -= damage
		iframes = 40
		get_node("../../Player").damage(self)

func new_enemy():
	var enemy = load("res://Enemy.tscn").instantiate()
	enemy.set_process(true)
	enemy.position.x = position.x
	enemy.position.y = position.y
	enemy.set_health(1)
	get_node("../../Enemies").add_child(enemy)

func _on_sword_area_body_entered(body):
	if attack > 0:
		if body.name == "Player":
			body.damage(self)
