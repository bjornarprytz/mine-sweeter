extends Node2D

@onready var score_label: RichTextLabel = %ScoreLabel
@onready var exp_label: RichTextLabel = %ExpLabel

@onready var map: Map = %Map
@onready var camera: Camera2D = %Camera
@onready var deck: Deck = %Deck

var score: int = 0
var next_level: int = 6
var experience: int = next_level

func _ready():
	map.create_grid()
	Events.cell_revealed.connect(_on_cell_revealed)
	Events.mine_tripped.connect(_on_mine_tripped)
	Events.mines_confirmed.connect(_on_mines_confirmed)
	camera.position = map.get_center_cell().position

func _on_cell_revealed(cell: Cell):

	experience -= 1
	exp_label.clear()
	exp_label.append_text("[center]%s[/center]" % str(experience))

	if experience <= 0:
		next_level += 2
		experience = next_level
		deck.add_card(Card.Data.good())


	if cell.number > 0 or cell.is_mine or cell.is_flagged:
		return

	await get_tree().create_timer(0.1).timeout

	for neighbor in map.get_neighbors(cell):
		neighbor.reveal()

func _on_mine_tripped(mine: Cell):
	var mine_value: int = 2 # TODO: Change this

	var cards = deck.pop_cards(mine_value)

	if deck.cards.size() == 0:
		score_label.clear()
		score_label.append_text("[center][color=purple]You lose![/color][/center]")

func _on_mines_confirmed(mines: Array[Cell]):
	var mine_value: int = 1 # TODO: Change this

	var cards = deck.pop_cards(mine_value * mines.size())

	var value_cards: Array[Card.Data] = []
	var multiplier_cards: Array[Card.Data] = []
	var multipliers: Array[int] = []

	for card in cards:
		if card.type == Card.Type.VALUE:
			value_cards.append(card)
		elif card.type == Card.Type.MULTIPLIER:
			multiplier_cards.append(card)

	var score_multiplier: int = 1

	for card in multiplier_cards:
		score_multiplier *= card.value
		multipliers.append(card.value)

	var score_value: int = 0
	var values = []

	for card in value_cards:
		score_value += card.value
		values.append(card.value)

	score += score_value * score_multiplier

	print("Scoring cards:")
	print(values)
	print(multipliers)

	score_label.clear()
	score_label.append_text("[center][color=green]%s[/color][/center]" % str(score))

	for card in cards:
		deck.add_card(card)
