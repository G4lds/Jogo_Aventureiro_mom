extends Node2D

var baralho_jogador_1 = [[],[]]
var baralho_jogador_2 = [[],[]]
var mao_jogador_1 = []
var mao_jogador_2 = []
var campo_jogador_1 = [[],[]]
var campo_jogador_2 = [[],[]]
var cemiterio_jogador_1 = []
var cemiterio_jogador_2 = []

var grid_size = Vector2(5, 2)
var cell_size = Vector2(100, 150)
var hand_size = 3

# Lista de modificadores
var modificadores = ["vida", "ataque", "magia", "velocidade", "defesa_normal", "defesa_magica"]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Crie o tabuleiro do jogador 1
	create_board(Vector2(100, 100), grid_size, "Player 1", 1)

	# Crie o tabuleiro do jogador 2
	create_board(Vector2(100, 400), grid_size, "Player 2", 2)

	print("campo entrou")
	print(mao_jogador_1,"\n",campo_jogador_1)


# cria uma carta
func popular(jogador: int):
	print("populando jogador", jogador)
	if jogador == 1:
		if baralho_jogador_1[0]:
			move_carta([0, baralho_jogador_1[0], 0], [1, mao_jogador_1, 0])
		else:
			print("Baralho do jogador 1 vazio.")
	elif jogador == 2:
		if baralho_jogador_2[0]:
			move_carta([0, baralho_jogador_2[0], 0], [1, mao_jogador_2, 0])
		else:
			print("Baralho do jogador 2 vazio.")


func move_carta(de, para):
	print("movendo carta")
	# [ tipo, lista, posicao ]
	# [0,x,x] = cemiterio/baralho
	# [1,x,x]  = campo/mao
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


func create_board(position, size, player_name, player_number):
	# Container para o campo do jogador
	var player_field_container = VBoxContainer.new()
	player_field_container.position = position
	add_child(player_field_container)

	# Container para a mão do jogador
	var player_hand_container = VBoxContainer.new()
	player_hand_container.position = position + Vector2(0, cell_size.y * 3)  # Adicionei um espaço para a mão
	add_child(player_hand_container)

	for x in range(size.x):
		for y in range(size.y):
			var card_container = HBoxContainer.new()

			# Adiciona o container ao campo ou à mão do jogador
			if x < hand_size:
				player_hand_container.add_child(card_container)
			else:
				player_field_container.add_child(card_container)

			var card_sprite = Sprite.new()
			card_sprite.rect_min_size = cell_size
			card_container.add_child(card_sprite)

			# Aqui você pode adicionar mais lógica conforme necessário, como detectar cliques nas cartas, etc.

			# Adiciona uma carta ao baralho do jogador
			if player_number == 1:
				baralho_jogador_1[0].append("Carta " + str(x + y * size.x))
			elif player_number == 2:
				baralho_jogador_2[0].append("Carta " + str(x + y * size.x))

			# Adiciona a lista de modificadores à carta
			if player_number == 1:
				baralho_jogador_1[1].append(modificadores)
			elif player_number == 2:
				baralho_jogador_2[1].append(modificadores)
