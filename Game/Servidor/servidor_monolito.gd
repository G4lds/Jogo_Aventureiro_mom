extends Node2D

var herois = [
	[1,"1111",10,10,5,5,"descricao"],
	[2,"2222",10,10,5,5,"descricao"],
	[3,"3333",10,10,5,5,"descricao"],
	[4,"4444",10,10,5,5,"descricao"],
	[5,"5555",10,10,5,5,"descricao"]
	]
var baralhos = [[
	[100,"equipamento","chapeu","descricao",[[0,4,0]]],
	[101,"equipamento","bota","descricao",[[0,4,0]]],
	[102,"buff","buff 1","descricao",[[0,4,4]]],
	[103,"buff","buff 2","descricao",[[0,4,4]]],
	[104,"magia","magia 1","descricao",6],
	[104,"magia","magia 2","descricao",6]]]

var jogadores = []
var pronto = [false,false]
var turno_atual = 0



class Jogador:
	var _id
	var _nome
	var _pontos
	var _mao
	var _herois
	var _baralho
	var _cemiterio
	func _init(id,nome,herois,baralho):
		self._id = id
		self._nome = nome
		self._pontos = 10
		self._mao = []
		self._herois = herois
		self._baralho = baralho
		self._cemiterio = []
	
	func ciclar():
		if self._herois[0].vida() <= 0:
			self._cemiterio.append(self._herois[0])
		elif len(self._herois) > 1:
			self._herois.append(self._herois[0])
		self._herois.remove_at(0)
	
	func compra():
		if len(self._mao) <= 5:
			self._mao.append(self._baralho[0])
			self._baralho.remove_at(0)

class Carta_heroi:
	var _id
	var _tipo
	var _nome
	var _vida
	var _vida_perdida
	var _magia
	var _magia_perdida
	var _ataque
	var _defesa
	var _descricao
	var _modificador
	var _equipamento
	var _buff
	func _init(id,nome,vida,ataque,magia,defesa,descricao):
		self._id = id
		self._tipo = "heroi"
		self._nome = nome
		self._vida = vida
		self._vida_perdida = 0
		self._magia = magia
		self._magia_perdida = 0
		self._ataque = ataque
		self._defesa = defesa
		self._descricao = descricao
		self._modificador = [0,0,0,0]
		self._equipamento = []
		self._buff = []
		
	func tick():
		# atualiza os modificadores
		self._modificador = [0,0,0,0]
		for elm1 in self._equipamento:
			for elm in elm1:
				self._modificador[elm[0]] += elm[1]
		for j in range(len(self._buff)):
			for i in range(len(self._buff[j])):
				if self._buff[j][i][2] > 0:
					self._modificador[self._buff[j][i][0]] += self._buff[j][i][1]
					self._buff[j][i][2] += -1
				else:
					self._buff.remove_at(i)
	
	func equipar(equipamento):
		if len(self._equipamento) >= 3:
			self._equipamento.append(equipamento)
		else:
			self._equipamento.remove_at(0)
			self._equipamento.append(equipamento)
			self._modificador[self._equipamento[0][0]] -= self._equipamento[0][1]
		self._modificador[equipamento[0]] = equipamento[1]
	
	func buffar(buff):
		self._ebuff.append(buff)
		self._modificador[buff[0]] = buff[1]
	
	func perder_vida(valor):
		self._vida_perdida += clamp(valor - self.defesa(),0,self.vida())
	
	func perder_magia(valor):
		self._magia_perdida -= clamp(valor,0,self._magia)
	
	func tipo():
		return self._tipo
	
	func vida():
		return self._vida + self._modificador[0] - self._vida_perdida
	
	func magia():
		return self._magia + self._modificador[1] - self._magia_perdida
	
	func ataque():
		return self._ataque + self._modificador[2]
	
	func defesa():
		return self._defesa + self._modificador[3]

	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._vida,
			self._vida_perdida,
			self._magia,
			self._magia_perdida,
			self._ataque,
			self._defesa,
			self._descricao,
			self._modificador,
			self._equipamento,
			self._buff
			],[
			"id",
			"tipo",
			"nome",
			"vida",
			"vida_perdida",
			"magia",
			"magia_perdida",
			"ataque",
			"defesa",
			"descricao",
			"modificador",
			"equipamento",
			"buff"
			]]


