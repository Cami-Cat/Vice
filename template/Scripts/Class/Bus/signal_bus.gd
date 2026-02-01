class_name SignalBus
extends Node

signal game_ready()
signal mask_changed(mask_state:GVar.MASK)
signal player_died()
signal pawn_died()
signal player_start_feed()
signal player_fed()
signal hunter_find_body(location:Vector3)
signal hunter_lose_sight(location:Vector3)
signal hunter_near_player(location:Vector3)
signal hunter_see_player(location:Vector3)
signal hunter_shot_player(location:Vector3)
signal hunger_changed(percentage:float)
