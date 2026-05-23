extends StaticBody2D

@export_enum("bom", "ruim") var tipo_ponto: String = "bom"

func _interagir():
	if tipo_ponto == "bom":
		Global.bom += 1
		print("Bom", Global.bom)
	elif tipo_ponto == "ruim":
		Global.ruim += 1
		print("Ruim", Global.ruim)
