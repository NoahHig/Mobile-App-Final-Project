extends CharacterBody2D

@export var speed := 300
var direction = Vector2(0, 0)
var health := 3
var iframes := 0
var knockback := 0
var attack := 0

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
		velocity = direction * -200
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
	if Input.is_action_pressed("attack") && attack == 0:
		attack = 10

func swing():
	if attack == 10:
		get_node("Sword").rotate(-2.2)
	get_node("Sword").rotate(0.22)
	if get_node("Sword/SwordArea").get_overlapping_bodies():
		var bodies = get_node("Sword/SwordArea").get_overlapping_bodies()
		for body in bodies:
			if body.name.contains("Enemy"):
				body.queue_free()
	attack -= 1

#func enemy_damage():
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i).get_collider()
#		if collision.name == "Enemy":
#			print("damage taken")
#			if iframes == 0:
#				health -= collision.get_damage()
#				iframes = 40
#			knockback = 10
#	var allAreas = body.get_overlapping_areas()
#	for area in allAreas:
#		if area.is_instance_of(Enemy):
#			print("damage taken")
#			if iframes == 0:
#				health -= 1
#				iframes = 40
#			knockback = 10

func damage(damage):
	if iframes == 0:
		health -= damage
		iframes = 40
	knockback = 10
