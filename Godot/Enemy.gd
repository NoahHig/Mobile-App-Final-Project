extends CharacterBody2D

var direction = Vector2(0, 0)
var health := 3
var iframes := 0
var knockback := 0
var attack := 0
var power := 1
var pursue := false
var speed := 200

func _ready():
	get_node("Sword/Sprite2D").texture = null
	set_process(true)

func _process(delta):
	if knockback == 0:
		if(pursue):
			move()
		else:
			velocity = Vector2(0,0)
	else:
		velocity = direction * -200
		knockback -= 1
	if iframes > 0:
		iframes -= 1
	if health == 0:
		queue_free()
	if attack != 0:
		swing()
		get_node("Sword/Sprite2D").texture = load("res://Sword.png")
	else:
		get_node("Sword/Sprite2D").texture = null
	move_and_slide()

func _physics_process(delta):
	pass

func get_damage():
	return power

func move():
	var player = get_node("../Player")
	var diff_x = player.position.x - self.position.x
	var diff_y = player.position.y - self.position.y
	var x = 0
	var y = 0
	if diff_y < 0:
		x = sin(atan(-diff_x / diff_y))
		y = -cos(atan(-diff_x / diff_y))
		self.rotation = atan(-x / y)
	elif diff_y > 0:
		x = sin(atan(-diff_x / diff_y) + PI)
		y = -cos(atan(-diff_x / diff_y) + PI)
		self.rotation = atan(-x / y) + PI
	elif diff_x < 0:
		x = -1
		self.rotation = -PI / 2
	elif diff_x > 0:
		x = 1
		self.rotation = -PI / 2
	direction = Vector2(x, y)
	velocity = direction * speed

func swing():
	if attack == 10:
		get_node("Sword").rotate(-2.2)
	get_node("Sword").rotate(0.22)
	attack -= 1

func _on_area_2d_body_entered(body):
	var player = get_node("../../Player")
	if player.attack != 0:
		health -= 1
		iframes = 40
		knockback = 10
		direction = player.get_direction()

func attack_player(body):
	pass

func take_damage(damage):
	if iframes == 0:
		health -= damage
		iframes = 40
	knockback = 10


func _on_sword_area_body_entered(body):
	if attack > 0:
		var player = get_node("../Player")
		if body == player:
			player.damage(power)

func _on_detection_area_body_entered(body):
	if not(pursue):
		var player = get_node("../Player")
		if body == player:
			pursue = true

func _on_detection_area_body_exited(body):
	if pursue:
		var player = get_node("../Player")
		if body == player:
			pursue = false
