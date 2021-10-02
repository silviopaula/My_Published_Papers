*--------------------------------------------------------------------------------------*
// Artigo: A Ética Protestante e o Espírito do Capitalismo: Preferências quanto ao   //
//  Mercado de Trabalho, Empreendedorismo e a Estrutura Familiar no Brasil           //
*-------------------------------------------------------------------------------------*

// link para baixar os microdados do censo 2010
*https://basedosdados.org/dataset/br-ibge-censo-demografico

// link do artigo: 
*https://www.revistas.usp.br/ecoa/article/view/175247

// Orientações quanto aos microdados do censo 2010: 
* Baixe os microdados do censo 2010 de pessoas e dominicios, abra no stata e salve como dta.

// Orientações para rodar para o Sample2:
* precione ctrl + H e substitua sample1 por sample2

*--------------------*
// Instalar pacotes //
*--------------------*
*ssc install asdoc
*ssc install outreg2
*ssc install psmatch2
*net install st0085_2.pkg

*--------------------*
//   Configurações  //
*--------------------*
* Limpar tudo
clear all 

* Não interromper tabelas longas permanentemente
*set more off, perm 

* Carregar microdados já em formato stata
use "D:\PAPER_RELIGION\DADOS\CENSO_2010\Censo_Pessoas_2010.dta", clear

*Fazer append com os dados de domicilio
append using "D:\PAPER_RELIGION\DADOS\CENSO_2010\Censo_Dominicios_2010.dta"

*------------------------------------*
//   Gerar variáveis de tratamento  //
*------------------------------------*

* v6121 - Religiões
clonevar clone_v6121 = v6121

* Destring
destring clone_v6121, replace

* Converter de numeric para string:
tostring clone_v6121, generate(str_v6121)

* Gerar variavel com os grupos de religião com o primeiro digito
gen   religiao_geral = substr(str_v6121,1,1)
order religiao_geral, before(str_v6121)
tab   religiao_geral

* Convertendo a variável religiao_geral de string para numeric
destring religiao_geral, replace 

* GRUPOS DE RELIGIAO E RELIGIOES
* 0 - 00 SEM RELIGIAO
* 1 - 11 CATOLICA APOSTOLICA ROMANA
*     12 CATOLICA APOSTOLICA BRASILEIRA
*     13 CATOLICA ORTODOXA
*     14 ORTODOXA CRISTA
*     19 OUTRAS CATOLICAS
* PROTESTANTES RAIZ
* 2 - 21 EVANGELICA DE MISSAO LUTERANA
*     22 EVANGELICA DE MISSAO PRESBITERIANA
*     23 EVANGELICA DE MISSAO METODISTA
*     24 EVANGELICA DE MISSAO BATISTA
*     25 EVANGELICA DE MISSAO CONGREGACIONAL
*     26 EVANGELICA DE MISSAO ADVENTISTA
*     27 EVANGELICA DE MISSAO EPISCOPAL ANGLICANA
*     28 EVANGELICA DE MISSAO MENONITA
* PROTESTANTES TARDIOS
* 3 - 30 EXERCITO DA SALVAcAO & EVANGELICA DE ORIGEM PENTECOSTAL
* 4 - 40 EVANGELICA RENOVADA NAO DETERMINADA
* 5 - 51 IGREJA DE JESUS CRISTO DOS SANTOS DOS uLTIMOS DIAS
* 9 - 99 NAO SABIAM E SEM DECLARAcAO
* 0 - 00 SEM RELIGIAO
*     000 Sem religiao
*     001 Agnostico
*     002 Ateu

* 0 - Sem religião
clonevar  sem_religiao = religiao_geral
replace   sem_religiao=999 if sem_religiao !=0
replace   sem_religiao=1 if sem_religiao ==0 
replace   sem_religiao=0 if sem_religiao ==999 
label var sem_religiao "sem religioes 1, outras 0"

* 1 - Católicas
clonevar  catolica = religiao_geral
replace   catolica=0 if catolica !=1
label var catolica "religioes catolicas 1, outras 0"

* 2 - Protestantes 
clonevar  protestantes = religiao_geral
replace   protestantes = 0 if protestantes !=2
replace   protestantes = 1 if protestantes ==3 
replace   protestantes = 0 if protestantes ==2
label var protestantes "religioes protestantes 1, outras  0"

* Protestantes Raiz (ou seja, os primeiros protestantes)
* 2 - 21 EVANGELICA DE MISSAO LUTERANA
*     22 EVANGELICA DE MISSAO PRESBITERIANA
*     23 EVANGELICA DE MISSAO METODISTA
*     24 EVANGELICA DE MISSAO BATISTA
*     25 EVANGELICA DE MISSAO CONGREGACIONAL
*     26 EVANGELICA DE MISSAO ADVENTISTA (Posteriormente sera excluida)
*     27 EVANGELICA DE MISSAO EPISCOPAL ANGLICANA
*     28 EVANGELICA DE MISSAO MENONITA (Posteriormente sera excluida)

* Gerar variavel com os grupos de religião com os dois primeiros digitos
gen   religiao_geral2 = substr(str_v6121,1,2)
order religiao_geral2, before(str_v6121)
tab   religiao_geral2

* Converter de string para numeric
destring religiao_geral2, replace 

* 21 Evangélica de missão Luterana 
clonevar  luterana = religiao_geral2
replace   luterana = 999 if luterana ==1
replace   luterana =   1 if luterana ==21
replace   luterana =   0 if luterana !=1
label var luterana "EVANGELICA DE MISSAO LUTERANA 1, outras  0"

* 22 Evangélica de missão Presbiteriana
clonevar  presbiteriana = religiao_geral2
replace   presbiteriana = 999 if presbiteriana ==1
replace   presbiteriana =   1 if presbiteriana ==22
replace   presbiteriana =   0 if presbiteriana !=1
label var presbiteriana "EVANGELICA DE MISSAO PRESBITERIANA 1, outras 0"

* 23 Evangélica de missão Metodista
clonevar  metodista = religiao_geral2
replace   metodista = 999 if metodista ==1
replace   metodista =   1 if metodista ==23
replace   metodista =   0 if metodista !=1
label var metodista "EVANGELICA DE MISSAO METODISTA 1, outras 0"

