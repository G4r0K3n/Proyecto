extends CharacterBody2D

const SPEED = 100
const GRAVEDAD = 800.0
const SPEED_PERSEGUIR = 200

var persona = null
var direccion = 1
var atacar = false 

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
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta
		
	if jugador.is_colliding():
		var colision = jugador.get_collider()
		if colision and colision.is_in_group("personaje"):
			atacando()
			move_and_slide()
			return
			
	if jugador:
		perseguir()
	else:
		patrulla()
	move_and_slide()
	
	
func patrulla():
	if not suelo.is_colliding():
		direccion *= -1
		girar(direccion)
	velocity.x = SPEED_PERSEGUIR * direccion


func perseguir():
	var direcc = sign(jugador.global_position.x - global_position.x)
	velocity.x = SPEED_PERSEGUIR * direcc
	girar(direcc)
		
func atacando():
	if atacar:
		return
	atacar = true
	velocity.x = 0
	DatosPersonaje.vida -= 2
	boss.play("atacar")
	await get_tree().create_timer(1.5).timeout
	atacar = false

func girar(dir):
	if direccion != 0:
		boss.flip_h = dir < 0
		

func _on_area_agro_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_agro_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
