extends StaticBody2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape = $CollisionShape
@onready var animation_player = $AnimationPlayer
@onready var player_detector = $player_detector
@onready var player_detector_2 = $player_detector_2

var is_open = false  # 记录门是否打开
var players_near_door = 0  # 记录有多少玩家在感应区域内
var cooldown = false  # 防止频繁触发

func _ready():
	pass

func _process(delta):
	
	# 只在服务器端运行
	if not multiplayer.is_server():
		return
	
	# 如果正在冷却，不处理逻辑
	if cooldown:
		return

	# 如果有玩家在感应区域内且门关闭，则开门
	if players_near_door > 0 and not is_open:
		open_door()
	# 如果没有玩家在感应区域内且门打开，则关门
	elif players_near_door == 0 and is_open:
		close_door()

@rpc("any_peer", "call_local", "reliable")
func sync_door_anim(anim_name: String):
	animation_player.play(anim_name)



func open_door():
	if not is_open:
		is_open = true
		cooldown = true  # 进入冷却
		sync_door_anim.rpc("door open")
		await animation_player.animation_finished
		sync_door_anim.rpc("door opened")
		cooldown = false  # 冷却结束
func close_door():
	if is_open:
		is_open = false
		cooldown = true  # 进入冷却
		sync_door_anim.rpc("door close")
		await animation_player.animation_finished
		sync_door_anim.rpc("door default")
		cooldown = false  # 冷却结束


func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		players_near_door += 1  # 玩家进入感应区域


func _on_player_detector_body_exited(body):
	if body.is_in_group("player"):
		players_near_door -= 1  # 玩家离开感应区域


func _on_player_detector_2_body_entered(body):
	if body.is_in_group("player"):
		players_near_door += 1  # 玩家进入感应区域



func _on_player_detector_2_body_exited(body):
	if body.is_in_group("player"):
		players_near_door -= 1  # 玩家离开感应区域
