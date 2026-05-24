extends PanelContainer

signal dialogo_encerrado

@onready var texto: HBoxContainer = $VBoxContainer/texto
@onready var escolhas: VBoxContainer = $VBoxContainer/escolhas
@onready var timer_dialogo: Timer = $timer_dialogo
@onready var label: RichTextLabel = $VBoxContainer/texto/RichTextLabel

var original_dialogo: String = ""

func _ready() -> void:
	hide()

func start_dialogue(data: Dictionary):
	for child in escolhas.get_children():
		child.queue_free()

	original_dialogo = data["texto"]

	label.clear()
	label.append_text(original_dialogo)

	for opcao_data in data["opcoes"]:
		var new_button = Button.new()

		new_button.text = opcao_data["texto"]

		new_button.pressed.connect(
			_on_opcao_escolhida.bind(
				opcao_data["resposta_vizinho"],
				new_button
			)
		)

		escolhas.add_child(new_button)

	var fechar_button = Button.new()

	fechar_button.text = "Encerrar Análise"

	fechar_button.pressed.connect(_on_timer_dialogo_timeout)

	escolhas.add_child(fechar_button)

	show()

func _on_opcao_escolhida(
	resposta_vizinho: String,
	button_node: Button
):
	label.clear()

	label.append_text(original_dialogo)
	label.append_text("\n\n> " + button_node.text)
	label.append_text("\n" + resposta_vizinho)

	button_node.disabled = true

func mostrar_dialogo(texto_resposta: String):
	for child in escolhas.get_children():
		child.queue_free()

	label.clear()
	label.append_text(texto_resposta)

	var fechar_button = Button.new()

	fechar_button.text = "Entendido"

	fechar_button.pressed.connect(_on_timer_dialogo_timeout)

	escolhas.add_child(fechar_button)

	show()

func _on_timer_dialogo_timeout() -> void:
	hide()

	original_dialogo = ""

	label.clear()

	emit_signal("dialogo_encerrado")
