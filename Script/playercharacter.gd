extends CharacterBody2D

# 新增代码
enum State {STEALTH, MOVING, ATTACKING}
var current_state = State.STEALTH
var tween: Tween



@export var transition_duration = 0.3       # 状态过渡时间
@export var player_camera : PackedScene = preload("res://entities/player/player_camera.tscn")


@onready var bullet_scene =  preload("res://entities/bullet.tscn")


@export var speed : int
var input_movement = Vector2()

@onready var gun = $gun_handler
@onready var gun_spr = $gun_handler/Gun_Sprite
@onready var bullet_point = $gun_handler/bullet_point
@onready var sprite = $Sprite2D

@onready var input = $InputSync


var camera_instance
var pos
var rot
var attack_timer: Timer

func _enter_tree ():

	$InputSync.set_multiplayer_authority(name.to_int())
#	$InputSync.set_multiplayer_authority(get_parent().get_multiplayer_authority())
	set_multiplayer_authority(name.to_int())


func _ready():
	set_up_camera()
	# 初始化透明度
	#sprite.modulate.a = 0.0
	#tween = create_tween()

	# 初始化攻击计时器
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.5
	attack_timer.one_shot = true
	#attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	# 确保只有当前客户端的玩家启用 Camera2D



func _process(delta):

	update_camera_pos()
	movement(delta)
	#if !attack_timer.is_stopped():  # 攻击期间保持显形
		#return
	#update_state()

# only the server will run the movement code
func _physics_process (delta):
	if is_multiplayer_authority():
		movement(delta)

func movement(delta):
	target_mouse()
	animations()
	input_movement = input.move_input

	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_shoot"):
		start_attack()
		

func start_attack():
	# 立即显形（无过渡）
	#sprite.modulate.a = 1.0
	#tween.kill()
	
	# 重置计时器（连续射击不会重复触发）
	if attack_timer.is_stopped():
		attack_timer.start()
	else:
		attack_timer.start(attack_timer.wait_time)   
	instance_bullet()

#func _on_attack_timer_timeout():
	# 恢复原有状态（带过渡）
	#handle_state_change(get_current_base_state())

#func get_current_base_state():
	#return State.MOVING if velocity != Vector2.ZERO else State.STEALTH

#func update_state():

	
	
	#var new_state = get_current_base_state()
	#if new_state != current_state:
		#handle_state_change(new_state)
#func handle_state_change(new_state: State):
	#current_state = new_state
	#var target_alpha: float
	
	#match new_state:
		#State.STEALTH:
			#target_alpha = 0.0
		#State.MOVING:
			#target_alpha = 0.3
		#State.ATTACKING:
			#target_alpha = 1.0
	
	# 使用Tween平滑过渡
	#tween.kill()
	#tween = create_tween().set_trans(Tween.TRANS_SINE)
	#tween.tween_property(sprite, "modulate:a", target_alpha, transition_duration)
	
	# 如果是攻击状态，设置恢复定时器
	#if new_state == State.ATTACKING:
		#var original_state = State.MOVING if velocity != Vector2.ZERO else State.STEALTH
		#await get_tree().create_timer(0.5).timeout
		#handle_state_change(original_state)

func animations():
	if input_movement != Vector2.ZERO:
		if input_movement.x > 0:
			$AnimationPlayer.play("Move")
		if input_movement.x < 0:
			$AnimationPlayer.play("Move")
		if input_movement.y > 0:
			$AnimationPlayer.play("Move")
		if input_movement.y < 0:
			$AnimationPlayer.play("Move")
	if input_movement == Vector2.ZERO:
		$AnimationPlayer.play("Idle")

func target_mouse():
	var mouse_movement = get_global_mouse_position()
	pos = global_position
	gun.look_at(mouse_movement)
	rot = rad_to_deg((mouse_movement - pos).angle())
	
	if rot >= -90 and rot <= 90:
		gun_spr.flip_v = false
		$Sprite2D.flip_h = false
	else:
		gun_spr.flip_v = true
		$Sprite2D.flip_h = true

func instance_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.direction = bullet_point.global_position - gun.global_position
	bullet.global_position = bullet_point.global_position
	get_tree().root.add_child(bullet)


func set_up_camera():
	if is_multiplayer_authority():
		camera_instance = player_camera.instantiate()
		add_child(camera_instance)  # 将 Camera2D 作为玩家子节点
		camera_instance.make_current()  # 激活当前镜头

func update_camera_pos():
	if is_multiplayer_authority():
		# 更新镜头位置（如果需要动态跟随）
		if camera_instance:
			camera_instance.global_position = global_position
