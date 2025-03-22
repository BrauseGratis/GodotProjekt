extends MultiplayerSynchronizer

@export var move_input : Vector2
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)


func _physics_process(delta):
	if is_multiplayer_authority():
		move_input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
