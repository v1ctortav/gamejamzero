extends PanelContainer

@onready var texto: HBoxContainer = $VBoxContainer/texto
@onready var escolhas: VBoxContainer = $VBoxContainer/escolhas
@onready var timer_dialogo: Timer = $timer_dialogo
@onready var label: RichTextLabel = $VBoxContainer/texto/RichTextLabel

var original_dialogo: String = ""

func _ready() -> void:
	hide()

func _start_dialogue(data: Dictionary):
	for child in escolhas.get_children():
		child.queue_free()
	texto.text = original_dialogo
	for i in range(data["opcoes"].size()):
		var opcao_data = data["opcoes"][i]
		var new_button = Button.new()
		new_button.text = opcao_data["texto"]
		new_button.pressed.connect(_on_opcao_escolhida.bind(
		opcao_data["resposta_vizinho"],new_button))
		escolhas.add_child(new_button)
		var fechar_button = Button.new()
		fechar_button.text = "Encerrar Análise"
		fechar_button.pressed.connect(_on_timer_dialogo_timeout) 
		escolhas.add_child(fechar_button)
		show()

func _on_opcao_escolhida(resposta_vizinho: String, button_node: Button):
	label.text = original_dialogo
	label.text += "\n\n> " + button_node.text + "\n" + resposta_vizinho
	button_node.disabled = true
	

func mostrar_dialogo(texto_resposta: String):
	for child in escolhas.get_children():
		child.queue_free()
	label.text = texto_resposta
	var fechar_button = Button.new()
	fechar_button.text = "Entendido"
	fechar_button.pressed.connect(_on_timer_dialogo_timeout)
	escolhas.add_child(fechar_button)
	show()

func _on_timer_dialogo_timeout() -> void:
	hide()
	original_dialogo = "" 
	emit_signal("dialogo_encerrado")
