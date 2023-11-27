extends Node2D

var herois = [
	[1,"1111",10,10,5,5,"descricao"],
	[2,"2222",10,10,5,5,"descricao"],
	[3,"3333",10,10,5,5,"descricao"],
	[4,"4444",10,10,5,5,"descricao"],
	[5,"5555",10,10,5,5,"descricao"]
	]
var baralhos = [[
	[100,"equipamento","chapeu","descricao",[[0,2,1]],6],
	[101,"equipamento","bota","descricao",[[0,4,1]],6],
	[102,"buff","buff 1","descricao",[[0,4,4]],6],
	[103,"buff","buff 2","descricao",[[0,4,4]],6],
	[104,"magia","magia 1","descricao",6,6],
	[104,"magia","magia 2","descricao",6,6]]]

var jogadores = []
var pronto = [false,false]



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
	
	func snapshot():
		var a = [self._pontos,[],[]]
		var b = []
		for elm in self._mao:
			a[1].append(elm._id)
		for elm in self._herois:
			a[2].append(elm.atributos()[0])
		for i in range(len(a[2])):
			for j in range(len(a[2][i][11])):
				b.append(a[2][i][11][j]._id)
				a[2][i][11]
				
		return a


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
		if len(self._equipamento) <= 3:
			print(len(self._equipamento))
			print("equipando",(equipamento))
			self._equipamento.append(equipamento)
			print(self._equipamento)
		else:
			self._equipamento.remove_at(0)
			self._equipamento.append(equipamento)
			self._modificador[self._equipamento[0][0]] -= self._equipamento[0][1]
	
	func buffar(buff):
		self._buff.append(buff)
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

	func atributos():
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
	var _custo
	func _init(id,nome,descricao,modificador,custo):
		self._id = id
		self._tipo = "equipamento"
		self._nome = nome
		self._descricao = descricao
		self._modificador = modificador
		self._custo = custo
	
	func modificador():
		return self._modificador
	
	func tipo():
		return self._tipo
	
	func custo():
		return self._custo
	
	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._descricao,
			self._modificador,
			self._custo
			],[
			"id",
			"tipo",
			"nome",
			"descricao",
			"modificador",
			"custo"
			]]


class Carta_buff:
	var _id
	var _tipo
	var _nome
	var _descricao
	var _modificador
	var _custo
	func _init(id,nome,descricao,buff,custo):
		self._id = id
		self._tipo = "buff"
		self._nome = nome
		self._descricao = descricao
		self._modificador = modificador
		self._custo = custo
	
	func modificador():
		return self._modificador
	
	func tipo():
		return self._tipo
	
	func custo():
		return self._custo
	
	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._descricao,
			self._modificador,
			self._custo
			],[
			"id",
			"tipo",
			"nome",
			"descricao",
			"modificador",
			"custo"
			]]


class Carta_magia:
	var _id
	var _tipo
	var _nome
	var _ataque
	var _descricao
	var _custo
	func _init(id,nome,descricao,ataque,custo):
		self._id = id
		self._tipo = "magia"
		self._nome = nome
		self._ataque = ataque
		self._descricao = descricao
		self._custo = custo
	
	func ataque():
		return self._ataque
	
	func tipo():
		return self._tipo
	
	func custo():
		return self._custo
	
	func  atributos():
		return [[
			self._id,
			self._tipo,
			self._nome,
			self._descricao,
			self._ataque,
			self._custo
			],[
			"id",
			"tipo",
			"nome",
			"ataque",
			"descricao",
			"custo"
			]]


func atacar_carta(atacante, atacado):
	atacado.perder_vida(atacante.ataque)

