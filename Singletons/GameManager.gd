extends Node

const GROUP_PLAYER:String = "player"

var music:bool = false 
var sounds:bool = true
var _god_mode:bool = false

const TOTAL_LEVELS = 4
const TOTAL_LIVES = 5

# accelerates game based on level number
# up until max acceleration
const LEVEL_ACCELERATOR = 0.15
const MAX_LEVEL_ACCELERATOR = 0.50

var _current_level = 0 # main
var _current_lives = TOTAL_LIVES

const MAIN_SCENE:PackedScene = preload("res://Scenes/Main/main.tscn")
var _level_scenes = {}


func _ready():
	load_level_scenes()


func get_current_level() -> int:
	return _current_level


func load_level_scenes():
	for level in range(1, TOTAL_LEVELS + 1):
		_level_scenes[level] = load(
			"res://Scenes/Levels/level_%s.tscn" % level)


func load_main_scene():
	_current_level = 0
	_current_lives = TOTAL_LIVES
	get_tree().change_scene_to_packed(MAIN_SCENE)


func load_next_level_scene():
	set_next_level()
	get_tree().change_scene_to_packed(_level_scenes[_current_level])


func set_next_level():
	_current_level += 1
	if _current_level > TOTAL_LEVELS:
		_current_level = 1
		SignalManager.on_game_over.emit()


func get_lives_remaining() -> int:
	return _current_lives


func set_lives_remaining(lives) -> void:
	_current_lives = lives


func set_god_mode(mode:bool):
	print("God Mode = %s" % mode)
	SignalManager.on_god_mode.emit(mode)
	_god_mode = mode


func get_god_mode() -> bool:
	return _god_mode
