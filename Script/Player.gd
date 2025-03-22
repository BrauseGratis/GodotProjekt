class_name Player
extends Node

@onready var network : NetworkManager = get_node("/root/SceneManager/NetworkManager")

@export var username : String
@export var player_id : int

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	#set_multiplayer_authority(multiplayer.get_unique_id())


func _ready():
	username = network.local_username
	player_id = name.to_int()
	network.add_player_to_list(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		network.remove_player_from_list(self)
