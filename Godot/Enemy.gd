extends CharacterBody2D

var direction = Vector2(0, 0)
var health := 3
var iframes := 0
var knockback := 0
var fight_timer := 0
var attack := 0
var power := [1, 20]
var score := 1
var state := "wait"
var speed := 175

func _ready():
	get_node("Sword/Sprite2D").texture = null
	set_process(true)

func _process(delta):
	if knockback == 0:
		if(state == "pursue"):
			move()
		else:
			velocity = Vector2(0,0)
			if(state != "wait"):
				fight()
	else:
		velocity = direction * -200
		knockback -= 1
	if iframes > 0:
		iframes -= 1
	if health <= 0:
		var player = $"../../Player"
		player.add_score(score)
		queue_free()
	if attack != 0:
		swing()
		get_node("Sword/Sprite2D").texture = load("res://Assets/DarkSword.png")
	else:
		get_node("Sword/Sprite2D").texture = null
	move_and_slide()

func _physics_process(delta):
	pass

func get_damage():
	return power[0]
	
func get_knockback():
	return power[1]

func move():
	var player = $"../../Player"
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

func fight():
	if fight_timer == 0 && attack == 0:
		attack = 15
		if state == "fight":
			fight_timer = randi_range(30,50)
		elif state == "to_pursue":
			state = "pursue"
		elif state == "to_wait":
			state = "wait"
	fight_timer -= 1

func swing():
	if attack == 15:
		get_node("Sword").rotation = 4.5
	if attack <=12:
		get_node("Sword").rotate(0.16)
	attack -= 1

func take_damage(damage):
	if iframes == 0:
		health -= damage
		iframes = 40
	knockback = 20

func set_health(num):
	health = num
	score = 0

func _on_sword_area_body_entered(body):
	if attack > 0:
		if body.name == "Player":
			body.damage(self)

func _on_detection_area_body_entered(body):
	if state == "wait":
		if body.name == "Player":
			state = "pursue"

func _on_detection_area_body_exited(body):
	if state == "pursue":
		if body.name == "Player":
			state = "wait"
	elif state == "to_pursue":
		state == "to_wait"

func _on_attack_area_body_entered(body):
	if body.name == "Player":
		state = "fight"
	fight_timer = randi_range(8,18)

func _on_attack_area_body_exited(body):
	if body.name == "Player":
		state = "to_pursue"
