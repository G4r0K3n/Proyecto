extends Camera2D

#Cargamos una variable personaje la cual apunta al personaje creado y asi apuntar a este
@onready var personaje = $"../personaje"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seguir_plyer()
	
func seguir_plyer():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position = personaje.position
	