class Carta_equipamento:
	var _id
	var _tipo
	var _nome
	var _descricao
	var _modificador
	func _init(id,nome,modificador,descricao):
		self._id = id
		self._tipo = "equipamento"
		self._nome = nome
		self._descricao = descricao
		self._modificador = modificador
	
	func modificador():
		return self._modificador
	
	func tipo():
		return self._tipo
	
	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._descricao,
			self._modificador
			],[
			"id",
			"tipo",
			"nome",
			"descricao",
			"modificador"
			]]


class Carta_buff:
	var _id
	var _tipo
	var _nome
	var _descricao
	var _modificador
	func _init(id,nome,buff,descricao):
		self._id = id
		self._tipo = "buff"
		self._nome = nome
		self._descricao = descricao
		self._modificador = modificador
	
	func modificador():
		return self._modificador
	
	func tipo():
		return self._tipo
	
	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._descricao,
			self._modificador
			],[
			"id",
			"tipo",
			"nome",
			"descricao",
			"modificador"
			]]


class Carta_magia:
	var _id
	var _tipo
	var _nome
	var _ataque
	var _descricao
	func _init(id,nome,ataque,descricao):
		self._id = id
		self._tipo = "magia"
		self._nome = nome
		self._ataque = ataque
		self._descricao = descricao
	
	func ataque():
		return self._ataque
	
	func tipo():
		return self._tipo
	
	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._descricao,
			self._ataque
			],[
			"id",
			"tipo",
			"nome",
			"ataque",
			"descricao"
			]]


func atacar_carta(atacante, atacado):
	atacado.perder_vida(atacante.ataque)

func usar_carta(jogador,usada):
	if jogador == 0:
		if usada.tipo() == "equipamento":
			jogadores[0]._herois[0].equipar(usada)
		elif usada.tipo() == "buff":
			jogadores[0]._herois[0].buffar(usada)
		elif usada.tipo() == "magia":
			atacar_carta(jogadores[0]._mao[usada],jogadores[1]._herois[0])
		jogadores[0]._mao.remove_at(usada)
	elif jogador == 1:
		if usada.tipo() == "equipamento":
			jogadores[1]._herois[0].equipar(usada)
		elif usada.tipo() == "buff":
			jogadores[1]._herois[0].buffar(usada)
		elif usada.tipo() == "magia":
			atacar_carta(jogadores[1]._mao[usada],jogadores[0]._herois[0])
		jogadores[1]._mao.remove_at(usada)

func desdobrar_herois(heroi):
	var x = []
	for i in range(3):
		x.append(Carta_heroi.new(herois[heroi[i]][0],herois[heroi[i]][1],herois[heroi[i]][2],herois[heroi[i]][3],herois[heroi[i]][4],herois[heroi[i]][5],herois[heroi[i]][6]))
	return x
	
func desdobar_baralho(baralho):
	var x = []
	for i in range(len(baralhos[baralho])):
		if baralhos[baralho][i][1] == "equipamento":
			x.append(Carta_equipamento.new(baralhos[baralho][i][0],baralhos[baralho][i][1],baralhos[baralho][i][2],baralhos[baralho][i][3]))
		elif baralhos[baralho][i][1] == "buff":
			x.append(Carta_buff.new(baralhos[baralho][i][0],baralhos[baralho][i][1],baralhos[baralho][i][2],baralhos[baralho][i][3]))
		elif baralhos[baralho][i][1] == "magia":
			x.append(Carta_magia.new(baralhos[baralho][i][0],baralhos[baralho][i][1],baralhos[baralho][i][2],baralhos[baralho][i][3]))
	return x

func entra_jogador(nome,heroi,baralho):
	if len(jogadores) == 0:
		jogadores.append(Jogador.new(0,nome,desdobrar_herois(heroi),desdobar_baralho(baralho)))
	elif len(jogadores) == 1:
		jogadores.append(Jogador.new(1,nome,heroi,baralho))

func turno():
	print("turno")
	pass

func _ready():
	#entra_jogador("aaaaa",[1,2,3],0)
	print("test")
	entra_jogador("nomeaa",[1,2,3],0)
	entra_jogador("nomeaaa",[1,2,3],0)
	pronto = [true,true]
	
	
func _process(delta):
	if pronto == [true,true]:
		pronto = [false,false]
		turno()
	pass
	
	
