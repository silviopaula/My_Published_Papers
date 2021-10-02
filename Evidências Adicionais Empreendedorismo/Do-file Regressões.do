*----------------------------------------------------------------------------------------------*
// ARTIGO: EVIDÊNCIAS ADICIONAIS DA RELAÇÃO  ENTRE EMPREENDEDORISMO E  CRESCIMENTO ECONÔMICO  //
*----------------------------------------------------------------------------------------------*
// Autores: 
* Silvio da Rosa Paula; ** Daniel de Abreu Pereira Uhr; *** Júlia Gallego Ziero Uhr

// link da publicação: 
*https://online.unisc.br/seer/index.php/cepe/article/viewFile/8881/6078

*--------------------*
// Instalar pacotes //
*--------------------*
*ssc install asdoc
*net install st0085_2.pkg

*---------------------------*
// Dicionário das variável //
*---------------------------*
*Variável  Descrição 
*GDPpp     GDP per capita WBG
*GCI       Indicador de competitividade global WEF 
*TEA       Taxa de empreendedorismo em estágio inicial GEM
*TEA-N     Taxa de empreendedores por Necessidade GEM
*TEA-O     Taxa de empreendedores por Oportunidade GEM


*-------------------------------------------------------------------------------
* Carregar base de dados
use "D:\onedrive\Documentos\Emp_crescimento\Base_Empreendedorismo.dta", clear

*Definir pasta de trabalho
cd "D:\onedrive\Documentos\Emp_crescimento"

* Gerar variáveis
gen lnTEAest1 = lnTEA*estagio1
gen lnTEAest2 = lnTEA*estagio2
gen lnTEAest3 = lnTEA*estagio3

* Declarar painel de dados
xtset Code Ano

* Definindo as covariadas
global Ano 

*-----------------------------*
//      Estatisticas         //
*-----------------------------*
*Descritivas
asdoc sum lnGDPpco lnTEA lnTEAO lnTEAN lnGCI, replace title(Descritivas) save(Tabela 4.rtf) fs(10) dec(2) tzok

*Matriz de correlação
asdoc corr lnGDPpco lnTEA lnTEAO lnTEAN lnGCI, replace title(Descritivas) save(Tabela 5.rtf) fs(10) dec(2) tzok

*-----------------------------*
//   Regressões tabela 6     //
*-----------------------------*

* Todos os países
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI estagio2 estagio3 i.Ano, robust
est store reg_1

* Estágio 1
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI i.Ano if estagio1==1, robust
est store reg_2

* Estágio 2
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI i.Ano if estagio2==1, robust
est store reg_3

* Estágio 3
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI  i.Ano if estagio3==1, robust
est store reg_4

* Exportar resultados
esttab reg_1 reg_2 reg_3 reg_4 using "D:\onedrive\Documentos\Emp_crescimento\Tablea_6.rtf",  star(* 0.10 ** 0.05 *** 0.01 ) keep( lnTEA lnTEAO lnTEAN lnGCI estagio2 estagio3 _cons) b(%13.4f) se(%13.3f) mtitles("Todos os paises" "Estagio 1" "Estagio 2" "Estagio 3") compress nogap nonum obslast scalars(N r2)  lines depvars title("Tabela 6 Resultados do modelo econometrico") replace

*----------------------------------*
// Teste VIF inflator de variância 
*----------------------------------*

* Todos os países
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI estagio2 estagio3 i.Ano, robust
*rodar e salvar teste
asdoc vif, replace title(Todos os paises) save(Complemento tabela 6.rtf) fs(10) dec(2) tzok

* Estágio 1
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI i.Ano if estagio1==1, robust
*rodar e salvar teste
asdoc vif, append title(Estagio 1) save(Complemento tabela 6.rtf) fs(10) dec(2) tzok

* Estágio 2
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI i.Ano if estagio2==1, robust
*rodar e salvar teste
asdoc vif, append title(Estagio 2) save(Complemento tabela 6.rtf) fs(10) dec(2) tzok

* Estágio 3
reg lnGDPpco lnTEA lnTEAO lnTEAN lnGCI  i.Ano if estagio3==1, robust
*rodar e salvar teste
asdoc vif, append title(Estagio 3) save(Complemento tabela 6.rtf) fs(10) dec(2) tzok
*-------------------------------------------------------------------------------




