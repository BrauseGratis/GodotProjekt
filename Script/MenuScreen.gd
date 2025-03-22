extends Control

@onready var network : NetworkManager = get_node("/root/SceneManager/NetworkManager")

@onready var username_input : LineEdit = $UsernameInput
@onready var ip_input : LineEdit = $IpInput
@onready var port_input : LineEdit = $PortInput


func _on_create_lobby_button_pressed():
	network.local_username = username_input.text
	network.start_host(int(port_input.text))

func _on_join_lobby_button_pressed():
	network.local_username = username_input.text
	network.start_client(ip_input.text, int(port_input.text))
