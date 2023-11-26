extends Control

onready var player_hand_container : VBoxContainer = $PlayerHandContainer
onready var enemy_container : VBoxContainer = $EnemyContainer
onready var log_text : RichTextLabel = $LogText

var player : Personagem
var inimigo : Personagem

func _ready():
	player = Personagem.new()
	inimigo = Personagem.new()

	# Configuração inicial da UI
	atualizar_interface()

func atualizar_interface():
	# Atualiza as mãos dos jogadores
	atualizar_mao_do_jogador()
	atualizar_mao_do_inimigo()

func atualizar_mao_do_jogador():
	# Limpa a mão do jogador
	player_hand_container.clear_children()

	# Adiciona cartas à mão do jogador
	for i in range(5):
		var carta_button = Button.new()
		carta_button.text = "Carta " + str(i+1)
		carta_button.connect("pressed", self, "_on_carta_selecionada", [i])
		player_hand_container.add_child(carta_button)

func atualizar_mao_do_inimigo():
	# Limpa a mão do inimigo
	enemy_container.clear_children()

	# Adiciona cartas à mão do inimigo (pode ser aleatório ou lógica do jogo)
	for i in range(3):
		var carta_label = Label.new()
		carta_label.text = "Inimigo - Carta " + str(i+1)
		enemy_container.add_child(carta_label)

func _on_carta_selecionada(index):
	# Lógica quando o jogador seleciona uma carta
	log_text.bbcode_text += "\nJogador usou Carta " + str(index+1)
	# Adicione aqui a lógica para aplicar os efeitos da carta
	atualizar_interface()  # Atualiza a interface após a jogada
