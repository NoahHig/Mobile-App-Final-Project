extends Control

var weaponImages := [load("res://Assets/Sword.png"), load("res://Assets/Spear.png"), load("res://Assets/Axe.png"), load("res://Assets/Hammer.png")]
var weaponDescriptions := ["Sword: Your great-grandfather gave this to you. He claims it   is an ancient artifact.", "Spear: A classic weapon with   stabbing potential.", "Axe: The trees regret your        decision to use this weapon,    and wish to axe you from this place.", "Hammer: You have got to        hammer your way to the boss."]
var invisWeaponImages := [load("res://Assets/Invis_Sword.png"), load("res://Assets/Invis_Spear.png"), load("res://Assets/Invis_Axe.png"), load("res://Assets/Invis_Hammer.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weapons_num = get_parent().get_parent().get_parent().get_node("Player").get_weapons_num()
	for i in range(0, weapons_num):
		get_node("ItemList").set_item_text(i, weaponDescriptions[i])
		get_node("ItemList").set_item_icon(i, weaponImages[i])
		get_node("ItemList").set_item_disabled(i, false)
	for i in range(weapons_num, 4):
		get_node("ItemList").set_item_text(i, "You have to get a higher score to unlock this weapon")
		get_node("ItemList").set_item_icon(i, invisWeaponImages[i])
		get_node("ItemList").set_item_disabled(i, true)


func _on_button_pressed():
	hide()
	get_tree().paused=false


func _on_button_2_pressed():
	get_tree().paused=false
	get_tree().change_scene_to_file("res://game_map.tscn")


func _on_item_list_item_selected(index):
	if index ==0:
		get_parent().get_parent().get_parent().get_node("Player").equipSword()
	if index ==1:
		get_parent().get_parent().get_parent().get_node("Player").equipSpear()
	if index ==2:
		get_parent().get_parent().get_parent().get_node("Player").equipAxe()
	if index ==3:
		get_parent().get_parent().get_parent().get_node("Player").equipHammer()
