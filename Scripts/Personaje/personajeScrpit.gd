extends CharacterBody2D
#Creamos variables para el input y constante velocidad y gravedad. El @export es para que el valor de la variable lo podamos modificar desde el inspector
var input
const SPEED = 100
const GRAVEDAD = 800.0

#Salto
var contador_Sal = 0
@export var max_Salto = 2
const SALTO = 300

#Todo lo referente a estados de movimiento atacar o muerte
var estado = estados_Personaje.movi
enum estados_Personaje {movi, atck, mrte}

@onready var menu_pausa = preload("res://Menu/PausaJuego/menu_pausa.tscn")
var pausa
@onready var inventario = preload("res://Menu/inventario/inventario.tscn")
var inven

var morir = false

var atacando = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if multiplayer.has_multiplayer_peer():
		if name.to_int() == 0:
			set_multiplayer_authority(1)
		else:
			set_multiplayer_authority(name.to_int())
		if not is_multiplayer_authority():
			return
			
			
	pausa = menu_pausa.instantiate()
	add_child(pausa)
	inven = inventario.instantiate()
	add_child(inven)
	if DatosPersonaje.posicion != null:
		global_position = DatosPersonaje.posicion
		DatosPersonaje.posicion = null
	$espada/colisionEsp.disabled = true
	$PersonajeAnimado.animation_finished.connect(_animacion_acabada)
	$espada.body_entered.connect(golpeo)

func _process(delta):
	if multiplayer.has_multiplayer_peer() and not is_multiplayer_authority():
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if pausa.visible:
			pausa.cerrar()
		else:
			pausa.abrir()
	if Input.is_action_just_pressed("Inventario"):
		if inven.abierto:
			inven.cerrar()
		else:
			inven.abrir()
			
func _physics_process(delta):	
	if multiplayer.has_multiplayer_peer() and not is_multiplayer_authority():
		return
	
	if DatosPersonaje.vida <= 0:
		estado = estados_Personaje.mrte
	
	if is_on_floor():
		contador_Sal = 0
		
	if Input.is_action_just_pressed("ui_accept") and contador_Sal < max_Salto:
			velocity.y = -SALTO
			contador_Sal +=1
	
	match estado:
		estados_Personaje.movi:
			movimiento(delta)
		estados_Personaje.atck:
			gravedad(delta)
			movimiento_atacando(delta)
			move_and_slide()
		estados_Personaje.mrte:
			muerte()

# Una funcion en la que basicamente lo que hacemos es decir que la variable input va a reconocer los inputs de derrecha y izquieda
func movimiento(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if input != 0:
		if input > 0:
			velocity.x += SPEED * delta
			velocity.x = clamp(SPEED, 100.0, SPEED)
			$PersonajeAnimado.scale.x = 1
			$espada.scale.x = 1
			$PersonajeAnimado.play("Corriendo")
		if input < 0:
			velocity.x -= SPEED * delta
			velocity.x = clamp(-SPEED, 100.0, -SPEED)
			$PersonajeAnimado.scale.x = -1
			$espada.scale.x = -1
			$PersonajeAnimado.play("Corriendo")
	if input == 0:
		velocity.x = 0
		$PersonajeAnimado.play("Idle")

#Salto
	if !is_on_floor():
		if velocity.y > 0:
			$PersonajeAnimado.play("Caer")
		if velocity.y < 0:
			$PersonajeAnimado.play("Saltar")
		
	if Input.is_action_pressed("ui_atacar"):
		estado = estados_Personaje.atck
		ataque()
		
	if is_on_wall() and Input.is_action_just_pressed("ui_accept") and DatosPersonaje.botas_des:
		if velocity.x > 0:
			velocity = Vector2(-800,-350)
		elif velocity.x < 0:
			velocity = Vector2(800, -350)
		
		
	gravedad(delta)
	move_and_slide()
	
func gravedad(delta):
	if is_on_wall() and DatosPersonaje.botas_des and velocity.y > 0:
		velocity.y += GRAVEDAD * 0.1 * delta
	else:
		velocity.y += GRAVEDAD * delta
	
func ataque():
	$PersonajeAnimado.play("Atacar")
	$espada/colisionEsp.disabled = false
	
func normalidad():
	estado = estados_Personaje.movi

func _animacion_acabada():
	if estado == estados_Personaje.atck:
		$espada/colisionEsp.disabled = true
		estado = estados_Personaje.movi
		
func movimiento_atacando(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if input > 0:
		velocity.x += SPEED * delta
		velocity.x = clamp(SPEED, 100.0, SPEED)
		$PersonajeAnimado.scale.x = 1
		$espada.scale.x = 1
	elif input < 0:
		velocity.x -= SPEED
		velocity.x = clamp(-SPEED, 100.0, -SPEED)
		$PersonajeAnimado.scale.x = -1
		$espada.scale.x = -1
	else:
		velocity.x = 0
		
func muerte():
	if morir:
		return
	morir = true
	$PersonajeAnimado.play("Muerte")
	velocity.x = 0
	await $PersonajeAnimado.animation_finished
	DatosPersonaje.vida = 4
	DatosPersonaje.monedas = 0
	DatosPersonaje.invenatario = []
	DatosPersonaje.botas_des = false
	if get_tree():
		get_tree().reload_current_scene()
		
func golpeo(body):
	if body.is_in_group("enemigo"):
		body.daño(2)

func _enter_tree() -> void:
	if multiplayer.has_multiplayer_peer():
		if name.to_int() == 0:
			set_multiplayer_authority(1)
		else:
			set_multiplayer_authority(name.to_int())
