extends CharacterBody2D

const SPEED = 100
const GRAVEDAD = 800.0
const SPEED_PERSEGUIR = 110

var persona = null
var direccion = 1
var atacar = false
var puedeGirar = true
var vida = 7
var murio = false

@onready var suelo: RayCast2D = $Suelo
@onready var jugador: RayCast2D = $Jugador
@onready var area_de_agro: Area2D = $areaAgro

@onready var hitbox: CollisionPolygon2D = $Golpe/hitbox
@onready var boss: AnimatedSprite2D = $BOSS


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Golpe/hitbox.disabled = true
	area_de_agro.body_entered.connect(_on_area_agro_body_entered)
	area_de_agro.body_exited.connect(_on_area_agro_body_exited)
	$Golpe.body_entered.connect(_on_golpe_body_entered)
	
func _physics_process(delta):
	if murio:
		return
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta
		
	if jugador.is_colliding():
		var colision = jugador.get_collider()
		if colision and colision.is_in_group("personaje"):
			atacando()
			move_and_slide()
			return
			
	if persona:
		perseguir()
	else:
		patrulla()
	move_and_slide()
	
	
func patrulla():
	if (is_on_wall() or not suelo.is_colliding()) and puedeGirar:
		direccion *= -1
		girar(direccion)
	velocity.x = SPEED_PERSEGUIR * direccion
	boss.play("correr")


func perseguir():
	var direcc = sign(persona.global_position.x - global_position.x)
	velocity.x = SPEED_PERSEGUIR * direcc
	boss.play("correr")
	if direcc != 0:
		boss.flip_h = direcc < 0
		$Suelo.position.x = abs($Suelo.position.x) * direcc
		$Jugador.target_position.x = abs($Jugador.target_position.x) * direcc
		$Golpe.position.x = abs($Golpe.position.x) * direcc
		$Golpe.scale.x = direcc
		
func atacando():
	if atacar:
		return
	atacar = true
	velocity.x = 0
	boss.play("atacar")
	$Golpe/hitbox.disabled = false
	await get_tree().create_timer(1.0).timeout
	$Golpe/hitbox.disabled = true
	await get_tree().create_timer(1.0).timeout
	atacar = false

func girar(dir):
	puedeGirar = false
	direccion = dir
	boss.flip_h = dir < 0
	$Suelo.position.x = abs($Suelo.position.x) * dir
	$Jugador.target_position.x = abs($Jugador.target_position.x) * dir
	$Golpe.position.x = abs($Golpe.position.x) * dir
	$Golpe.scale.x = dir
	await get_tree().create_timer(0.3).timeout
	puedeGirar = true
	
func daño(cantidad):
	print("vida", vida)
	if murio:
		return
	vida -= cantidad
	if vida <= 0:
		muerte()
	
func muerte():
	atacar = true
	velocity.x = 0
	$Golpe/hitbox.disabled = true
	DatosPersonaje.dash = true
	DatosPersonaje.invenatario.append("Pies Veloces")
	queue_free()

func _on_area_agro_body_entered(body: Node2D) -> void:
	if body.is_in_group("personaje"):
		persona = body


func _on_area_agro_body_exited(body: Node2D) -> void:
	if body.is_in_group("personaje"):
		persona = null


func _on_golpe_body_entered(body: Node2D) -> void:
	if body.is_in_group("personaje"):
		DatosPersonaje.vida -= 1