* 24 Evangélica de missão Batista
clonevar  batista = religiao_geral2
replace   batista = 999 if batista ==1
replace   batista =   1 if batista ==24
replace   batista =   0 if batista !=1
label var batista "EVANGELICA DE MISSAO BATISTA 1, outras 0"

* 25 Evangélica de missão Congrecional
clonevar  congregacional = religiao_geral2
replace   congregacional = 999 if congregacional ==1
replace   congregacional =   1 if congregacional ==25
replace   congregacional =   0 if congregacional !=1
label var congregacional "EVANGELICA DE MISSAO CONGREGACIONAL 1, outras 0"

* 26 Evangélica de missão Adventista (Posteriormente será excluida)
clonevar  adventista = religiao_geral2
replace   adventista = 999 if adventista ==1
replace   adventista =   1 if adventista ==26
replace   adventista =   0 if adventista !=1
label var adventista "EVANGELICA DE MISSAO ADVENTISTA 1, outras 0"

* 27 Evangélica de missão Episcopal Anglicana 
clonevar  anglicana = religiao_geral2
replace   anglicana = 999 if anglicana ==1
replace   anglicana =   1 if anglicana ==27
replace   anglicana =   0 if anglicana !=1
label var anglicana "EVANGELICA DE MISSAO EPISCOPAL ANGLICANA 1, outras 0"

* 28 Evangélica de missão Menonita (Posteriormente sera excluida)
clonevar  menonita = religiao_geral2
replace   menonita = 999 if menonita ==1
replace   menonita =   1 if menonita ==28
replace   menonita =   0 if menonita !=1
label var menonita "EVANGELICA DE MISSAO MENONITA  1, outras 0"

* Ateus
clonevar ateu = v6121
destring ateu, replace
replace  ateu=0 if ateu !=002
replace  ateu=1 if ateu ==002
label var ateu "somente ateus 1, outras 0"

* Protestantes Raiz (Os primeiros protestantes)
clonevar  protestantes_raiz = religiao_geral2
replace   protestantes_raiz = 999 if protestantes_raiz ==1
recode    protestantes_raiz   (21/25=1)
recode    protestantes_raiz   (27=1)
replace   protestantes_raiz = 0 if protestantes_raiz !=1


*------------------------------------*
//   Gerar variáveis de Resultados  //
*------------------------------------*

* v0648 Nesse trabalho era:
* 1 - Empregado com carteira de trabalho assinada 
* 2 - Militar do exErcito, marinha, aeronAutica, policia militar ou corpo de bombeiros
* 3 - Empregado pelo regime juridico dos funcionArios publicos
* 4 - Empregado sem carteira de trabalho assinada
* 5 - Conta propria
* 6 - Empregador
* 7 - NAo remunerado
* Branco

* 5 - Conta própria
clonevar  conta_prop = v0648
replace   conta_prop = 0 if conta_prop !=5
replace   conta_prop = 1 if conta_prop ==5
label var conta_prop "Conta propria 1, outras 0"

* 6 - Empregador
clonevar  empregador = v0648
replace   empregador = 0 if empregador !=6
replace   empregador = 1 if empregador ==6
label var empregador "Empregador 1, outras 0"

* 5 + 6 = Empreendedor (Conta própria + Empregador)
gen empreendedor = conta_prop + empregador

* Empregado com carteira assinada
clonevar  Empre_comCarteira = v0648
replace   Empre_comCarteira = 0 if Empre_comCarteira !=1
label var Empre_comCarteira "Empregado com Carteira 1, empreendedor 0"

* Empregado sem carteira assinada
clonevar  Empre_semCarteira = v0648
replace   Empre_semCarteira = 999 if Empre_semCarteira ==1
replace   Empre_semCarteira = 1 if Empre_semCarteira ==4
replace   Empre_semCarteira = 0 if Empre_semCarteira !=1
label var Empre_semCarteira "Empregado sem Carteira 1, empreendedor 0"

* v0645 – Quantos trabalhos tinha
* 1 - um emprego (apenas um emprego) 
clonevar  um_emprego = v0645
replace   um_emprego = 99 if um_emprego!=1
replace   um_emprego = 0 if um_emprego==2
replace   um_emprego = 0 if um_emprego==99
label var um_emprego "tem um emprego 1, mais de um emprego 0"

* 2 - mais de um
clonevar  maisdeum_emprego = v0645
replace   maisdeum_emprego = 0 if maisdeum_emprego==1
replace   maisdeum_emprego = 1 if maisdeum_emprego==2
replace   maisdeum_emprego = 0 if maisdeum_emprego!=1
label var maisdeum_emprego "mais de um emprego 1, mais de um emprego 0"

* v0653 - No trabalho principal, quantas horas trabalhava habitualmente por semana
clonevar horas_trab = v0653

* v6633 total de filhos nascidos vivos 
clonevar total_filhos = v6643

*nesse caso 0 sao pessoas que o filho morreu, e missings sao pessoas que nao tiveram filhos
replace   total_filhos=0 if total_filhos==.

* v6461 - ocupacoes
tostring v6461, replace
gen ocupacao = substr(v6461,1,1)
destring ocupacao, replace 
tab ocupacao

** 1 DIRETORES E GERENTES
** 2 PROFISSIONAIS DAS CIENCIAS E INTELECTUAIS
** 3 TECNICOS E PROFISSIONAIS DE NIVEL MEDIO
** 4 TRABALHADORES DE APOIO ADMINISTRATIVO
** 5 TRABALHADORES DOS SERVICOS, VENDEDORES DOS COMERCIOS E MERCADOS
** 6 TRABALHADORES QUALIFICADOS DA AGROPECUARIA, FLORESTAIS, DA CACA E DA PESCA
** 7 TRABALHADORES QUALIFICADOS, OPERARIOS E ARTESAOS DA CONSTRUCAO, DAS ARTES MECANICAS E OUTROS OFiCIOS
** 8 OPERADORES DE INSTALACOES E MAQUINAS E MONTADORES
** 9 OCUPACOES ELEMENTARES
** 0 MEMBROS DAS FORCAS ARMADAS, POLICIAIS E BOMBEIROS MILITARES
* 00 -> 97 "OCUPACOES MALDEFINIDAS

* 1 Diretores e Gerentes
clonevar  diretores_gerentes = ocupacao
replace   diretores_gerentes = 0 if diretores_gerentes !=1
label var diretores_gerentes "diretores e dirigentes 1, outras 0"

