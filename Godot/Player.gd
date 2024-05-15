extends CharacterBody2D
class_name Player

signal damaged(enemy)
signal scored(num)

@onready var joystick = get_parent().get_node("HUD").get_node("Joystick")
@export var speed := 225
var direction = Vector2(0, 0)
var health := 10
var iframes := 0
var knockback := 0
var knockback_direction := Vector2(0,0)
var attackWait = false
var attack := 0.0
var shieldWait = false
var shield := 0
var cooldown := 0
var weaponList := ["sword"]
var weaponIndex := 0
var score := 0
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
	if health <= 0:
		print("dead")
		get_parent().get_node("HUD")._on_button_pressed()
	if attack > 0:
		if weaponList[weaponIndex] == "sword":
			swing_sword()
			get_node("Sword/Sprite2D").texture = load("res://Assets/Sword.png")
		elif weaponList[weaponIndex] == "spear":
			stab()
			get_node("Spear/Sprite2D").texture = load("res://Assets/Spear.png")
		elif weaponList[weaponIndex] == "hammer":
			swing_hammer()
			get_node("Hammer/Sprite2D").texture = load("res://Assets/Hammer.png")
		elif weaponList[weaponIndex] == "axe":
			swing_axe()
			get_node("Axe/Sprite2D").texture = load("res://Assets/Axe.png")
	else:
		get_node("Sword/Sprite2D").texture = null
		get_node("Spear/Sprite2D").texture = null
		get_node("Hammer/Sprite2D").texture = null
		get_node("Axe/Sprite2D").texture = null
	if shield > 0:
		shield -= 1
		get_node("Shield").texture = load("res://Assets/Shield.png")
	else:
		get_node("Shield").texture = null
	if cooldown > 0:
		cooldown -= 1
	move_and_slide()

func input_attack():
	attackWait = true
	
func input_shield():
	shieldWait = true

func read_input():
	direction = get_parent().get_node("HUD").get_node("Joystick").get_posVector()
	if direction == Vector2(0, 0):
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
	elif self.rotation < PI/2 && self.rotation > -PI/2:
		playersprite.animation = "BackwardsIdle"
	else:
		playersprite.animation = "Idle"
	velocity = direction * speed
	if (Input.is_action_pressed("shield") || shieldWait) && shield <= 0 && cooldown <= 0:
		shield = 40
		shieldWait = false
		cooldown = 40
	if (Input.is_action_pressed("attack") || attackWait) && attack <= 0 && cooldown <= 0:
		attack = 20
		attackWait = false
		cooldown = 40
	if Input.is_action_just_pressed("swap") && attack <= 0:
		if weaponIndex < weaponList.size() - 1:
			weaponIndex += 1
		else:
			weaponIndex = 0

func equipSword():
	weaponIndex = 0

func equipSpear():
	weaponIndex = min(1, weaponList.size() - 1)
	
func equipAxe():
	weaponIndex = min(2, weaponList.size() - 1)

func equipHammer():
	weaponIndex = min(3, weaponList.size() - 1)

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
		get_node("Hammer").rotate(0.055)
		if get_node("Hammer/HammerArea").get_overlapping_bodies():
			var bodies = get_node("Hammer/HammerArea").get_overlapping_bodies()
			for body in bodies:
				if body.get_parent() == $"../Enemies":
					body.take_damage(2)
				if body.name == "LevelMap":
					var collision = get_node("Hammer").move_and_collide(Vector2(0,0))
					if collision && collision.get_collider() is TileMap:
						# Find the character's position in tile coordinates
						var tile_pos : Vector2 = collision.get_collider().local_to_map(position)
						# Find the colliding tile position
						tile_pos -= collision.get_normal()
						# Get the tile id
						if collision.get_collider().get_cell_atlas_coords(0, tile_pos) == Vector2i(4, 0):
							collision.get_collider().set_cell(0, tile_pos, 0, Vector2i(5, 0), 0)
						if collision.get_collider().get_cell_atlas_coords(0, tile_pos) == Vector2i(6, 2):
							collision.get_collider().set_cell(0, tile_pos, 0, Vector2i(4, 2), 0)
						get_node("Hammer").position.x = 0
						get_node("Hammer").position.y = 0
	attack -= 0.25

func swing_axe():
	if attack == 20:
		get_node("Axe").rotation = -1.5
	if attack <= 10:
		get_node("Axe").rotate(0.11)
		if get_node("Axe/AxeArea").get_overlapping_bodies():
			var bodies = get_node("Axe/AxeArea").get_overlapping_bodies()
			for body in bodies:
				if body.get_parent() == $"../Enemies":
					body.take_damage(1)
				if body.name == "LevelMap":
					var collision = get_node("Axe").move_and_collide(Vector2(0,0))
					if collision && collision.get_collider() is TileMap:
						# Find the character's position in tile coordinates
						var tile_pos : Vector2 = collision.get_collider().local_to_map(position)
						# Find the colliding tile position
						tile_pos -= collision.get_normal()
						# Get the tile id
						if collision.get_collider().get_cell_atlas_coords(0, tile_pos) == Vector2i(0, 0):
							collision.get_collider().set_cell(0, tile_pos, 0, Vector2i(7, 0), 0)
						get_node("Axe").position.x = 0
						get_node("Axe").position.y = 0
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

func add_score(num):
	score += num
	scored.emit(num)
	if weaponList.size() == 1 && score >= 5:
		weaponList.append("spear")
	elif weaponList.size() == 2 && score >= 10:
		weaponList.append("axe")
	if weaponList.size() == 3 && score >= 15:
		weaponList.append("hammer")

func get_weapons_num():
	return weaponList.size()
