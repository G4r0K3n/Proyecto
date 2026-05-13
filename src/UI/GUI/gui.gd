extends CanvasLayer

const NUM_CORA = 8
const SEPA_CORA = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in DatosPersonaje.vida:
		var nuevo_cora = Sprite2D.new()
		nuevo_cora.texture = $vida.texture
		nuevo_cora.hframes = $vida.hframes
		$vida.add_child(nuevo_cora)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Monedas.text = var_to_str(DatosPersonaje.monedas)
	mostrarCorazones()

func mostrarCorazones():
	for corazones in $vida.get_children():
		var index = corazones.get_index()
		var x = (index % NUM_CORA) * SEPA_CORA
		var y = (index / SEPA_CORA) * SEPA_CORA
		corazones.position = Vector2(x, y)
		var ultimoCora = floor(DatosPersonaje.vida)
		if index > ultimoCora:
			corazones.frame = 0
		if index == ultimoCora:
			corazones.frame = (DatosPersonaje.vida - ultimoCora) * 4
		if index < ultimoCora:
			corazones.frame = 4
			
