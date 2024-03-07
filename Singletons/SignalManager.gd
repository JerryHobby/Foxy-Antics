extends Node

signal on_enemy_hit(points:int, enemy_position:Vector2)
signal on_pickup_hit(points:int)
signal on_boss_killed(points:int)
signal on_checkpoint(position:Vector2)
signal on_player_hit(lives:int)
signal on_level_complete
signal on_game_over
signal on_score_updated
signal on_god_mode(mode:bool)
signal on_jump_spring(jump_velocity:Vector2)

