extends Node2D


const pontos = 10
const niveis = [50, 125]
const campo = [4,2]
const mao = 5

var baralho = [[
	["personagem",5, "Deirdre de Paor" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [1,20,30], [10,20,30], [10,20,30],"Pessimista por Natureza, desde muito jovem teve que roubar para poder ter o que comer. Ele não é muito fã de conflitos, por isso costuma trabalhar de forma ágil e sorrateira."],
	["personagem",5, "Alianna Armstrong" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [2,20,30], [10,20,30], [10,20,30],"Descricao"],
	["personagem",5, "Elrohir" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [3,20,30], [3,20,30], [10,20,30],"Descricao"],
	["personagem",5, "Ireti" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [4,20,30], [4,20,30], [10,20,30],"Descricao"]
	],[
	["personagem",5, "Deirdre de Paor" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [1,20,30], [10,20,30], [10,20,30],"Pessimista por Natureza, desde muito jovem teve que roubar para poder ter o que comer. Ele não é muito fã de conflitos, por isso costuma trabalhar de forma ágil e sorrateira."],
	["personagem",5, "Alianna Armstrong" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [2,20,30], [10,20,30], [10,20,30],"Descricao"],
	["personagem",5, "Elrohir" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [10,20,30], [3,20,30], [10,20,30],"Descricao"],
	["personagem",5, "Ireti" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [10,20,30], [4,20,30], [10,20,30],"Descricao"]
	]]

var jogadores = []
var pronto = [false,false]
var proximos_movimentos = []
var proximos_ataques = []

class jogador:
	var _nome
	var _pontos
	var _pontos_total
	var _cemiterio
	var _baralho
	var _campo
	var _mao
	func _init(nome,pontos,baralho,limite_campo,limite_mao):
		self._nome = nome
		self._pontos = pontos
		self._pontos_total = pontos
		self._cemiterio = []
		self._baralho = baralho
		self._campo = []
		self._mao = []
		_desdobrar_campo(limite_campo) 
		_desdobrar_mao(limite_mao)
		
	func _desdobrar_campo(limite_campo):
		for i in range(limite_campo[0]* limite_campo[1]):
			self._campo.append(false)
	func _desdobrar_mao(limite_mao):
		for i in range(limite_mao):
			self._mao.append(false)

	func adicionar_pontos(pontos):
		self._pontos = clamp(self._pontos + pontos,0,self._pontos_total)
	func gastar_pontos(pontos):
		if pontos <= self._pontos:
			self._pontos -= pontos
		else:
			return -1


