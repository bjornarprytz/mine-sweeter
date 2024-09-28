class_name ExperienceProgress
extends TextureProgressBar

const SFX_ADD_EXP = preload("res://assets/audio/single-waterdrop-sound-202543.mp3")
const SFX_DING = preload("res://assets/audio/simple-note.wav")

@export var deck: Deck

@onready var exp_label: RichTextLabel = %ExpLabel
@onready var audio: AudioStreamPlayer = $Audio

var next_level: int = 6
var experience: int = next_level


func add_exp(exp: int) -> void:
	experience -= exp


	value = next_level - experience

	audio.stream = SFX_ADD_EXP
	audio.pitch_scale = 1.0 + float(next_level - experience) / next_level
	audio.play()
	
	if experience <= 0:
		audio.stream = SFX_DING
		audio.pitch_scale = 1
		next_level += 2
		experience = next_level
		max_value = next_level
		_ding()
	
	exp_label.clear()
	exp_label.append_text("[center]%s[/center]" % str(next_level - experience))

func _ding():
	if deck == null:
		return
	
	var card_data = Card.Data.good()
	# Find the world position of the exp_progress, which is a UI element
	var origin = get_tree().root.get_canvas_transform().affine_inverse() * (position + (get_rect().size / 2))

	var card_flower = Create.CardFlower(origin, deck, card_data)
	card_flower.terminus.connect(_add_card.bind(card_data))
	get_tree().root.add_child(card_flower)

func _add_card(card_data: Card.Data):
	if deck == null:
		return
	deck.add_card(card_data, true)
