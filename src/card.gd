class_name Card
extends Node2D

enum Type {
	VALUE,
	MULTIPLIER
}

var type: Type = Type.VALUE

var mul: float = 1.0:
	set(v):
		if v == mul:
			return
		assert(type == Type.MULTIPLIER)
		mul = v

		value_label.clear()
		value_label.add_text("[centered]x%s" % str(mul))

var val: int = 0:
	set(v):
		if v == val:
			return
		assert(type == Type.VALUE)
		val = v

		value_label.clear()
		value_label.add_text("[centered]%s" % str(val))

@onready var value_label: RichTextLabel = %Value
