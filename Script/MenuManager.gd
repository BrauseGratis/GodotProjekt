extends Control

@onready var network : NetworkManager = get_node("/root/SceneManager/NetworkManager")
@onready var main_screen = $CanvasLayer/BG/MainMenu
@onready var lobby_screen = $CanvasLayer/BG/Lobby

func _ready():
	network.OnConnectedToServer.connect(_open_lobby)
	network.OnServerDisconnected.connect(_open_main_menu)

func _open_main_menu ():
	main_screen.visible = true
	lobby_screen.visible = false

func _open_lobby ():
	main_screen.visible = false
	lobby_screen.visible = true
