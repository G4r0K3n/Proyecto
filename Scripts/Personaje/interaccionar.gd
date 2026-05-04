extends Area2D

var interaccionar = []
@onready var label: Label = $Label
var interacciona = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interaccionar"):
		if interaccionar.is_empty() == false and interacciona:
			interacciona = true
			label.hide()
			await interaccionar.back().interaccionar()
			interacciona = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interaccionar.is_empty() == false:
		label.show()
	else:
		label.hide()


func _on_area_entered(area: Area2D) -> void:
	interaccionar.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	interaccionar.erase(area)
