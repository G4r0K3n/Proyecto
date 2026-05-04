extends CharacterBody2D

const GRAVEDAD = 800
const SPEED = 50
var vida = 4

var estado = estados_enemigo.movi
enum estados_enemigo {idle,movi, atck, mrte}


var direccion = 1
@onready var detSuelo = $Suelo
@onready var detPlyr = $Jugador
var puede_girar = true
var murio = false


func _ready():
	$pegar/pegarColi.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if estado == estados_enemigo.mrte:
		return
	gravedad(delta)
	
	match estado:
		estados_enemigo.movi:
			caminar()
		estados_enemigo.idle:
			velocity.x = 0
			$Enem.play("Idle")
		estados_enemigo.atck:
			velocity.x = 0
		estados_enemigo.mrte:
			velocity.x = 0
	choques()
	move_and_slide()
	
func choques():
	if detPlyr.is_colliding():
		var prepararse = detPlyr.get_collider()
		if prepararse.is_in_group("personaje") and estado == estados_enemigo.movi:
			preparandoAtaque()
			
func gravedad(delta):
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

func preparandoAtaque():
	if estado != estados_enemigo.movi:
		return
	estado = estados_enemigo.idle
	await get_tree().create_timer(0.2).timeout
	if detPlyr.is_colliding():
		atacar()
	else:
		estado = estados_enemigo.movi
	
func atacar():
	estado = estados_enemigo.atck
	$Enem.play("Atacando")
	$pegar/pegarColi.disabled = false
	await get_tree().create_timer(0.5).timeout
	if detPlyr.is_colliding():
		var jugador = detPlyr.get_collider()
		if jugador.is_in_group("personaje"):
			DatosPersonaje.vida -= 1
	$pegar/pegarColi.disabled = true
	
	await get_tree().create_timer(0.5).timeout
	estado = estados_enemigo.movi

func caminar():
	if (is_on_wall() or not $Suelo.is_colliding()) and puede_girar:
		giro()
	velocity.x = direccion * SPEED
	$Enem.play("Caminando")
	
func giro():
	puede_girar = false
	direccion *= -1
	$Enem.scale.x = direccion
	$Suelo.position.x = 35 * direccion
	$Jugador.target_position.x = abs($Jugador.target_position.x) * direccion
	$pegar.position.x = 18.75 * direccion
	await get_tree().create_timer(0.3).timeout
	puede_girar = true
	
func daño(cantidad):
	vida -= cantidad
	if vida <= 0:
		morir()
		
func morir():
	estado = estados_enemigo.mrte
	velocity.x = 0
	$Enem.play("Muerte")
	await $Enem.animation_finished
	queue_free()
		
