extends Area2D

@onready var cofre: AnimatedSprite2D = $cofre
var abierto = false

func interaccionar():
	if abierto == false:
		cofre.play("abrir")
		await cofre.animation_finished
		abierto = true
		DatosPersonaje.botas_des = true
		DatosPersonaje.invenatario.append("botas")
	else:
		cofre.play("normal")
