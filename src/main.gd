extends Node2D

@onready var score_label: RichTextLabel = %ScoreLabel
@onready var exp_progress: TextureProgressBar = %ExpProgress
@onready var exp_label: RichTextLabel = %ExpLabel

@onready var map: Map = %Map
@onready var camera: Camera2D = %Camera
@onready var deck: Deck = %Deck
@onready var card_scoring: CardScoring = %CardScoring
@onready var game_over: Panel = $CanvasLayer/GameOver

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
	modulate.a = 0
	create_tween().tween_property(self, "modulate:a", 1, 1)

func _on_cell_revealed(cell: Cell):
	if cell.is_mine:
		return

	var exp_flower = Create.ExpFlower(cell.position, exp_progress)
	exp_flower.terminus.connect(_progress_exp)
	add_child(exp_flower)

	if cell.number > 0 or cell.is_flagged:
		return

	await get_tree().create_timer(0.1).timeout

	for neighbor in map.get_neighbors(cell):
		neighbor.reveal()


func _progress_exp():
	experience -= 1
	exp_label.clear()
	exp_label.append_text("[center]%s[/center]" % str(next_level - experience))
	var tween = create_tween()
	tween.tween_property(exp_progress, "value", next_level - experience, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	if experience <= 0:
		next_level += 2
		experience = next_level
		exp_progress.max_value = next_level
		_ding()

func _ding():
	var card_data = Card.Data.good()
	# Find the world position of the exp_progress, which is a UI element
	var origin = get_canvas_transform().affine_inverse() * (exp_progress.position + (exp_progress.get_rect().size / 2))
	print(origin)
	var card_flower = Create.CardFlower(origin, deck, card_data)
	card_flower.terminus.connect(_add_card.bind(card_data))
	add_child(card_flower)

func _add_card(card_data: Card.Data):
	deck.add_card(card_data)

func _on_mine_tripped(mine: Cell):
	var mine_flower = Create.MineFlower(mine.position, deck)
	mine_flower.terminus.connect(_mine_effect)
	add_child(mine_flower)

func _mine_effect():
	var mine_value: int = 2 # TODO: Change this
	var cards = deck.pop_cards(mine_value)

	await Utils.shake(camera, 0.069, 10).finished

	if deck.cards.size() == 0:
		score_label.clear()
		score_label.append_text("[center][color=purple]You lose![/color][/center]")
		await deck.explode().finished
		game_over.show()
		game_over.modulate.a = 0
		create_tween().tween_property(game_over, "modulate:a", 1, 1)

func _on_mines_confirmed(mines: Array[Cell]):
	if mines.size() == 0:
		return

	var mine_value: int = 1 # TODO: Change this

	var cards_to_score = deck.pop_cards(mine_value * mines.size())

	var result = await card_scoring.score_cards(cards_to_score)

	var origin = get_canvas_transform().affine_inverse() * (card_scoring.position + (card_scoring.get_rect().size / 2))

	for s in range(abs(result)):
		var score_flower = Create.ScoreFlower(origin, score_label.get_parent())
		score_flower.terminus.connect(_add_score.bind(mine_value))
		add_child(score_flower)
		score_flower.position.x += randf_range(-20, 20)
		await get_tree().create_timer(randf_range(.05, .1)).timeout

	for card in cards_to_score:
		deck.add_card(card)

func _add_score(value: int):
	score += value

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://loading_screen.tscn")
