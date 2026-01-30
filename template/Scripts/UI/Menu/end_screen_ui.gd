extends Control

#var waves_survived:int
#var score:int
#var player_name:String
#
#@onready var thanks: Label = $Thanks
#@onready var line_edit: LineEdit = $LineEdit
#@onready var confirm: Button = $Confirm
#@onready var leader_board: Label = $LeaderBoard
#@onready var v_box_container: VBoxContainer = $VBoxContainer
#
#@onready var first: Label = $VBoxContainer/First
#@onready var second: Label = $VBoxContainer/Second
#@onready var third: Label = $VBoxContainer/Third
#@onready var forth: Label = $VBoxContainer/Forth
#@onready var fifth: Label = $VBoxContainer/Fifth
#
#@onready var lables:Array = [first,second,third,forth,fifth]
#
#var config_file:ConfigFile = ConfigFile.new()
#
#func _ready() -> void:
	#await get_tree().create_timer(0.5).timeout
	#thanks.show()
	#await get_tree().create_timer(0.5).timeout
	#line_edit.show()
	#confirm.show()
#
#func new_values(_value1,_value2):
	#waves_survived = _value1
	#score = _value2
	#pass
#
#func set_leaderboard():
	#config_file.load("user://leaderboard.ini")
	#config_file.set_value("leaderboard_waves","%s" % player_name,"%s" % waves_survived)
	#config_file.set_value("leaderboard_score","%s" % player_name,"%s" % score)
	#config_file.save("user://leaderboard.ini")
	#
	#if !config_file.load("user://leaderboard.ini"):
		## Do not try to fill or whatever
		#pass
	#
	#var player_wave_dict:Dictionary[String,int]
	#for player in config_file.get_section_keys("leaderboard_waves"):
		#var wave_score = int(config_file.get_value("leaderboard_waves",player))
		#player_wave_dict[player] = wave_score
	#var sorted_ar = player_wave_dict.values()
	#sorted_ar.sort()
	#for num in 5:
		#if sorted_ar.size() > 0:
			#var val = sorted_ar.pop_back()
			#var display_player = player_wave_dict.find_key(val)
			#player_wave_dict.erase(display_player)
			#if display_player:
				#var display_score = config_file.get_value("leaderboard_score",display_player)
				#lables[num].text = "%s : waves %s : score %s" % [display_player , str(val) , str(display_score)]
				#lables[num].show()
#
#func _on_confirm_pressed() -> void:
	#player_name = line_edit.text
	#line_edit.hide()
	#confirm.hide()
	#set_leaderboard()
	#await get_tree().create_timer(0.5).timeout
	#play_again.show()
	#leader_board.show()
	#v_box_container.show()
