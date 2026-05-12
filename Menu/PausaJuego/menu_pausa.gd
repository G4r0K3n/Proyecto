extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func abrir():
	show()
	get_tree().paused = true
	
func cerrar():
	hide()
	get_tree().paused = false
	
func _on_reanudar_pressed():
	cerrar()


func _on_guardar_pressed():
	guardar()


func _on_salir_pressed():
	cerrar()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
func guardar():
	var datos = {
		"vida": DatosPersonaje.vida,
		"monedas": DatosPersonaje.monedas,
		"escena": get_tree().current_scene.scene_file_path,
		"posicion_X": get_tree().get_first_node_in_group("personaje").global_position.x,
		"posicion_Y": get_tree().get_first_node_in_group("personaje").global_position.y,
		"inventario": DatosPersonaje.invenatario,
		"botas_des": DatosPersonaje.botas_des,
		"dash": DatosPersonaje.dash
	}
	var arch = FileAccess.open("user://saveGame.json", FileAccess.WRITE)
	arch.store_string(JSON.stringify(datos))
	arch.close()
	
