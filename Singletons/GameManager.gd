extends Node

const GROUP_PLAYER:String = "player"

var music:bool = false 
var sounds:bool = true


const TOTAL_LEVELS = 4
const TOTAL_LIVES = 5
var _current_level = 0 # main

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
	get_tree().change_scene_to_packed(MAIN_SCENE)


func load_next_level_scene():
	set_next_level()
	get_tree().change_scene_to_packed(_level_scenes[_current_level])


func set_next_level():
	_current_level += 1
	if _current_level > TOTAL_LEVELS:
		SignalManager.on_game_over.emit()

