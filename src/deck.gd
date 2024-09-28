class_name Deck
extends Control

const SFX_HURT = preload("res://assets/audio/hurt_c_08-102842.mp3")
const SFX_ADD = preload("res://assets/audio/water-droplet-5-165635.mp3")

@onready var label: RichTextLabel = %Label
@onready var explosion: CPUParticles2D = $Explosion
@onready var audio: AudioStreamPlayer = $Audio

@onready var base_label_scale = label.scale

var cards: Array[Card.Data] = []

func add_card(card: Card.Data, completely_new: bool = false) -> void:
	cards.push_back(card)
	label.text = str(cards.size())
	
	if completely_new:
		audio.stream = SFX_ADD
		audio.pitch_scale = 1 + randf_range(-0.1, 0.1)
		audio.play()

	await Utils.jiggle(label, 0.1).finished

func pop_cards(n: int, ill_intent: bool = false) -> Array[Card.Data]:
	var drawn_cards: Array[Card.Data] = []

	for i in range(n):
		if cards.size() == 0:
			break
		drawn_cards.push_back(cards.pop_front())

	label.text = str(cards.size())

	if ill_intent:
		audio.stream = SFX_HURT
		audio.pitch_scale = 1 + randf_range(-0.1, 0.1)
		audio.play()

	return drawn_cards

func shuffle() -> void:
	cards.shuffle()

func explode() -> CPUParticles2D:
	explosion.emitting = true
	explosion.reparent(get_parent())
	queue_free()
	return explosion
