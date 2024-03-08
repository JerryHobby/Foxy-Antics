extends CharacterBody2D

class_name Player

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var sound_player = $SoundPlayer
@onready var shooter = $Shooter
@onready var animation_player_invincible = $AnimationPlayerInvincible
@onready var invincible_timer = $InvincibleTimer
@onready var hurt_timer = $HurtTimer
@onready var hit_box = $HitBox

const GRAVITY:float = 690.0
const FALLEN_OFF:float = 100
const RUN_SPEED:float = 70
const MAX_FALL_SPEED:float = 400.0
const JUMP_VELOCITY:float = -300.0
const HURT_JUMP_VELOCITY:Vector2 = Vector2(0, -130)


enum PLAYER_STATE {IDLE, RUN, JUMP, FALL, HURT}
var _state:PLAYER_STATE = PLAYER_STATE.IDLE
var _invincible:bool = false
var _reset_position:Vector2


func _ready():
	_reset_position = global_position
	SignalManager.on_checkpoint.connect(on_checkpoint)
	SignalManager.on_player_hit.emit(GameManager.get_lives_remaining())
	SignalManager.on_jump_spring.connect(on_jump_spring)

	
func _physics_process(delta):
	fallen_off()
	
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
		#velocity.x += GRAVITY * delta * velocity.x

	get_input()
	move_and_slide()
	
	calculate_state()
	var statetxt = PLAYER_STATE.find_key(_state)
	debug_label.text = \
	"Floor: %s\nPos: %d, %d\nVel:%d, %d\nState:%s" \
	% [is_on_floor(), position.x, position.y, velocity.x, velocity.y, statetxt]


func get_input() -> void:
	#if _state == PLAYER_STATE.HURT:
		#return
		
	#if _invincible:
		#return
	
	velocity.x = 0

	if Input.is_action_just_pressed("god_mode"):
		GameManager.set_god_mode(!GameManager.get_god_mode())
		
	if Input.is_action_just_pressed("debug"):
		debug_label.visible = !debug_label.visible

	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false

	if Input.is_action_pressed("jump") and is_on_floor():
		SoundManager.play_clip(sound_player, SoundManager.SOUND_JUMP)
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)


func shoot() -> void:
	if sprite_2d.flip_h == true:
		shooter.shoot(Vector2.LEFT)
	else:
		shooter.shoot(Vector2.RIGHT)


func calculate_state() -> void:
	if _state == PLAYER_STATE.HURT:
		return
	
	if is_on_floor():
		if velocity.x == 0:
			set_state(PLAYER_STATE.IDLE)
		else:
			set_state(PLAYER_STATE.RUN)
	else:
		if velocity.y > 0:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)


func set_state(new_state: PLAYER_STATE) -> void:
	if new_state == _state:
		return
	
	if _state == PLAYER_STATE.FALL:
		if new_state == PLAYER_STATE.RUN \
		or new_state == PLAYER_STATE.IDLE:
			SoundManager.play_clip(sound_player, SoundManager.SOUND_LAND)
	
	_state = new_state
	
	match _state:
		PLAYER_STATE.IDLE:
			animation_player.play("idle")
		PLAYER_STATE.RUN:
			animation_player.play("run")
		PLAYER_STATE.HURT:
			apply_hurt_jump()
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.FALL:
			animation_player.play("fall")


func go_invincible() -> void:
	_invincible = true
	animation_player_invincible.play("invincible")
	invincible_timer.start()


func fallen_off() -> void:
	if global_position.y < FALLEN_OFF:
		return
	GameManager.set_lives_remaining(1)
	reduce_lives()


func reduce_lives() -> bool:
	if GameManager.get_god_mode():
		return true

	var lives = GameManager.get_lives_remaining() - 1
	GameManager.set_lives_remaining(lives)
	SignalManager.on_player_hit.emit(lives)
	if lives > 0:
		return true
	
	SignalManager.on_game_over.emit()
	set_physics_process(false)
	return false


func apply_hurt_jump() -> void:
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()


func apply_hit() -> void:
	if _invincible == true:
		return
	
	if reduce_lives() == false: #dead
		return
		
	go_invincible()
	SoundManager.play_clip(sound_player, SoundManager.SOUND_DAMAGE)
	set_state(PLAYER_STATE.HURT)
	#global_position = _reset_position


func retake_damage() -> void:
	for area in hit_box.get_overlapping_areas():
		if area.is_in_group("Dangers"):
			apply_hit()
			break
	return


func _on_hit_box_area_entered(_area):
	apply_hit()


func _on_invincible_timer_timeout():
	animation_player_invincible.stop()
	animation_player_invincible.play("RESET")
	_invincible = false
	retake_damage()


func _on_hurt_timer_timeout():
	set_state(PLAYER_STATE.IDLE)


func on_checkpoint(_position):
	_reset_position = global_position


func on_jump_spring(jump_velocity:Vector2) -> void:
	velocity = jump_velocity
	move_and_slide()
