extends Node

const SND_ENEMY_RADIO_END = preload("uid://b0ncy6eliu011")
const SND_ENEMY_RADIO_START = preload("uid://d28h6xjj7ae44")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_01 = preload("uid://d4hpewluh5mu4")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_02 = preload("uid://dwkx0y2n47yee")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_03 = preload("uid://ddowgu2bguymw")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_04 = preload("uid://dccu885wtnbwa")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_05 = preload("uid://c2vuvpjm04mfi")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_06 = preload("uid://gy461s63oc4b")
const SND_ENEMY_RADIO_VOICE_DEAD_BODY_FOUND_07 = preload("uid://o2sy0yddensg")
const SND_ENEMY_RADIO_VOICE_LOST_INTEREST_01 = preload("uid://cfvchdg7pncgq")
const SND_ENEMY_RADIO_VOICE_LOST_INTEREST_02 = preload("uid://b80iml2li3xfu")
const SND_ENEMY_RADIO_VOICE_LOST_INTEREST_03 = preload("uid://b2u0hfojx7ctc")
const SND_ENEMY_RADIO_VOICE_LOST_INTEREST_04 = preload("uid://cs7y0w6406gof")
const SND_ENEMY_RADIO_VOICE_LOST_SIGHT_01 = preload("uid://d1lsn876nnm2v")
const SND_ENEMY_RADIO_VOICE_LOST_SIGHT_02 = preload("uid://dfmryesxqoxou")
const SND_ENEMY_RADIO_VOICE_LOST_SIGHT_03 = preload("uid://f5seam5qdlw")
const SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_01 = preload("uid://dlg2y7wuxnvpt")
const SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_02 = preload("uid://pw7fpdcq3r42")
const SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_03 = preload("uid://cbtcbb8550t2f")
const SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_04 = preload("uid://dwcilha2b4bfb")
const SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_05 = preload("uid://cpeky7l2w7ivh")
const SND_ENEMY_RADIO_VOICE_PLAYER_KILLED_01 = preload("uid://ct3jfhvobaxh3")
const SND_ENEMY_RADIO_VOICE_PLAYER_KILLED_02 = preload("uid://fgjl1j0vpmfj")
const SND_ENEMY_RADIO_VOICE_SPOTTED_01 = preload("uid://p40j0kbiqqqu")
const SND_ENEMY_RADIO_VOICE_SPOTTED_02 = preload("uid://5tks8wyl40rg")
const SND_ENEMY_RADIO_VOICE_SPOTTED_03 = preload("uid://bhugk2qun8wn")
const SND_ENEMY_RADIO_VOICE_SPOTTED_04 = preload("uid://bonv7qqk0yfhn")
const SND_ENEMY_RADIO_VOICE_SPOTTED_05 = preload("uid://2djlb6arxw25")

const A_CLOSE:Array = [
	SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_01,
	SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_02,
	SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_03,
	SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_04,
	SND_ENEMY_RADIO_VOICE_NEARLY_SPOTTED_05
	]

const A_SEEN:Array = [
	SND_ENEMY_RADIO_VOICE_SPOTTED_01,
	SND_ENEMY_RADIO_VOICE_SPOTTED_02,
	SND_ENEMY_RADIO_VOICE_SPOTTED_03,
	SND_ENEMY_RADIO_VOICE_SPOTTED_04,
	SND_ENEMY_RADIO_VOICE_SPOTTED_05,
]

const A_KILLED:Array = [
	SND_ENEMY_RADIO_VOICE_PLAYER_KILLED_01,
	SND_ENEMY_RADIO_VOICE_PLAYER_KILLED_02,
]

var spotted_lockout:bool = false

func _ready() -> void:
	GVar.signal_bus.hunter_near_player.connect(player_close)
	GVar.signal_bus.hunter_see_player.connect(player_spotted)

func player_close(g_pos:Vector3):
	GSound.play_sound_in_sequence(&"SFX",[SND_ENEMY_RADIO_START,A_CLOSE.pick_random(),SND_ENEMY_RADIO_END],g_pos)

func player_spotted(g_pos:Vector3):
	if spotted_lockout: return
	create_timeout()
	GSound.play_sound_in_sequence(&"SFX",[SND_ENEMY_RADIO_START,A_SEEN.pick_random(),SND_ENEMY_RADIO_END],g_pos)

func player_shot(g_pos:Vector3):
	GSound.play_sound_in_sequence(&"SFX",[SND_ENEMY_RADIO_START,A_KILLED.pick_random(),SND_ENEMY_RADIO_END],g_pos)

func create_timeout():
	spotted_lockout = true
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.start(3.0)
	await timer.timeout
	spotted_lockout = false
