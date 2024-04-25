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
	generate_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_map():
	for x in range(width):
		for y in range(height):
			var stone = stoniness.get_noise_2d(x, y) * 10
			var water = moisture.get_noise_2d(x, y) * 10
			var tree = forestry.get_noise_2d(x, y) * 10
			var index = 1
			if stone > 3:
				if stone < 5:
					index = 4
				else:
					index = 2
			elif water > 3:
				index = 3
			elif tree > 3:
				index = 0
			set_cell(0, Vector2i(x, y), 0, Vector2i(index, 0), 0)