* v0657 Em julho de 2010, tinha rendimento mensal habitual de Programa
* Social Bolsa Familia ou Programa de ErradicacAo do Trabalho Infantil PETI
* 1 - Sim
* 0 – NAo
* 9 – Ignorado 
* Branco
clonevar  rend_social = v0657
replace   rend_social = 0 if rend_social==9
replace   rend_social = 0 if rend_social==.
label var rend_social "se tinha rendimento Bolsa Familia ou outro se SIM 1, outras  0"

* v0659 Em julho de 2010, tinha rendimento mensal habitual de outras
* fontes (juros de poupanca, aplicacOes financeiras, aluguel, pensAo ou
* aposentadoria de previdencia privada, etc.)
* 1 - Sim
* 0 – Nao
* 9 – Ignorado 
* Branco
clonevar  rend_aplicacoes = v0659
replace   rend_aplicacoes = 0 if rend_aplicacoes==9
replace   rend_aplicacoes = 0 if rend_aplicacoes==.
label var rend_aplicacoes "tinha rendimento mensal habitual de poupanca e outros se SIM  1, outras  0"

* V6511 - Valor do rendimento bruto (ou retirada) mensal no trabalho principal
clonevar rendimento_principal = v6511
replace  rendimento_principal = 0 if rendimento_principal==.

*V6525 - Rendimento em todos os trabalhos, em reais
clonevar rendimentos_totais = v6525
replace  rendimentos_totais = 0 if rendimentos_totais==.

* V6529 – Rendimento domiciliar (domicilio particular) em julho de 2010, em reais
clonevar rendimento_domiciliar = v6529
replace  rendimento_domiciliar = 0 if rendimento_domiciliar==.

* V6531 – Rendimento domiciliar (domicilio particular) per capita em julho de 2010, em reais
clonevar rendimento_domiciliar_pc = v6531
replace  rendimento_domiciliar_pc = 0 if rendimento_domiciliar_pc==.

* v0653 horas no trabalho principal
clonevar hrs_trab_princ = v0653
replace  hrs_trab_princ = 0 if hrs_trab_princ==.

* salário por hora
gen      salario_porhora = rendimento_principal / (hrs_trab_princ *4.333)
replace  salario_porhora = 0 if salario_porhora==.

* V0645 – Quantos trabalhos tinha
clonevar quantos_trabalhos = v0645
replace  quantos_trabalhos = 0 if quantos_trabalhos==.

* v0639 Natureza da união
* 1 - Casamento civil e religioso
* 2 - So casamento civil 
* 3 - So casamento religioso
* 4 - Uniao consensual
* Branco para: Os menores de 10 anos de idade; Nao vive em companhia de conjuge 
*ou companheiro(a) mas ja viveu antes; ou Nunca viveu em companhia de conjuge

clonevar  civil_religioso = v0639
replace   civil_religioso=0 if (civil_religioso==2 | civil_religioso==4)
replace   civil_religioso=1 if (civil_religioso==3)
replace   civil_religioso=0 if (civil_religioso==.)
label var civil_religioso "Casamento civil e religioso e somente religioso 1; cc 0"

* V0640 – Estado civil
/* Utilizar essa para ver se tem efeito nos divorcios.
Criar uma dummy para casados e umas dummy para divorciado/separado (desquite, separado e divorciado) */
* 1 = Casado
* 2 = Desquitado(a) ou separado(a) judicialmente: Para a pessoa que tenha o estado civil de desquitada ou separada judicialmente, homologado por decisAo judicial
* 3 = Divorciado(a): Para a pessoa que tenha o estado civil de divorciada, homologado por decisAo judicial
* 4 = Viuvo(a): Para pessoa que tenha o estado civil de viuva
* 5 = Solteiro(a): Para pessoa que tenha o estado civil de solteira
* Branco = menores de 10 anos de idade

clonevar  D_divorciado = v0640
replace   D_divorciado = 0 if (D_divorciado==1 | D_divorciado==4 | D_divorciado==5)
replace   D_divorciado = 1 if (D_divorciado==2 | D_divorciado==3)
replace   D_divorciado = 0 if  D_divorciado==.
label var D_divorciado "Divorciado e separado 1, cc 0"

