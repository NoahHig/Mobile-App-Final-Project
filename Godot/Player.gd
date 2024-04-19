extends CharacterBody2D
class_name Player

signal damaged(enemy)

@export var speed := 300
var direction = Vector2(0, 0)
var health := 10
var iframes := 0
var knockback := 0
var knockback_direction := Vector2(0,0)
var attack := 0
var shield := 0
var cooldown := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_direction():
	return direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if knockback == 0:
		read_input()
	else:
		velocity = knockback_direction * -200
		knockback -= 1
	if iframes > 0:
		iframes -= 1
	if health == 0:
		print("dead")
	if attack != 0:
		swing()
		get_node("Sword/Sprite2D").texture = load("res://Sword.png")
	else:
		get_node("Sword/Sprite2D").texture = null
	if shield != 0:
		shield -= 1
		get_node("Shield").texture = load("res://Shield.png")
	else:
		get_node("Shield").texture = null
	if cooldown != 0:
		cooldown -= 1
	move_and_slide()

func read_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.y < 0:
		self.rotation = atan(-direction.x / direction.y)
	elif direction.y > 0:
		self.rotation = atan(-direction.x / direction.y) + PI
	elif direction.x != 0:
		self.rotation = direction.x * PI / 2
	velocity = direction * speed
	if Input.is_action_pressed("shield") && shield == 0 && cooldown == 0:
		shield = 40
		cooldown = 40
	if Input.is_action_pressed("attack") && attack == 0 && cooldown == 0:
		attack = 20
		cooldown = 40

func swing():
	if attack == 20:
		get_node("Sword").rotate(-2.2)
	if attack <= 10:
		get_node("Sword").rotate(0.22)
		if get_node("Sword/SwordArea").get_overlapping_bodies():
			var bodies = get_node("Sword/SwordArea").get_overlapping_bodies()
			print("attack")
			print(bodies)
			for body in bodies:
				print(body.name)
				if body.get_parent() == $"../Enemies":
					body.take_damage(1)
	attack -= 1

func damage(enemy):
	if shield == 0:
		if iframes == 0:
			if enemy.get_damage() > 0:
				health -= enemy.get_damage()
				damaged.emit(enemy)
			iframes = 40
		knockback = enemy.get_knockback()
		var diff_x = enemy.position.x - self.position.x
		var diff_y = enemy.position.y - self.position.y
		var x = 0
		var y = 0
		if diff_y < 0:
			x = sin(atan(-diff_x / diff_y))
			y = -cos(atan(-diff_x / diff_y))
		elif diff_y > 0:
			x = sin(atan(-diff_x / diff_y) + PI)
			y = -cos(atan(-diff_x / diff_y) + PI)
		elif diff_x < 0:
			x = -1
		elif diff_x > 0:
			x = 1
		knockback_direction = Vector2(x, y)
