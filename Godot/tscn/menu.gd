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


func _on_item_list_item_selected(index):
	if index ==0:
		get_parent().get_parent().get_parent().get_node("Player").equipSword()
	if index ==1:
		get_parent().get_parent().get_parent().get_node("Player").equipSpear()
	if index ==2:
		get_parent().get_parent().get_parent().get_node("Player").equipAxe()
	if index ==3:
		get_parent().get_parent().get_parent().get_node("Player").equipHammer()
	pass # Replace with function body.
