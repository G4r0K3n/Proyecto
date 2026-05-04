extends Control

@onready var ip = $VBoxContainer/ip
@onready var multijugadorMan = $Server

func _on_crear_pressed() -> void:
	multijugadorMan.crearServidor()
	

func _on_unirse_pressed() -> void:
	multijugadorMan.crearCliente(ip.text)
