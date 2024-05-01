extends TileMap

var height := 40
var width := 40
var stoniness = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var forestry = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	stoniness.seed = randi()
	moisture.seed = randi()
	forestry.seed = randi()
	stoniness.set_frequency(0.05)
	moisture.set_frequency(0.05)
	forestry.set_frequency(0.05)
	print("generating")
	generate_map()
	print("generated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_map():
	boss_chamber(randi_range(0, width - 21), randi_range(0, height - 13))
	for x in range(width):
		for y in range(height):
			if get_cell_source_id(0,Vector2i(x, y), false) == -1:
				var stone = stoniness.get_noise_2d(x, y) * 10
				var water = moisture.get_noise_2d(x, y) * 10
				var tree = forestry.get_noise_2d(x, y) * 10
				print(stone)
				var index = 1
				if stone > 4:
					if stone < 4.5:
						index = 5
					elif stone < 4.75:
						index = 4
					else:
						index = 2
				elif water > 4:
					index = 3
				elif tree > 3:
					index = 0
				set_cell(0, Vector2i(x, y), 0, Vector2i(index, 0), 0)

func boss_chamber(x, y):
	#top row
	set_cell(0, Vector2i(x, y), 0, Vector2i(7, 1), 0)
	for i in range(19):
		set_cell(0, Vector2i(x + 1 + i, y), 0, Vector2i(0, 1), 0)
	set_cell(0, Vector2i(x + 20, y), 0, Vector2i(4, 1), 0)
	set_cell(0, Vector2i(x + 1, y + 1), 0, Vector2i(1, 2), 0)
	for i in range(17):
		set_cell(0, Vector2i(x + 2 + i, y + 1), 0, Vector2i(2, 1), 0)
	set_cell(0, Vector2i(x + 19, y + 1), 0, Vector2i(2, 2), 0)
	#left col
	for i in range(11):
		set_cell(0, Vector2i(x, y + 1 + i), 0, Vector2i(3, 1), 0)
	for i in range(9):
		set_cell(0, Vector2i(x + 1, y + 2 + i), 0, Vector2i(1, 1), 0)
	#right col
	for i in range(11):
		set_cell(0, Vector2i(x + 20, y + 1 + i), 0, Vector2i(1, 1), 0)
	for i in range(9):
		set_cell(0, Vector2i(x + 19, y + 2 + i), 0, Vector2i(3, 1), 0)
	#bottom row
	set_cell(0, Vector2i(x, y + 12), 0, Vector2i(6, 1), 0)
	for i in range(19):
		set_cell(0, Vector2i(x + 1 + i, y + 12), 0, Vector2i(2, 1), 0)
	set_cell(0, Vector2i(x + 20, y + 12), 0, Vector2i(5, 1), 0)
	set_cell(0, Vector2i(x + 1, y + 11), 0, Vector2i(0, 2), 0)
	for i in range(17):
		set_cell(0, Vector2i(x + 2 + i, y + 11), 0, Vector2i(0, 1), 0)
	set_cell(0, Vector2i(x + 19, y + 11), 0, Vector2i(3, 2), 0)
	#floor
	for i in range(17):
		for j in range(9):
			set_cell(0, Vector2i(x + 2 + i, y + 2 + j), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 10, y), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 10, y + 1), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 10, y + 12), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 10, y + 11), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x, y + 6), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 1, y + 6), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 20, y + 6), 0, Vector2i(4, 2), 0)
	set_cell(0, Vector2i(x + 19, y + 6), 0, Vector2i(4, 2), 0)
