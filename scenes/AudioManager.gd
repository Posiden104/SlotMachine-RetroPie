extends Node2D

enum sound_playing {
	NOTHING,
	PULL,
	SPIN,
	WIN,
	STOP
}

onready var sound_player: AudioStreamPlayer = $SoundPlayer

var pull_sound = preload("res://sounds/slots_pull_001.wav")
var spin_sound = preload("res://sounds/roulette_spin_001.wav")
var stop_sound = preload("res://sounds/slots_spin_stop_001.wav")
var win_sound = preload("res://sounds/slots_win_001.wav")
var big_win = preload("res://sounds/slots_bigwin_001.wav")
var coin_drop_win = preload("res://sounds/slots_bigwin_002.wav")

var state

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("spinning", self, "play_pull")
#	GameManager.connect("stopped", self, "play_stop")
	GameManager.connect("win", self, "play_win")
	
	state = sound_playing.NOTHING

func play_pull(_fix: bool, _idx: int):
	if !sound_player.is_playing():
		sound_player.stream = pull_sound
		sound_player.play()
		state = sound_playing.PULL

#func play_spin():
#	if !sound_player.is_playing():
#		sound_player.stream = spin_sound
#		sound_player.play()
#		state = sound_playing.SPIN

#func play_stop():
#	print("play stopped")
#	if sound_player.is_playing():
#		sound_player.stop()
#	sound_player.stream = stop_sound
#	sound_player.play()
#	state = sound_playing.STOP

func play_win(win_type):
	state = sound_playing.WIN
	GameManager.lock_wheel(true)
	sound_player.stop()
	match win_type:
		game_manager.win_type.BIG:
			sound_player.stream = big_win
		game_manager.win_type.NORMAL:
			sound_player.stream = win_sound
	
	sound_player.play()

func _on_SoundPlayer_finished():
	match state:
		sound_playing.PULL:
			pass
		sound_playing.SPIN:
			pass
		sound_playing.WIN:
			GameManager.lock_wheel(false)
			state = sound_playing.NOTHING
		sound_playing.NOTHING:
			pass
