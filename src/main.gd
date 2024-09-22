extends Node2D

@onready var score_label: RichTextLabel = %ScoreLabel
@onready var exp_label: RichTextLabel = %ExpLabel

@onready var map: Map = %Map
@onready var camera: Camera2D = %Camera
@onready var deck: Deck = %Deck
@onready var card_scoring: CardScoring = %CardScoring

var score: float = 0.0:
	set(value):
		if score == value:
			return
		score = value

		score_label.clear()
		score_label.append_text("[center]%s[/center]" % str(int(score)))

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

func _on_mine_tripped(_mine: Cell):
	var mine_value: int = 2 # TODO: Change this

	var cards = deck.pop_cards(mine_value)

	if deck.cards.size() == 0:
		score_label.clear()
		score_label.append_text("[center][color=purple]You lose![/color][/center]")

func _on_mines_confirmed(mines: Array[Cell]):
	if mines.size() == 0:
		return

	card_scoring.show()

	var mine_value: int = 1 # TODO: Change this

	var result = await card_scoring.score_cards(deck.pop_cards(mine_value * mines.size()))

	card_scoring.hide()
	
	var tween = create_tween()
	tween.tween_property(self, "score", score + result, 1.0)
