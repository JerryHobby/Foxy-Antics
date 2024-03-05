extends Node2D

const TRIGGER_CONDITION:String = "parameters/conditions/on_trigger"
const HIT_CONDITION:String = "parameters/conditions/on_hit"

@onready var animation_tree = $AnimationTree
@onready var visual = $Visual

@export var lives:int = 2
@export var points:int = ScoreManager.BOSS_POINTS

var _invincible:bool = false


func tween_hit() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(visual, "position", Vector2.ZERO, 1 )


func reduce_lives() -> void:
	lives -= 1
	if lives > 0:
		return
	
	SignalManager.on_boss_killed.emit(points)
	ObjectMaker.create_simple_scene(global_position, ObjectMaker.SCENE_KEY.EXPLOSION)
	#ObjectMaker.create_simple_scene(global_position, ObjectMaker.SCENE_KEY.PICKUP)
	set_process(false)
	queue_free()


func take_damage() -> void:
	if _invincible == true:
		return
	set_invincible(true)
	tween_hit()
	reduce_lives()


func set_invincible(value:bool) -> void:
	_invincible = value
	animation_tree[HIT_CONDITION] = value


func _on_trigger_area_entered(_area):
	if animation_tree[TRIGGER_CONDITION] == false:
		animation_tree[TRIGGER_CONDITION] = true


func _on_hit_box_area_entered(_area):
	take_damage()


