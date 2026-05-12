extends Control

@onready var botones: VBoxContainer = $botones
@onready var opciones: Panel = $opciones

# Called when the node enters the scene tree for the first time.
func _ready():
	botones.visible = true
	opciones.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_nueva_part_pressed():
	multiplayer.multiplayer_peer = null
	DatosPersonaje.botas_des = false
	DatosPersonaje.dash = false
	DatosPersonaje.monedas = 0
	DatosPersonaje.vida = 4
	DatosPersonaje.invenatario = []
	get_tree().change_scene_to_file("res://Niveles/lvl_1.tscn")


func _on_cargar_part_pressed():
	if FileAccess.file_exists("user://saveGame.json"):
		var arch = FileAccess.open("user://saveGame.json",FileAccess.READ)
		var dtos = JSON.parse_string(arch.get_as_text())
		arch.close()
		
		DatosPersonaje.vida = int(dtos["vida"])
		DatosPersonaje.monedas = int(dtos["monedas"])
		DatosPersonaje.posicion = Vector2(dtos["posicion_X"], dtos["posicion_Y"])
		
		if dtos.has("inventario"):
			DatosPersonaje.invenatario = dtos["inventario"]
		if dtos.has("botas_des"):
			DatosPersonaje.botas_des = dtos["botas_des"]
		if dtos.has("dash"):
			DatosPersonaje.dash = dtos["dash"]
		get_tree().change_scene_to_file(dtos["escena"])

func _on_multijugador_pressed():
	get_tree().change_scene_to_file("res://Menu/Multijugador/multijugador.tscn")

func _on_opciones_pressed():
	botones.visible = false
	opciones.visible = true

func _on_salir_pressed():
	get_tree().quit()


func _on_volver_pressed():
		opciones.visible = false
		botones.visible = true
	
