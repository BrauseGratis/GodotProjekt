extends Control

@onready var scene_manager : SceneManager = get_node("/root/SceneManager")
@onready var network : NetworkManager = get_node("/root/SceneManager/NetworkManager")

var player_slots : Array[PlayerSlot] = []
@onready var player_slot_parent = $PlayerslotList

@onready var start_button = $StartGameButton


func _ready():
	for slot in player_slot_parent.get_children():
		player_slots.append(slot)

func update_ui ():
	if not visible:
		return
  
	start_button.visible = multiplayer.is_server()

	var player_count = len(network.current_players)

	for i in len(player_slots):
		var slot = player_slots[i]
	
		if i < player_count:
			slot.visible = true
			slot.update_slot_ui(network.current_players[i])
		else:
			slot.visible = false





func _on_start_game_button_pressed():
	scene_manager.load_game_scene.rpc()


func _on_leave_lobby_button_pressed():
	if multiplayer.is_server():
		$"../../.."._open_main_menu()

	multiplayer.multiplayer_peer.close()
