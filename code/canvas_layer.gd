extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_in():
	$fade_in.play("fade_in")

func transition():
	$fade_out.play("fade_out")
	await get_tree().create_timer(1).timeout
	$fade_in.play("fade_in")
