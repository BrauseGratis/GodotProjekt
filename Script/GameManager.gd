class_name GameManager
extends Node2D

@onready var network : NetworkManager = get_node("/root/SceneManager/NetworkManager")

var player_char_scene = preload("res://entities/player/player.tscn")

@onready var spawner = $MultiplayerSpawner

var players_in_game : int = 0
var current_characters : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	im_in_game.rpc(multiplayer.get_unique_id())
# when a player joins the game scene, tell the server
# when all players are in-game, spawn them in
@rpc("any_peer", "call_local", "reliable")
func im_in_game (id : int):
	if multiplayer.is_server():
		players_in_game += 1
	
		if players_in_game == len(network.current_players):
			_spawn_players()


func _spawn_players ():
	for player in network.current_players:
		_spawn_player_character(player)

func _spawn_player_character (player : Player):
	var char = player_char_scene.instantiate()
	char.name = player.name
	spawner.add_child(char, true)
	current_characters.append(char)
