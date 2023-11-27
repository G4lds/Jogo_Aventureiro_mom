extends Node2D

var Player = [null, null, null, []]
var Enemy = [null, null, null, []]
var CampoP = [null]
var CampoE = [null]
var CemiterioP = []
var CemiterioE = []

var grid_size = Vector2(5, 2)
var cell_size = Vector2(100, 150)
var hand_size = 3

# Lista de modificadores
var modificadores = ["vida", "ataque", "magia", "velocidade", "defesa_normal", "defesa_magica"]

func _ready():
	# Conecte os nós aos sprites 2D
	Player[0] = get_node("Carta1")
	Player[1] = get_node("Carta2")
	Player[2] = get_node("Carta3")

	Enemy[0] = get_node("Enemy1")
	Enemy[1] = get_node("Enemy2")
	Enemy[2] = get_node("Enemy3")

	CampoP[0] = get_node("CampoP")

	CampoE[0] = get_node("CampoE")

	# Crie o tabuleiro do Player
	create_board(Vector2(100, 100), grid_size, "Player", 1)

	# Distribua 3 cartas para o Player e o Enemy
	distribuir_cartas(3, Player[3], Player[0])
	distribuir_cartas(3, Enemy[3], Enemy[0])

	print("Partida iniciada!")
	print("Mão do Player:", Player[3])
	print("Mão do Enemy:", Enemy[3])
	
	# Conectar os sinais de clique dos sprites às funções correspondentes
	for card in Player[0]:
		card.connect("mouse_entered", self, "_on_card_mouse_entered", [Player[0].index(card)])
		card.connect("mouse_exited", self, "_on_card_mouse_exited", [Player[0].index(card)])
		card.connect("input_event", self, "_on_card_input_event", [Player[0].index(card)])

	for campo in CampoP[0]:
		campo.connect("input_event", self, "_on_campo_input_event", [CampoP[0].index(campo)])

# Função chamada quando o mouse entra na carta
func _on_card_mouse_entered(index):
	print("Mouse entrou na carta:", index)

# Função chamada quando o mouse sai da carta
func _on_card_mouse_exited(index):
	print("Mouse saiu da carta:", index)

# Função chamada quando ocorre um evento de entrada (clicar) na carta
func _on_card_input_event(viewport, event, index):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicou na carta:", index)
		# Implemente aqui a lógica para selecionar a carta

# Função chamada quando ocorre um evento de entrada (clicar) no campo do jogador
func _on_campo_input_event(viewport, event, index):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicou no CampoP:", index)
		# Implemente aqui a lógica para mover a carta para o CampoP

		# Exemplo de como comprar uma carta aleatória do baralho após jogar no CampoP
		comprar_carta(Player[3], Player[0])

# Função para comprar uma carta aleatória do baralho
func comprar_carta(mao, baralho):
	if baralho[0]:
		move_carta([0, baralho, 0], [1, mao, 0])
		baralho[0].remove(baralho[0][0])  # Remove a primeira carta do baralho
		if baralho[1]:
			baralho[1].remove_at(0)  # Remove o primeiro modificador da carta
		else:
			print("Modificadores vazios.")
	else:
		print("Baralho vazio.")

# Cria uma carta
func popular(jogador: int):
	print("populando jogador", jogador)
	if jogador == 1:
		if Player[0]:
			move_carta([0, Player, 0], [1, CampoP, 0])
		else:
			print("Baralho do jogador 1 vazio.")
	elif jogador == 2:
		if Enemy[0]:
			move_carta([0, Enemy, 0], [1, CampoE, 0])
		else:
			print("Baralho do jogador 2 vazio.")

# Move uma carta
func move_carta(de, para):
	print("movendo carta")
	if de[0] == 0 and para[0] == 0:
		para[1].append(de[1][de[2]])
		de[1].remove_at(de[2])
	elif de[0] == 0 and para[0] == 1:
		if para[1][para[2]] == false:
			para[1][para[2]] = de[1][de[2]]
			de[1].remove_at(de[2])
	elif de[0] == 1 and para[0] == 0:
		para[1].append(de[1][de[2]])
		de[1][de[2]] = false
	elif de[0] == 1 and para[0] == 1:
		if para[1][para[2]] == false:
			para[1][para[2]] = de[1][de[2]]
			de[1][de[2]] = false
			pass

# Cria o tabuleiro do jogador
func create_board(position, size, player_name, player_number):
	# Container para o campo do jogador
	var player_field_container = VBoxContainer.new()
	player_field_container.position = position
	add_child(player_field_container)

	# Container para a mão do jogador
	var player_hand_container = VBoxContainer.new()
	player_hand_container.position = position + Vector2(0, cell_size.y * 3)  # Adicionei um espaço para a mão
	add_child(player_hand_container)

	for y in range(size.y):
		var card_container = HBoxContainer.new()

		# Adiciona o container ao campo ou à mão do jogador
		if y < hand_size:
			player_hand_container.add_child(card_container)
		else:
			player_field_container.add_child(card_container)

		var card_panel = Panel.new()  # Use Panel ou Control
		card_container.add_child(card_panel)

		var card_sprite = Sprite2D.new()
		card_sprite.rect_min_size = cell_size
		card_panel.add_child(card_sprite)

		# Adiciona uma carta ao baralho do jogador
		if player_number == 1:
			Player[0].append("Carta " + str(y * size.x))
		elif player_number == 2:
			Enemy[0].append("Carta " + str(y * size.x))

		# Adiciona a lista de modificadores à carta
		if player_number == 1:
			Player[1].append(modificadores)
		elif player_number == 2:
			Enemy[1].append(modificadores)

# Distribui cartas para o jogador
func distribuir_cartas(quantidade, mao, baralho):
	for i in range(quantidade):
		if baralho[0]:
			move_carta([0, baralho, 0], [1, mao, 0])
			baralho[0].remove(baralho[0][0])  # Remove a primeira carta do baralho
			if baralho[1]:
				baralho[1].remove_at(0)  # Remove o primeiro modificador da carta
			else:
				print("Modificadores vazios.")
		else:
			print("Baralho vazio.")
