extends Area2D

func _on_body_entered(body):
	if body.name == "personaje":
		DatosPersonaje.vida -= 1
