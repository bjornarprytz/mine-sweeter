extends Node2D
@onready var loading: RichTextLabel = %Loading

func _ready() -> void:
    ResourceLoader.load_threaded_request("res://main.tscn")

# Only do this every second
var time_left = .2

func _process(delta: float) -> void:

    time_left -= delta
    if time_left > 0:
        return

    time_left = .2
    var progress_param: Array = []
    if ResourceLoader.load_threaded_get_status("res://main.tscn", progress_param) != ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
        if progress_param.size() > 0:
            loading.visible_ratio = progress_param[0]
    else:
        var scene = ResourceLoader.load_threaded_get("res://main.tscn")
        get_tree().change_scene_to_packed(scene)
