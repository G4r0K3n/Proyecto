extends HSlider

@export var audioNombre: String 
var audio

func _ready():
	audio = AudioServer.get_bus_index(audioNombre)

func _on_value_changed(value: float) -> void:
	var dB = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio, dB)
	
