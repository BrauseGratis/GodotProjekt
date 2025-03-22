class_name SceneManager
extends Node2D

var menu_scene : PackedScene = preload("res://scene/menu.tscn")
var game_scene : PackedScene = preload("res://scene/main_level.tscn")

var menu
var game




func _ready():
	menu = menu_scene.instantiate()
	game = game_scene.instantiate()
	add_child(menu)

@rpc("authority", "call_local", "reliable")
func load_menu_scene ():
	remove_child(game)
	add_child(menu)

@rpc("authority", "call_local", "reliable")
func load_game_scene ():
	remove_child(menu)
	add_child(game)
