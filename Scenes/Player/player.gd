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


const GRAVITY:float = 1000.0
const RUN_SPEED:float = 120.0
const MAX_FALL_SPEED:float = 400.0
const JUMP_VELOCITY:float = -400.0
const HURT_JUMP_VELOCITY:Vector2 = Vector2(0, -150)


enum PLAYER_STATE {IDLE, RUN, JUMP, FALL, HURT}
var _state:PLAYER_STATE = PLAYER_STATE.IDLE
var _invincible:bool = false


func _ready():
	pass


func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta

	get_input()
	move_and_slide()
	calculate_state()
	var statetxt = PLAYER_STATE.find_key(_state)
	debug_label.text = \
	"Floor: %s\nPos: %d, %d\nVel:%d, %d\nState:%s" \
	% [is_on_floor(), position.x, position.y, velocity.x, velocity.y, statetxt]


func get_input() -> void:
	if _state == PLAYER_STATE.HURT:
		return
	
	velocity.x = 0
	
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
			animation_player.play("hurt")
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.FALL:
			animation_player.play("fall")


func go_invincible() -> void:
	_invincible = true
	animation_player_invincible.play("invincible")
	invincible_timer.start()


func apply_hurt_jump() -> void:
	set_state(PLAYER_STATE.HURT)
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()


func apply_hit() -> void:
	if _invincible == true:
		return
		
	go_invincible()
	apply_hurt_jump()
	SoundManager.play_clip(sound_player, SoundManager.SOUND_DAMAGE)
	set_state(PLAYER_STATE.HURT)


func _on_hit_box_area_entered(area):
	apply_hit()


func _on_invincible_timer_timeout():
	animation_player_invincible.stop()
	animation_player_invincible.play("RESET")
	_invincible = false


func _on_hurt_timer_timeout():
		set_state(PLAYER_STATE.IDLE)

