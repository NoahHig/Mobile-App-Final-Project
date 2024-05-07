extends CharacterBody2D
class_name Player

signal damaged(enemy)

@export var speed := 300
var direction = Vector2(0, 0)
var health := 10
var iframes := 0
var knockback := 0
var knockback_direction := Vector2(0,0)
var attack := 0.0
var shield := 0
var cooldown := 0
var weapon := "hammer"
@onready var playersprite = get_node("PlayerSprite")
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
		velocity = knockback_direction * -400
		knockback -= 2
	if iframes > 0:
		iframes -= 1
	if health == 0:
		print("dead")
	if attack != 0:
		if weapon == "sword":
			swing_sword()
			get_node("Sword/Sprite2D").texture = load("res://Assets/Sword.png")
		elif weapon == "spear":
			stab()
			get_node("Spear/Sprite2D").texture = load("res://Assets/Spear.png")
		elif weapon == "hammer":
			swing_hammer()
			get_node("Hammer/Sprite2D").texture = load("res://Assets/Hammer.png")
	else:
		get_node("Sword/Sprite2D").texture = null
		get_node("Spear/Sprite2D").texture = null
		get_node("Hammer/Sprite2D").texture = null
	if shield != 0:
		shield -= 1
		get_node("Shield").texture = load("res://Assets/Shield.png")
	else:
		get_node("Shield").texture = null
	if cooldown != 0:
		cooldown -= 1
	move_and_slide()

func read_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.y < 0:
		self.rotation = atan(-direction.x / direction.y)
		playersprite.animation = "BackwardsWalking"
	elif direction.y > 0:
		self.rotation = atan(-direction.x / direction.y) + PI
		playersprite.animation = "ForwardsWalking"
	elif direction.x != 0:
		self.rotation = direction.x * PI / 2
		playersprite.animation = "ForwardsWalking"
	elif self.rotation < PI/4 && self.rotation > -PI/4:
		playersprite.animation = "BackwardsIdle"
	else:
		playersprite.animation = "Idle"
	velocity = direction * speed
	if Input.is_action_pressed("shield") && shield == 0 && cooldown == 0:
		shield = 40
		cooldown = 40
	if Input.is_action_pressed("attack") && attack == 0 && cooldown == 0:
		attack = 20
		cooldown = 40
	if Input.is_action_just_pressed("swap") && attack == 0:
		if weapon == "sword":
			weapon = "spear"
		elif weapon == "spear":
			weapon = "hammer"
		elif weapon == "hammer":
			weapon = "sword"

func swing_sword():
	if attack == 20:
		get_node("Sword").rotation = -1.5
	if attack <= 10:
		get_node("Sword").rotate(0.22)
		if get_node("Sword/SwordArea").get_overlapping_bodies():
			var bodies = get_node("Sword/SwordArea").get_overlapping_bodies()
			for body in bodies:
				if body.get_parent() == $"../Enemies":
					body.take_damage(1)
	attack -= 1

func swing_hammer():
	if attack == 20:
		get_node("Hammer").rotation = -1.5
	if attack <= 10:
		get_node("Hammer").rotate(0.11)
		if get_node("Hammer/HammerArea").get_overlapping_bodies():
			var bodies = get_node("Hammer/HammerArea").get_overlapping_bodies()
			for body in bodies:
				print(body)
				print(body.name)
				if body.get_parent() == $"../Enemies":
					body.take_damage(2)
	attack -= 0.5

func stab():
	if attack == 20:
		get_node("Spear").position.y = -10
	if attack <= 10:
		get_node("Spear").position.y -= 4.4
		if get_node("Spear/SpearArea").get_overlapping_bodies():
			var bodies = get_node("Spear/SpearArea").get_overlapping_bodies()
			for body in bodies:
				if body.get_parent() == $"../Enemies":
					body.take_damage(1)
	attack -= 2

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
	else:
		enemy.take_damage(0)