* v0502 - Relacão de parentesco com a pessoa responsável pelo domicílio
/* Utilizar essa para ver os que ainda moram com os pais
Criar uma dummy para os que moram com os pais ou com os sogros */
* 1  = Pessoa responsavel pelo domicilio: * 2  = Conjuge ou companheiro(a) de sexo diferente
* 3  = Conjuge ou companheiro(a) do mesmo sexo: * 4  = Filho(a) do responsavel e do conjuge:  
* 5  = Filho(a) somente do responsavel: * 6  = Enteado(a): * 7  = Genro ou nora:
* 8  = Pai, mae, padrasto ou madrasta   * 9  = Sogro(a):   * 10 = Neto(a): * 11 = Bisneto(a): 
* 12 = Irmao ou irma * 13 = Avo ou avo: * 14 = Outro parente: * 15 = Agregado(a): 
* 16 = Convivente * 17 = Pensionista:   * 18 = Empregado(a) domestico(a
* 19 = Parente do(a) empregado(a) domestico(a): * 20 = Individual em domicilio coletivo: 

clonevar D_mora_pais = v0502
replace  D_mora_pais = 99 if D_mora_pais==1            
recode    D_mora_pais   (4/6=1)
replace  D_mora_pais = 0 if D_mora_pais!=1  


*-----------------------*
//   Gerar Covariadas  //
*-----------------------*

* UF - Unidades da Federacao
gen long UF = floor(id_municipio/100000)

* Gerar dummies de UF
tabulate UF, generate(uf)

* v0601 – Sexo 
*1 = Masculino
*2 = Feminino
clonevar  sexo = v0601
replace   sexo = 0 if sexo==2
replace   sexo = 0 if sexo==.
label var sexo "Masculino 1, Feminino 0"

* v0606 – Cor 
*1 = Branca
*2 = Preta
*3 = Amarela
*4 = Parda
*5 = Indigena
*9 = Ignorado (missings)

*1 = Branca & 3 = Amarela (BRANCOS)
clonevar  branco = v0606
replace   branco = 1 if branco ==3
replace   branco = 0 if branco !=1
replace   branco = 0 if branco ==.
label var branco "se E branco e amarelo 1, cc 0"

* v6036 – Idade calculada em anos:
clonevar idade = v6036
drop if idade==.

* v1006 – Situação do domicílio (urbano ou rural)
*1 = Urbana
*2 = Rural
clonevar  urbano = situacao_domicilio
replace   urbano = 0 if urbano==2
label var urbano "se o domicilio E urbano 1, cc 0"

* v6400 – Nivel de instrução
*1 – Sem instrucAo e fundamental incompleto
*2 – Fundamental completo e medio incompleto
*3 – Medio completo e superior incompleto
*4 – Superior completo
*5 – Nao determinado (esse nao precisa)

*1 – Sem instrução e fundamental incompleto
clonevar  fund_incom = v6400
replace   fund_incom = 0 if fund_incom !=1
replace   fund_incom = 0 if fund_incom ==.
label var fund_incom "Sem instrucAo e fundamental incompleto 1, outras 0"

*2 – Fundamental completo e médio incompleto
clonevar  fund_comp = v6400
replace   fund_comp = 0 if fund_comp !=2
replace   fund_comp = 1 if fund_comp ==2
replace   fund_comp = 0 if fund_comp ==.
label var fund_comp "Fundamental completo e mEdio incompleto 1, outras 0"

*3 – Médio completo e superior incompleto
clonevar  medio_comp = v6400
replace   medio_comp = 0 if medio_comp !=3
replace   medio_comp = 1 if medio_comp ==3
replace   medio_comp = 0 if medio_comp ==.
label var medio_comp "MEdio completo e superior incompleto 1, outras 0"

*4 – Superior completo
clonevar  sup_comp = v6400
replace   sup_comp = 0 if sup_comp !=4
replace   sup_comp = 1 if sup_comp ==4
replace   sup_comp = 0 if sup_comp ==.
label var sup_comp "Superior completo 1, outras 0"

* v0635 – Especie do curso mais elevado concluido
*1 - superior de graduacAo
*2 - mestrado 
*3 - doutorado 

*2 – Mestrado
clonevar  mestr_comp = v0635
replace   mestr_comp = 0 if mestr_comp !=2
replace   mestr_comp = 1 if mestr_comp ==2
replace   mestr_comp = 0 if mestr_comp ==.
label var mestr_comp "mestrado completo 1, outras 0"

*3 – Doutorado
clonevar  doc_comp = v0635
replace   doc_comp = 0 if doc_comp !=3
replace   doc_comp = 1 if doc_comp ==3
replace   doc_comp = 0 if doc_comp ==.
label var doc_comp "doutorado completo 1, outras 0"

* Pos_graduacão (mestrado e doutorado)
gen pos_graduacao =0
replace pos_graduacao =1 if mestr_comp==1
replace pos_graduacao =1 if doc_comp ==1
replace pos_graduacao = 0 if pos_graduacao ==.

* v0627 Sabe ler e escrever 
* 1 = Sim
* 2 = Não

* Branco: para as pessoas menores de 5 anos de idade.
clonevar  analfabeto = v0627
replace   analfabeto = 0 if analfabeto==1
replace   analfabeto = 0 if analfabeto==.
replace   analfabeto = 1 if analfabeto==2
label var analfabeto "se nAo sabe ler e escrever 1, cc 0"

* v1004 se mora em região metropolitana (capital)
clonevar  capital = id_regiao_metropolitana
destring  capital , replace
recode    capital   (1/42=1)
replace   capital = 0 if capital==00
label var capital  "se mora na capital 1, cc 0"

* v6352 Área do curso de formação superior
*  2	HUMANIDADES E ARTES
*  - 21	ARTES
*      210	ARTES (CURSO GERAIS)
*      211	BELAS ARTES
*      212	MUSICA E ARTES CENICAS
*      213	TECNICAS AUDIOVISUAIS E PRODUCAO DE MIDIA
*      214	DESIGN E ESTILISMO
*      215	ARTESANATO
*  - 22	HUMANIDADES E LETRAS
*      220	HUMANIDADES E LETRAS (CURSO GERAIS)
*      221	RELIGIAO
*      222	LINGUAS E CULTURAS ESTRANGEIRAS
*      223	LINGUA MATERNA (VERNACULA)
*      225	HISTORIA E ARQUEOLOGIA
*      226	FILOSOFIA E ETICA
	
clonevar artes_humanidades = v6352
destring artes_humanidades, replace 
replace  artes_humanidades = 1 if (artes_humanidades == 210 | artes_humanidades == 211 ///
      | artes_humanidades == 212 | artes_humanidades == 213 | artes_humanidades == 214 ///
      | artes_humanidades == 215 | artes_humanidades == 220 | artes_humanidades == 222 ///
      | artes_humanidades == 221 | artes_humanidades == 223 | artes_humanidades == 225 ///
      | artes_humanidades == 226)        
replace  artes_humanidades = 0 if artes_humanidades !=1
label var artes_humanidades "artes_humanidades 1, cc 0"

*----------------------------------*
//   Renomear e dropar variáveis  //
*----------------------------------*
* Renomear
ren peso_amostral peso_svy
ren area_ponderacao strat
ren controle psu

* Dropar variáveis
drop  v0502 v0601 v6033 v6036 v6037 v6040 v0606 v0613 v0614 v0615 v0616 v0617 v0618 v0619 v0620 v0621 v0622 v6222 v6224 v0623 v0624 v0625 v6252 v6254 v6256 v0626 v6262 v6264 v6266 v0627 v0628 v0629 v0630 v0631 v0632 v0633 v0634 v0635 v6400 v6352 v6354 v6356 v0636 v6362 v6364 v6366 v0637 v0638 v0639 v0640 v0641 v0642 v0643 v0644 v0645 v6461 v6471 v0648 v0649 v0650 v0651 v6511 v6513 v6514 v0652 v6521 v6524 v6525 v6526 v6527 v6528 v6529 v6530 v6531 v6532 v0653 v0654 v0655 v0656 v0657 v0658 v0659 v6591 v0660 v6602 v6604 v6606 v0661 v0662 v0663 v6631 v6632 v6633 v0664 v6641 v6642 v6643 v0665 v6660 v6664 v0667 v0668 v6681 v6682 v0669 v6691 v6692 v6693 v6800 v0670 v0671 v6900 v6910 v6920 v6930 v6940 v6121 v0604 v0605 v5020 v5060 v5070 v5080 v6462 v6472 v5110 v5120 v5030 v5040 v5090 v5100 v5130 m0502 m0601 m6033 m0606 m0613 m0614 m0615 m0616 m0617 m0618 m0619 m0620 m0621 m0622 m6222 m6224 m0623 m0624 m0625 m6252 m6254 m6256 m0626 m6262 m6264 m6266 m0627 m0628 m0629 m0630 m0631 m0632 m0633 m0634 m0635 m6352 m6354 m6356 m0636 m6362 m6364 m6366 m0637 m0638 m0639 m0640 m0641 m0642 m0643 m0644 m0645 m6461 m6471 m0648 m0649 m0650 m0651 m6511 m0652 m6521 m0653 m0654 m0655 m0656 m0657 m0658 m0659 m6591 m0660 m6602 m6604 m6606 m0661 m0662 m0663 m6631 m6632 m6633 m0664 m6641 m6642 m6643 m0665 m6660 m0667 m0668 m6681 m6682 m0669 m6691 m6692 m6693 m0670 m0671 m6800 m6121 m0604 m0605 m6462 m6472 v4001 v4002 v0201 v2011 v2012 v0202 v0203 v6203 v0204 v6204 v0205 v0206 v0207 v0208 v0209 v0210 v0211 v0212 v0213 v0214 v0215 v0216 v0217 v0218 v0219 v0220 v0221 v0222 v0301 v0401 v0402 v0701 v6600 v6210 m0201 m02011 m0202 m0203 m0204 m0205 m0206 m0207 m0208 m0209 m0210 m0211 m0212 m0213 m0214 m0215 m0216 m0217 m0218 m0219 m0220 m0221 m0222 m0301 m0401 m0402 m0701 clone_v6121 str_v6121
 
* Salvando sample2 (protestantes_raiz vs todoas as outras religiões)
save "D:\PAPER_RELIGION\DADOS\sample2.dta", replace

* Gerar Sample_1 (protestantes_raiz vs católicos)
gen sample1 = catolica + protestantes_raiz
drop if sample1 == 0

* Salvando sample1
save "D:\PAPER_RELIGION\DADOS\sample1.dta", replace

*-------------------------------------------------------------------------------
********************************************************************************
//                      ESTIMAÇÕES (OLS PSW PSM)                              //
********************************************************************************
*-------------------------------------------------------------------------------

* Limpar tudo
clear all

* Carregando sample1 (protestantes_raiz vs catolicos)
use "D:\PAPER_RELIGION\DADOS\sample1.dta"

* Definir pasta de trabalho
cd "D:\PAPER_RELIGION\RESULTADOS_SAMPLE1"

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 

*----------------------------------------------*
// ESTATISTICAS DESCRITIVAS COM PESO AMOSTRAL // 
*----------------------------------------------*

//  Descritivas com pesos
asdoc summarize $var_dependente $covariadas1 [iweight = peso_svy], append title(Descritiva com pesos amostrais) save(Descritivas.rtf) fs(10) dec(3) tzok


// Balanço das Covariadas
foreach var of varlist $covariadas1 {
svy: mean `var', over(protestantes_raiz)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_OLS Sample_1.doc", title(Balanco_OLS Sample_1) ctitle(`var')  addstat(lincom_p>|t|, `r(p)') noaster
}