class carta_personagem:
	var _modo
	var _tipo
	var _custo
	var _nome
	var _experiencia
	var _classe
	var _raca
	var _vida
	var _dano
	var _ataque
	var _magia
	var _velocidade
	var _defesa_normal
	var _defesa_magica
	var _descricao
	var _modificador
	
	func _init(
		tipo,
		custo,
		nome,
		classe,
		raca,
		vida,
		ataque,
		magia,
		velocidade,
		defesa_normal,
		defesa_magica,
		descricao
		):
		self._tipo = tipo
		self._modo = "defesa"
		self._custo = custo
		self._nome = nome
		self._experiencia = 0
		self._classe = classe
		self._raca = raca
		self._vida = vida
		self._dano = 0
		self._ataque = ataque
		self._magia = magia
		self._velocidade = velocidade
		self._defesa_normal = defesa_normal
		self._defesa_magica = defesa_magica
		self._descricao = descricao
		self._modificador = [0,0,0,0,0,0]

	# retorna os valores dos status
	func nivel():
		if self._experiencia < niveis[0]:
			return 0
		if self._experiencia > niveis[1]:
			return 2
		return 1
	func tipo():
		return self._tipo
	func modo():
		return self._modo
	func custo():
		return self._custo
	func nome():
		return self._nome
	func classe():
		return self._classe
	func vida():
		return self._vida[self.nivel()] + self._modificador[0] - self._dano
	func ataque():
		return self._ataque[self.nivel()] + self._modificador[1]
	func magia():
		return self._magia[self.nivel()] + self._modificador[2]
	func velocidade():
		return self._velocidade[self.nivel()] + self._modificador[3]
	func defesa_normal():
		return self._defesa_normal[self.nivel()] + self._modificador[4]
	func defesa_magica():
		return self._defesa_magica[self.nivel()] + self._modificador[5]
	func descricao():
		return self._descricao
	func modificador(atributo):
		if atributo == "vida":
			return self._modificador[0]
		elif atributo == "ataque":
			return self._modificador[1]
		elif atributo == "magia":
			return self._modificador[2]
		elif atributo == "velocidade":
			return self._modificador[3]
		elif atributo == "defesa_normal":
			return self._modificador[4]
		elif atributo == "defesa_magica":
			return self._modificador[5]
		else:
			return self._modificador
	
	func recebe_dano(tipo,dano):
		if self._modo == "defesa":
			if tipo == "normal":
				self._dano +=  clamp(dano - self.defesa_normal(),0,999)
				print("ai, recebi ", dano, " de dano, estou com ", self.vida(), "de vida")
			elif tipo == "magico":
				self.dano +=  clamp(dano - self.defesa_magica(),0,999)
		else:
			self._dano += dano
		if self._dano > self._vida[nivel()] + self._modificador[0]:
				self._dano = self._vida
		
	func recebe_modificador(atributo,valor):
		if atributo == "vida":
			self._modificador[0] += valor
		elif atributo == "ataque":
			self._modificador[1] += valor
		elif atributo == "magia":
			self._modificador[2] += valor
		elif atributo == "velocidade":
			self._modificador[3] += valor
		elif atributo == "defesa_normal":
			self._modificador[4] += valor
		elif atributo == "defesa_magica":
			self._modificador[5] += valor
		else:
			self._modificador

func desdobrar_baralho(id):
	var x = []
	for elm in baralho[id]:
		x.append(carta_personagem.new(elm[0],elm[1],elm[2],elm[3],elm[4],elm[5],elm[6],elm[7],elm[8],elm[9],elm[10],elm[11]))
	return x

func move_carta(de,para):
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

func entra_jogador(nome,baralho):
	if len(jogadores) <= 1:
		jogadores.append(jogador.new(nome, pontos, desdobrar_baralho(baralho),campo,mao))
		print("jogador ",len(jogadores)," (",nome,") entrou")

func atacar(atacante,atacado):
	if atacante.tipo() == "personagem":
		atacado.recebe_dano("normal",atacante.ataque())

func turno():
	if pronto[0] and pronto[1]:
		print("turno")
		pass

func turno_combate(ataques):
	var index = []
	
	# indexa
	for i in range(len(ataques)):
		index.append(i)
	# ordena
	for j in range(len(index)-1,0,-1):
		for i in range(j):
			if ataques[index[i]][1].velocidade() > ataques[index[i+1]][1].velocidade():
				var temp = index[i]
				index[i] = index[i+1]
				index[i+1] = temp
	for elm in index:
		atacar(ataques[elm][1],ataques[elm][2])
	proximos_ataques = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ola mundo")
	entra_jogador("jose",0)
	entra_jogador("marta",0)
	print("\njogadores criados")
	proximos_ataques = [
	["ataque",jogadores[0]._baralho[3],jogadores[1]._baralho[1]],
	["ataque",jogadores[0]._baralho[2],jogadores[1]._baralho[2]],
	["ataque",jogadores[0]._baralho[1],jogadores[1]._baralho[3]],
	["ataque",jogadores[0]._baralho[0],jogadores[1]._baralho[3]],
	["ataque",jogadores[0]._baralho[3],jogadores[1]._baralho[1]],
	["ataque",jogadores[0]._baralho[2],jogadores[1]._baralho[2]],
	["ataque",jogadores[0]._baralho[1],jogadores[1]._baralho[3]],
	["ataque",jogadores[0]._baralho[0],jogadores[1]._baralho[3]]]
	print(proximos_ataques)
	turno_combate(proximos_ataques)
	print(proximos_ataques)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