func usar_carta(jogador,usada):
	if jogador == 0:
		if jogadores[0]._mao[usada].tipo() == "equipamento":
			if jogadores[0]._pontos >= jogadores[0]._mao[usada].custo():
				jogadores[0]._pontos -= jogadores[0]._mao[usada].custo()
				jogadores[0]._herois[0].equipar(jogadores[0]._mao[usada])
		elif jogadores[0]._mao[usada].tipo() == "buff":
			if jogadores[0]._pontos >= jogadores[0]._mao[usada].custo():
				jogadores[0]._pontos -= jogadores[0]._mao[usada].custo()
				jogadores[0]._herois[0].buffar(jogadores[0]._mao[usada])
		elif jogadores[0]._mao[usada].tipo() == "magia":
			if jogadores[0]._herois[0].magia() >= jogadores[0]._mao[usada].custo():
				jogadores[0]._herois[0].perder_magia(jogadores[0]._mao[usada].custo())
				atacar_carta(jogadores[0]._mao[usada],jogadores[1]._herois[0])
		jogadores[0]._mao.remove_at(usada)
	elif jogador == 1:
		if jogadores[1]._mao[usada].tipo() == "equipamento":
			if jogadores[1]._pontos >= jogadores[1]._mao[usada].custo():
				jogadores[1]._pontos -= jogadores[1]._mao[usada].custo()
				jogadores[1]._herois[0].equipar(jogadores[1]._mao[usada])
		elif jogadores[1]._mao[usada].tipo() == "buff":
			if jogadores[1]._pontos >= jogadores[1]._mao[usada].custo():
				jogadores[1]._pontos -= jogadores[1]._mao[usada].custo()
				jogadores[1]._herois[0].buffar(jogadores[1]._mao[usada])
		elif jogadores[1]._mao[usada].tipo() == "magia":
			if jogadores[0]._herois[0].magia() >= jogadores[0]._mao[usada].custo():
				jogadores[1]._herois[0].perder_magia(jogadores[1]._mao[usada].custo())
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
			x.append(Carta_equipamento.new(baralhos[baralho][i][0],baralhos[baralho][i][2],baralhos[baralho][i][3],baralhos[baralho][i][4],baralhos[baralho][i][5]))
		elif baralhos[baralho][i][1] == "buff":
			x.append(Carta_buff.new(baralhos[baralho][i][0],baralhos[baralho][i][2],baralhos[baralho][i][3],baralhos[baralho][i][4],baralhos[baralho][i][5]))
		elif baralhos[baralho][i][1] == "magia":
			x.append(Carta_magia.new(baralhos[baralho][i][0],baralhos[baralho][i][2],baralhos[baralho][i][3],baralhos[baralho][i][4],baralhos[baralho][i][5]))
	return x

func entra_jogador(nome,heroi,baralho):
	if len(jogadores) == 0:
		jogadores.append(Jogador.new(0,nome,desdobrar_herois(heroi),desdobar_baralho(baralho)))
	elif len(jogadores) == 1:
		jogadores.append(Jogador.new(1,nome,desdobrar_herois(heroi),desdobar_baralho(baralho)))

func snapshot(jogador):
	var x = []
	if jogador == 0:
		x.append(jogadores[0].snapshot())
		x.append(jogadores[1].snapshot()[1])
	return x
	




func turno():
		jogadores[0]._herois[0].tick()
		jogadores[1]._herois[0].tick()
		print("turno")
		jogadores[0].compra()
		jogadores[1].compra()
		jogadores[0].compra()
		jogadores[1].compra()
		jogadores[0].compra()
		jogadores[1].compra()
		jogadores[0].compra()
		jogadores[1].compra()
		jogadores[0].compra()
		jogadores[1].compra()
		print(snapshot(0))
		usar_carta(0,0)
		usar_carta(1,0)
		print()
		print(snapshot(0))
		usar_carta(0,0)
		usar_carta(1,0)
		usar_carta(0,0)
		usar_carta(1,0)
		usar_carta(0,0)
		usar_carta(1,0)
		print()
		print(snapshot(0))
		

func _ready():
	print("test")
	entra_jogador("nomeaa",[1,2,3],0)
	entra_jogador("noaaaa",[1,2,3],0)
	pronto = [true,true]

	
	
func _process(delta):
	if pronto == [true,true]:
		pronto = [false,false]
		turno()
	
	