// Outra maneira de fazer o balanço das covariadas

* Balanço covariadas (sem pesos)
asdoc pstest $covariadas1 , raw treat(protestantes_raiz), replace title(T-test sem pesos) save(Balanço_covariadas_1.rtf) fs(10) dec(3) tzok

* Balanço covariadas (com pesos)
asdoc pstest $covariadas1 , treat(protestantes_raiz) mw(peso_svy), append title(T-test com pesos) save(Balanço_covariadas_1.rtf) fs(10) dec(3) tzok


********************************************************************************
//                                OLS SURVEY                                  //
********************************************************************************
*Nota: svy: não permite erros robustos

// Regressões 
foreach var of varlist $var_dependente {
svy: reg `var' protestantes_raiz $covariadas2 
estimates store `var'
esttab `var' using "OLS_SURVEY Sample_1.rtf", title(var `var') b(%12.2f) se(2) keep(protestantes_raiz) star(* 0.10 ** 0.05 *** 0.01 ) append
}

*-----------------*
// GERAR GRÁFICO //
*-----------------*

* Clonar pesos
gen W_svy = peso_svy

* Gerar gráfico
twoway (kdensity W_svy if protestantes_raiz==1) (kdensity W_svy if protestantes_raiz==0, lpattern(dash)), legend(label(1 "treated") label(2 "control")) xtitle("Default Sample_1")
graph export "D:\PAPER_RELIGION\RESULTADOS_SAMPLE1\grafico PSM `data' Sample_1.pdf", as(pdf) replace


********************************************************************************
//                                 PSW SURVEY                                 //
********************************************************************************

* Limpar tudo
clear all

* Carregando sample1 (protestantes_raiz vs católicos)
use "D:\PAPER_RELIGION\DADOS\sample1.dta"

* Definir pasta de trabalho
cd "D:\PAPER_RELIGION\RESULTADOS_SAMPLE1" 

*Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Gerar pesos
probit  protestantes_raiz $covariadas2  
predict peso_probit                     
gen     W1 = 1 / peso_probit
replace W1 = 0 if protestantes_raiz == 0
gen     W2 = 1/( 1- peso_probit)
replace W2 = 0 if protestantes_raiz == 1
gen     W_ATE  = W1 + W2                        // peso ATE  (Average Treatment Effect)
gen     W_ATET = peso_probit /( 1- peso_probit) // peso ATET (Average Treatment Effect on Treated)
replace W_ATET = 1 if protestantes_raiz == 1
gen     peso_1 = W_ATE * peso_svy  // ATE SVY
gen     peso_2 = W_ATET * peso_svy // ATET SVY

* Declarar plano amostral com peso ATET SVY
svyset [pweight=peso_2], strata(strat) vce(linearized) singleunit(centered) 

* Balanço das covariadas
foreach var of varlist $covariadas1 {
svy: mean `var', over(protestantes_raiz)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSW Sample_1.doc", title(Balanco_PSW Sample_1) ctitle(`var')  addstat(lincom_p>|t|, `r(p)') noaster
}

* Regressões
foreach var of varlist $var_dependente {
svy: reg `var' protestantes_raiz $covariadas2 
estimates store `var'
esttab `var' using "PSW_SURVEY Sample_1.rtf", title(var `var') b(%12.2f) se(2) keep(protestantes_raiz) star(* 0.10 ** 0.05 *** 0.01 ) append
}

