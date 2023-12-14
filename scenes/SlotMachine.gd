extends Node2D


onready var bet_label = $BetLabel
onready var win_percent_label = $"Dev Label Container/Win Percent Label"
onready var bank_label = $"Bank Label"

var total_bet: int = 0
var total_won: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("bet_updated", self, "bet_updated")
	$"%GameManager".connect("stopped", self, "update_win_label")
	SignalBus.connect("bet_placed", self, "update_bet_total")
	SignalBus.connect("won_credit", self, "update_win_total")


func bet_updated(bet):
	bet_label.text = "Bet: %d" % bet


func update_win_label():
	win_percent_label.text = "Pulls %.f\nWins: %.f\nPercentage: %.2f\nReturn To Player: %.2f" % [$"%GameManager".pulls, $"%GameManager".wins, $"%GameManager".get_win_percent(), float(total_won)/float(total_bet)*100.0]


func update_bet_total(bet: int):
	total_bet += bet
	update_bank_label()


func update_win_total(to_add: int):
	total_won += to_add
	update_bank_label()


func update_bank_label():
	bank_label.text = "Total Bet: %d\nTotal Won: %d" % [total_bet, total_won]
	update_win_label()
