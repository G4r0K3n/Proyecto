class_name Server 
extends Node

@export_category("Jugador")
@export var jugador : PackedScene
@export_category("Conexion")
@export var ip : String
@export var port : int 
@export var clientes : int
@export_category("Escena")
@export var escena: Node

var per = ENetMultiplayerPeer.new()
enum conexion {SERVER, CLIENTE}

func crearServidor(_port: int = port):
	per.create_server(_port, clientes)
	conexCorrecta(conexion.SERVER)
	multiplayer.multiplayer_peer = per
	multiplayer.peer_connected.connect(conectado)
	conectado()
	
func crearCliente(direccion: String = ip, _port: int = port):
	per.create_client(direccion, _port)
	conexCorrecta(conexion.CLIENTE)
	multiplayer.multiplayer_peer = per

func conectado(id: int = 1):
	var jugadorC = jugador.instantiate()
	jugadorC.name = str(id)
	escena.add_child(jugadorC, true)
	
	
func conexCorrecta(tipo: conexion):
	if per.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		if tipo == conexion.SERVER:
			OS.alert("Error de red")
		else:
			OS.alert("Error unirse partida")
		return
	