* Gerar gráfico (comparaçãoentre entre tratados e controles)
* Gerar pesos
gen W_psw = peso_2 

* Gerar gráfico
twoway (kdensity W_psw if protestantes_raiz==1) (kdensity W_psw if protestantes_raiz==0, lpattern(dash)), legend(label(1 "treated") label(2 "control")) xtitle("PSW Sample_1")
graph export "D:\PAPER_RELIGION\DADOS\sample1\resultados\grafico PSM `data' Sample_1.pdf", as(pdf) replace

********************************************************************************
//                        PSM SURVEY  (PROTESTANTES)                          //
********************************************************************************

* Existem diversos pacotes que fazem PSM, porém como estamos trabalhando com uma 
*amostra complexa, devemos considerar esse peso amostral no matching.

* Limpar tudo
clear all

* Carregando sample1 (protestantes_raiz vs catolicos)
use "D:\PAPER_RELIGION\DADOS\sample1.dta"

* Definir pasta de trabalho
cd "D:\PAPER_RELIGION\RESULTADOS_SAMPLE1" 

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variáveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Estimando os pesos com Probit e svy que vamos utilizar no pacote psmatch2 para fazer o psm
svy: probit protestantes_raiz $covariadas2  
predict W_probit

* Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando e salvando as bases PSM com 1 vizinho mais proximo sem reposição
foreach var of varlist $var_dependente {
psmatch2 protestantes_raiz, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep = `var' //esse comando vai facilitar o comando das regressoes
save "D:\PAPER_RELIGION\DADOS\_`var'.dta"
drop var_dep _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}


* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}


*-----------------*
//   REGRESSÕES  //
*-----------------*

* Balanço das covariadas
clear all 
local workdir "D:\PAPER_RELIGION\DADOS"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(protestantes_raiz)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* Estimando PSM-SVY somente com os individuos que deram Matching
clear all
local workdir "D:\PAPER_RELIGION\DADOS"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep protestantes_raiz $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1.rtf", b(%12.2f) se(2) keep(protestantes_raiz) title(`data' Sample_1) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}

* Gerar gráficos (comparacao entre tratados e controles para cada base)
clear all
local workdir "D:\PAPER_RELIGION\DADOS"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
twoway (kdensity _pscore if _treated==1) (kdensity _pscore if _treated==0, lpattern(dash)), legend(label(1 "treated") label(2 "control")) xtitle("PSM Sample_1")
graph export "D:\PAPER_RELIGION\DADOS\grafico PSM `data' Sample_1.pdf", as(pdf) replace
clear all
}


*-------------------------------------------------------------------------------
********************************************************************************
//                          TRATAMENTO PLACEBO                                //
********************************************************************************
*-------------------------------------------------------------------------------

* Sample1 (Base 1) 
use "D:\PAPER_RELIGION\DADOS\sample1.dta"

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Ver proporções de protestantes_raiz
svy: tab protestantes_raiz

* Criando o placebo_sample1
*primeiro temos que verificar a proporção de tratados, ou seja dos protestantes_raiz
* 0 | 95.3%  
* 1 |  4.7% ou seja, 0.047    

* Gerar placebo aleatório 
set seed 123456789
gen newaleat = runiform()
gen     placebo_sample1   = 0
recode  placebo_sample1 0 = 1 if newaleat <= 0.047 
save "D:\PAPER_RELIGION\DADOS\sample1.dta", replace
*-------------------------------------------------------------------------------

* Sample2 (Base 2) 
use "D:\PAPER_RELIGION\DADOS\sample2.dta"

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Ver proporções de protestantes_raiz
svy: tab protestantes_raiz
*criando o placebo_sample2
*   0 | 96.79% 
*   1 | 3.21%  ou seja, 0.0321

* Gerar placebo aleatório 
set seed 123456789 
gen newaleat = runiform()
gen     placebo_sample2   = 0
recode  placebo_sample2 0 = 1 if newaleat <= 0.0321
save "D:\PAPER_RELIGION\DADOS\sample2.dta", replace

*-------------------------------------------------------------------------------

* Carregando a base - Sample1 (protestantes_raiz vs católicos)
use "D:\PAPER_RELIGION\DADOS\sample1.dta"

* Definindo pasta de trabalho
cd  "D:\PAPER_RELIGION\DADOS\placebo_sample1" 

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variáveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos


********************************************************************************
//                           OLS SURVEY (PLACEBO)                             //
********************************************************************************

* Balanço das covariadas
foreach var of varlist $covariadas1 {
svy: mean `var', over(placebo_sample1)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_OLS placebo_sample1.doc", title(Balanco placebo_sample1) ctitle(`var')  addstat(lincom_p>|t|, `r(p)') noaster
}

* Regressões
foreach var of varlist $var_dependente {
svy: reg `var' placebo_sample1 $covariadas2 //[SVY: nao permite erros robustos]
estimates store `var'
esttab `var' using "OLS_SURVEY placebo_sample1.rtf", b(%12.2f) se(2) keep(placebo_sample1) star(* 0.10 ** 0.05 *** 0.01 ) append
}

* Gerar gráfico 
gen W_svy = peso_svy
twoway (kdensity W_svy if placebo_sample1==1) (kdensity W_svy if placebo_sample1==0, lpattern(dash)), legend(label(1 "treated") label(2 "control")) xtitle("placebo_Default_sample1")
graph export "D:\PAPER_RELIGION\DADOS\grafico PSM `data' placebo_sample1.pdf", as(pdf) replace


********************************************************************************
//                           PSW SURVEY (PLACEBO)                             //
********************************************************************************

* Sample1
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\placebo_sample1"

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

probit  placebo_sample1 $covariadas2   //*OBS: nao faz diferenca usar robust no probit da o mesmo resultado
predict peso_probit                    // esse e o mesmo _pscore gerado pelo psmatch2 "_pscore"
gen     W1 = 1 / peso_probit
replace W1 = 0 if placebo_sample1 == 0
gen     W2 = 1/( 1- peso_probit)
replace W2 = 0 if placebo_sample1 == 1
gen     W_ATE  = W1 + W2                        // peso para ATE (Average Treatment Effect)
gen     W_ATET = peso_probit /( 1- peso_probit) // peso para ATET (Average Treatment Effect on Treated)
replace W_ATET = 1 if placebo_sample1 == 1
gen     peso_1 = W_ATE  * peso_svy // para ATE
gen     peso_2 = W_ATET * peso_svy // para ATET

* Declarar plano amostral com peso do PSW ATET
svyset [pweight=peso_2], strata(strat) vce(linearized) singleunit(centered) 

* Balanço das covariadas
foreach var of varlist $covariadas1 {
svy: mean `var' , over(placebo_sample1)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSW placebo_sample1.doc", title(Balanco placebo_sample1) ctitle(`var') addstat(lincom_p>|t|, `r(p)') noaster
}

