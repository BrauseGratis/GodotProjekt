class_name PlayerSlot
extends Panel


@onready var name_text : Label = $PlayerName
@onready var kick_button : Button = $KickButton
var current_player : Player

func update_slot_ui (player : Player):
	current_player = player
	name_text.text = player.username
  
	var is_local = player.is_multiplayer_authority()

	if multiplayer.is_server():
		kick_button.visible = not is_local
	else:
		kick_button.visible = false



func _on_kick_button_pressed():
	if not multiplayer.is_server():
		return

	get_node("/root/SceneManager/NetworkManager").disconnect_player.rpc(current_player.player_id)
