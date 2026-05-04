extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Moneda.play("Moneda")

func _on_body_entered(body):
	if body.name == "personaje":
		DatosPersonaje.monedas += 1
		queue_free()
