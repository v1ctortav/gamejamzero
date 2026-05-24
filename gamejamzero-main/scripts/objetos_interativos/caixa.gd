extends StaticBody2D

@export_enum("bom", "ruim") var tipo_ponto: String = "bom"

signal evidencia_escaneada(id_do_vizinho)

@export var id_do_vizinho: String = "vizinho_generico"

@onready var game_director = get_tree().current_scene

func _interagir():

	if tipo_ponto == "bom":
		Global.bom += 1
		print("Bom", Global.bom)

	elif tipo_ponto == "ruim":
		Global.ruim += 1
		print("Ruim", Global.ruim)

	print("Vizinho '", id_do_vizinho, "' teste!")

	emit_signal("evidencia_escaneada", id_do_vizinho)