* Regressões
foreach var of varlist $var_dependente {
svy: reg `var' placebo_sample1 $covariadas2 
estimates store `var'
esttab `var' using "PSW_SURVEY placebo_sample1.rtf", b(%12.2f) se(2) keep(placebo_sample1) star(* 0.10 ** 0.05 *** 0.01 ) append
}

* Gerar gráfico
gen W_psw = peso_2
twoway (kdensity W_psw if placebo_sample1==1) (kdensity W_psw if placebo_sample1==0, lpattern(dash)), legend(label(1 "treated") label(2 "control")) xtitle("PSW placebo_sample1")
graph export "D:\PAPER_RELIGION\DADOS\Graph placebo_sample1 PSW.pdf", as(pdf) replace

********************************************************************************
//                           PSM SURVEY (PLACEBO)                             //
********************************************************************************

* Sample1
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\placebo_sample1" 

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Estimando o probit com svy para gerar o novo peso para utlizar no psmatch2
svy: probit placebo_sample1 $covariadas2  
predict W_probit

*declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando as bases com PSM (1 vizinho mais proximo sem reposicao)
foreach var of varlist $var_dependente {
psmatch2 placebo_sample1, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep2 = `var' 
save "D:\PAPER_RELIGION\DADOS\placebo_`var'.dta"
drop var_dep2 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS\placebo_sample1"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}

* Balanço das covariadas 
clear all
local workdir "D:\PAPER_RELIGION\DADOS\placebo_sample1"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(placebo_sample1)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM placebo_sample1 `data'.doc", title(Balanco Covariadas PSM placebo_sample1) ctitle(`var') addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* Estimando somente com os individuos que deram matching
clear all
local workdir "D:\PAPER_RELIGION\DADOS\placebo_sample1"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep2 placebo_sample1 $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY placebo_sample1.rtf", b(%12.2f) se(2) keep(placebo_sample1) title(`data') star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}

* Gerar gráficos
clear all
local workdir "D:\PAPER_RELIGION\DADOS\placebo_sample2"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
twoway (kdensity _pscore if _treated==1) (kdensity _pscore if _treated==0, lpattern(dash)), legend(label(1 "treated") label(2 "control")) xtitle("PSM placebo_sample2")
graph export "D:\PAPER_RELIGION\DADOS\grafico PSM placebo_sample2 `data'.pdf", as(pdf) replace
clear all
}


*-------------------------------------------------------------------------------
********************************************************************************
//                          EFEITOS HETEROGENEOS (PSM)                        //
********************************************************************************
*-------------------------------------------------------------------------------
*luterana presbiteriana metodista batista congregacional anglicana ateu sem_religiao


*------------*
// Luterana //
*------------*

clear all
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\efeitos_heterogeneos_sample1" //definindo pasta de trabalho

*Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Deixando somente luteranos e católicos
drop presbiteriana metodista batista congregacional anglicana ateu agnostico
save "D:\PAPER_RELIGION\DADOS\_luterana.dta"

* Estimando Probit com svy
svy: probit luterana $covariadas2  
predict W_probit

* Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando bases com os que deram Matching (1 vizinho mais proximo sem reposicao)
foreach var of varlist $var_dependente {
psmatch2 luterana, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep4 = `var'
save "D:\PAPER_RELIGION\DADOS\_`var'.dta"
drop var_dep4 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}


* Balanço das covariadas
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(luterana)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' luterana Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1 luterana) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* PSM
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep4 luterana $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1 luterana.rtf", b(%12.2f) se(2) keep(luterana) title(`data' Sample_1 luterana) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}


*-------------*
//  Batista  //
*-------------*

clear all
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\" 
* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Deixar batistas e católicos
drop presbiteriana metodista luterana congregacional anglicana  ateu agnostico
save "D:\PAPER_RELIGION\DADOS\_batista.dta"

* Estimando Probit com svy
svy: probit batista $covariadas2  
predict W_probit

* Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando bases com os que deram Matching (1 vizinho mais proximo sem reposicao)
foreach var of varlist $var_dependente {
psmatch2 batista, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep4 = `var'
save "D:\PAPER_RELIGION\DADOS\efeitos_heterogeneos_sample1\batista\_`var'.dta"
drop var_dep4 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}

* Balanço das covariadas
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(batista)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' batista Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1 batista) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* PSM
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep4 batista $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1 batista.rtf", b(%12.2f) se(2) keep(batista) title(`data' Sample_1 batista) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}


*-------------------*
//  Presbiteriana  //
*-------------------*
clear all
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\" 

* Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos


*vamos ficar somente com presbiterianos e catolicos
drop batista metodista luterana congregacional anglicana  ateu agnostico
save "D:\PAPER_RELIGION\DADOS\_presbiteriana.dta"

* Estimando Probit com svy
svy: probit presbiteriana $covariadas2  
predict W_probit

* Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando bases com os que deram Matching (1 vizinho mais proximo sem reposicao)
foreach var of varlist $var_dependente {
psmatch2 presbiteriana, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep4 = `var'
save "D:\PAPER_RELIGION\DADOS\_`var'.dta"
drop var_dep4 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS\presbiteriana"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}

* Balanço das covariadas
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(presbiteriana)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' presbiteriana Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1 presbiteriana) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* PSM
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep4 presbiteriana $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1 presbiteriana.rtf", b(%12.2f) se(2) keep(presbiteriana) title(`data' Sample_1 presbiteriana) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}


*---------------*
//  Metodista  //
*---------------*

clear all
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\" 

*Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Deixar Metodistas e católicos
drop batista presbiteriana luterana congregacional anglicana  ateu agnostico
save "D:\PAPER_RELIGION\DADOS\_metodista.dta"

* Estimando Probit com svy
svy: probit metodista $covariadas2  
predict W_probit

* Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando bases com os que deram Matching (1 vizinho mais proximo sem reposicao)
foreach var of varlist $var_dependente {
psmatch2 metodista, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep4 = `var'
save "D:\PAPER_RELIGION\DADOS\_`var'.dta"
drop var_dep4 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\metodista"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}

* Balanço das covariadas
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(metodista)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' metodista Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1 metodista) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* PSM
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep4 metodista $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1 metodista.rtf", b(%12.2f) se(2) keep(metodista) title(`data' Sample_1 metodista) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}


*--------------------*
//  Congregacional  //
*--------------------*

clear all
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\" 

*Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Deixar congrecionais e católicos
drop batista presbiteriana luterana metodista anglicana  ateu agnostico
save "D:\PAPER_RELIGION\DADOS\_congregacional.dta"

* Estimando Probit com svy
svy: probit congregacional $covariadas2  
predict W_probit

*Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando bases com os que deram Matching (1 vizinho mais proximo sem reposicao)
foreach var of varlist $var_dependente {
psmatch2 congregacional, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep4 = `var'
save "D:\PAPER_RELIGION\DADOS\_`var'.dta"
drop var_dep4 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}

* Balanço das covariadas
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(congregacional)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' congregacional Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1 congregacional) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* PSM
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep4 congregacional $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1 congregacional.rtf", b(%12.2f) se(2) keep(congregacional) title(`data' Sample_1 congregacional) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}


*---------------*
//  Anglicana  //
*---------------*

clear all
use "D:\PAPER_RELIGION\DADOS\sample1.dta"
cd  "D:\PAPER_RELIGION\DADOS\efeitos_heterogeneos_sample1" 

*Declarar plano amostral complexo
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

* Gerando variaveis globais ($covariadas, $var_dependente)
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
global covariadas2 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
global var_dependente rend_social diretores_gerentes conta_prop empregador Empre_comCarteira maisdeum_emprego salario_porhora rend_aplicacoes rendimento_domiciliar artes_humanidades D_mora_pais civil_religioso D_divorciado total_filhos

* Deixar Anglicanos e católicos
drop batista presbiteriana luterana congregacional metodista  ateu agnostico
save "D:\PAPER_RELIGION\DADOS\_anglicana.dta"

* Estimando Probit com svy
svy: probit anglicana $covariadas2  
predict W_probit

*Declarar plano amostral com novo peso
svyset [pweight = W_probit], strata(strat) vce(linearized) singleunit(centered) 

* Gerando bases com os que deram Matching (1 vizinho mais proximo sem reposição)
foreach var of varlist $var_dependente {
psmatch2 anglicana, pscore(W_probit) outcome(`var') neighbor(1) noreplacement
gen var_dep4 = `var'
save "D:\PAPER_RELIGION\DADOS\_`var'.dta"
drop var_dep4 _pscore _treated _support _weight _`var' _id _n1 _nn _pdif
}

* Dropando os individuos fora do suporte comum
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
gen pair     = _id if _treated==0
replace pair = _n1 if _treated==1
bysort pair: egen paircount = count(pair)
drop if paircount !=2
save, replace
}

* Balanço das covariadas
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas1 branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao 
foreach var of varlist $covariadas1 {
svy: mean `var' , over(anglicana)
lincom [`var']0 - [`var']1
outreg2 using "Balanco_Covariadas_PSM `data' anglicana Sample_1.doc", title(Balanco Covariadas PSM Sample_1) ctitle(`var' Sample_1 anglicana) addstat(lincom_p>|t|, `r(p)') noaster
}
clear all
}

* PSM
clear all
local workdir "D:\PAPER_RELIGION\DADOS\"
cd `workdir'
local files: dir "`workdir'" files "*.dta" 
foreach data of local files {
use `data',clear
svyset [pweight=W_probit], strata(strat) vce(linearized) singleunit(centered) 
global covariadas branco sexo idade urbano capital fund_incom fund_comp medio_comp sup_comp pos_graduacao i.UF 
svy: reg var_dep4 anglicana $covariadas 
estimates store Psm_reg1
esttab Psm_reg1 using "PSM_SURVEY Sample_1 anglicana.rtf", b(%12.2f) se(2) keep(anglicana) title(`data' Sample_1 anglicana) star(* 0.10 ** 0.05 *** 0.01 ) append
clear all
}


*-------------------------------------------------------------------------------
********************************************************************************
//                         ESTATISTICAS POR RELIGIÃO                          //
********************************************************************************
*-------------------------------------------------------------------------------

* Carregar base de dados
use "D:\PAPER_RELIGION\DADOS\sample2.dta", clear

* Declarar pesos amostral
svyset [pweight=peso_svy], strata(strat) vce(linearized) singleunit(centered) 

*estatisticas com svy
svy: total catolica
svy: total luterana
svy: total presbiteriana
svy: total metodista
svy: total batista
svy: total congregacional
svy: total anglicana
svy: total sem_religiao

svy: proportion catolica
svy: proportion luterana
svy: proportion presbiteriana
svy: proportion metodista
svy: proportion batista
svy: proportion congregacional
svy: proportion anglicana
svy: proportion sem_religiao
svy: proportion outros
svy: proportion espiritas
svy: proportion afro


* Estatisticas sem svy
total catolica
total luterana
total presbiteriana
total metodista
total batista
total congregacional
total anglicana
total sem_religiao

* Espíritas
clonevar espiritas = religiao_geral2
replace espiritas = 999 if espiritas == 1
replace espiritas = 1 if (espiritas == 59 | espiritas == 61)
replace espiritas = 0 if espiritas!=1
label var espiritas "espiritas e espiritualistas é 1, outras é 0"

svy: total espiritas
total espiritas

* Religiões Afro
clonevar afros = religiao_geral2
replace afros = 999 if afros == 1
replace afros = 1 if (afros == 62 | afros == 63 | afros == 64)
replace afros = 0 if afros!=1
label var afros "UMBANDA, CANDOMBLÉ, OUTRAS DECLARAÇÕES DE RELIGIOSIDADE AFRO-BRASILEIRA é 1, outras é 0"


* Outras religiões
clonevar outros = religiao_geral
replace outros = 999 if outros == 1
replace outros = 1 if (outros == 7 | outros == 8 | outros == 9)
replace outros = 0 if outros!=1

********************************************************************************
















