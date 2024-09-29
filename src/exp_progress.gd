class_name ExperienceProgress
extends TextureProgressBar

const SFX_ADD_EXP = preload("res://assets/audio/pop.wav")
const SFX_DING = preload("res://assets/audio/flipcard.wav")

@export var deck: Deck

@onready var ding_audio: AudioStreamPlayer = $DingAudio
@onready var audio: AudioStreamPlayer = $Audio
@onready var display_card: Card = $Display

var next_level: int = 6
var experience: int = 0


func _ready() -> void:
	_cycle_card_on_display()
	

func add_experience(added_exp: int) -> void:
	experience += added_exp
	
	if experience < next_level:
		audio.stream = SFX_ADD_EXP
		audio.pitch_scale = .69 + float(experience) / next_level
		audio.play()
	else:
		ding_audio.stream = SFX_DING
		ding_audio.pitch_scale = .8 + randf_range(-0.1, 0.1)
		ding_audio.play()
		next_level += 2
		experience = 0
		max_value = next_level
		_ding()
		_cycle_card_on_display()

	value = experience

func _cycle_card_on_display():
	display_card.data = Card.Data.good()
	Utils.jelly_scale(display_card, .4)

func _ding():
	if deck == null:
		return
	
	var card_data = display_card.data
	# Find the world position of the exp_progress, which is a UI element
	var origin = get_tree().root.get_canvas_transform().affine_inverse() * (position + (get_rect().size / 2))

	var card_flower = Create.CardFlower(origin, deck, card_data)
	card_flower.terminus.connect(_add_card.bind(card_data))
	get_tree().root.add_child(card_flower)

func _add_card(card_data: Card.Data):
	if deck == null:
		return
	deck.add_card(card_data, true)
