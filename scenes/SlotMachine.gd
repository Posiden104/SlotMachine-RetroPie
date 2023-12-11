extends Node2D


onready var bet_label = $BetLabel
onready var win__percent__label = $"Dev Label Container/Win Percent Label"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("bet_updated", self, "bet_updated")
	GameManager.connect("stopped", self, "update_win_label")

func bet_updated(bet):
	bet_label.text = "Bet: %d" % bet

func update_win_label():
	win__percent__label.text = "Pulls %.f\nWins: %.f\nPercentage: %.2f%%" % [GameManager.pulls, GameManager.wins, GameManager.get_win_percent()]
