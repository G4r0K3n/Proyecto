extends CanvasLayer

@onready var Casillas = $Panel/TextureRect/Casillas.get_children()
var abierto = false

const ITEMS = {
	"botas": {
		"imagen": preload("res://src/UI/Inventario/Items/EscaladaBotas.png"),
		"descripcion": "Las botas de Hermes - Si no te permiten volar, pero con esto desafiaras la gravedad de la escalada"
	},
	"Pies Veloces":{
		"imagen": preload("res://src/UI/Inventario/Items/Dash.png"),
		"descripcion": "Pies Veloces. Con esto tendras la capacidad de moverte de una manera mas rapida"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	actualizarInv()

func abrir():
	show()
	abierto = true
	get_tree().paused = true
	actualizarInv()

func cerrar():
	hide()
	abierto = false
	get_tree().paused = false

func actualizarInv():
	for cas in Casillas:
		cas.texture = null
		cas.tooltip_text = ""
		
	for i in DatosPersonaje.invenatario.size():
		var nom = DatosPersonaje.invenatario[i]
		if nom in ITEMS:
			Casillas[i].texture = ITEMS[nom]["imagen"]
			Casillas[i].tooltip_text = ITEMS[nom]["descripcion"]


func _on_button_pressed() -> void:
	cerrar()
