class_name Card
extends Control

const bad_card_type_probability_distribution: Array[float] = [0.9, 0.1]
const good_card_type_probability_distribution: Array[float] = [0.75, 0.25]
const card_type_values: Array[Type] = [Type.VALUE, Type.MULTIPLIER]

const good_card_values: Array[int] = [1, 2, 3, 4]
const good_card_values_probability_distribution: Array[float] = [0.50, 0.30, 0.15, 0.05]

const good_card_mul_values: Array[int] = [2, 3, 4, 5]
const good_card_mul_values_probability_distribution: Array[float] = [0.5, 0.4, 0.07, 0.03]

const bad_card_values: Array[int] = [-1, -2, -3, -4]
const bad_card_values_probability_distribution: Array[float] = [0.25, 0.5, 0.15, 0.1]

const bad_card_mul_values: Array[int] = [-1]
const bad_card_mul_values_probability_distribution: Array[float] = [1.0]

class Data:
	var type: Type
	var value: int

	func _init(_type: Type, _value: int):
		self.type = _type
		self.value = _value
	
	static func bad() -> Card.Data:
		var type_index = Utils.get_index_from_probability_distribution(bad_card_type_probability_distribution)
		var _type = card_type_values[type_index]
		match _type:
			Type.VALUE:
				var index = Utils.get_index_from_probability_distribution(bad_card_values_probability_distribution)
				return Card.Data.new(_type, bad_card_values[index])
			Type.MULTIPLIER:
				var index = Utils.get_index_from_probability_distribution(bad_card_mul_values_probability_distribution)
				return Card.Data.new(_type, bad_card_mul_values[index])
			_:
				return null

	static func good() -> Card.Data:
		var type_index = Utils.get_index_from_probability_distribution(good_card_type_probability_distribution)
		var _type = card_type_values[type_index]
		match _type:
			Type.VALUE:
				var index = Utils.get_index_from_probability_distribution(good_card_values_probability_distribution)
				return Card.Data.new(_type, good_card_values[index])
			Type.MULTIPLIER:
				var index = Utils.get_index_from_probability_distribution(good_card_mul_values_probability_distribution)
				return Card.Data.new(_type, good_card_mul_values[index])
			_:
				return null

enum Type {
	VALUE,
	MULTIPLIER
}

var data: Data:
	set(value):
		data = value
		if is_node_ready():
			_update_label()
		

@onready var value_label: RichTextLabel = %Value


func pop_in():
	var original_scale = scale

	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale * 1.4, 0.1)
	tween.tween_property(self, "scale", original_scale, 0.2)
	await tween.finished

func _ready() -> void:
	_update_label()

func _update_label():
	value_label.clear()
	if data == null:
		return

	if data.value < 0:
		modulate = Color(1, 0.5, 0.5) # Light red for negative values
	else:
		modulate = Color(0.5, 1, 0.5) # Light green for positive values

	match data.type:
		Type.VALUE:
			value_label.append_text("[center]%s" % [str(data.value)])
		Type.MULTIPLIER:
			value_label.append_text("[center]x%s" % [str(data.value)])
