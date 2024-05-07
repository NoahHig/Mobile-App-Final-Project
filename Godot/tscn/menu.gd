extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	hide()
	get_tree().paused=false


func _on_button_2_pressed():
	pass # Replace with function body.
