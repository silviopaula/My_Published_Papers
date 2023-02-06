
********************************************************************************
//                    PAPER EMPREENDEDORISMO SENIOR
********************************************************************************

* Editado 25/09/2021

/* Pacotes necessários
ssc install asdoc
ssc install outreg2
ssc install psmatch2
ssc install kmatch
ssc install reghdfe
*/

* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Definir uma global com todos as variaveis explicativas 
global covariadas IMLEE mulher D_branco capital ensi_fund ensi_med ensi_sup urbano renda_de_Ntrab IFDM_Educacao IFDM_EmpRenda IFDM_Saude

* Parar saber quantos milhoes de observações temos
*svy: mean IMLEE // 177,8 Mi


********************************************************************************
//                          REGRESSÕES GERAIS                                 //  
********************************************************************************

*-------------------
// CONTA-PROPRIA  //
*-------------------

* OLS - sem covariadas e peso SVY
reg conta_prop aposentado [pweight=peso_svy], cluster(id7) 
est store reg_1a

* OLS - com covariadas  e peso SVY
reg conta_prop aposentado $covariadas [pweight=peso_svy], cluster(id7)
est store reg_2a

* LOGIT - sem covariadas e peso SVY
logit conta_prop aposentado [pweight=peso_svy], cluster(id7) 
asdoc adjrr aposentado, append title('logit sem covariadas e peso SVY - conta_propria') save(Impactos_Reg_Geral_Contapropria.rtf) fs(10) dec(3) tzok 
est store reg_3a

* LOGIT - com covariadas  e peso SVY
logit conta_prop aposentado $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr aposentado, append title('logit com covariadas e peso SVY - conta_propria') save(Impactos_Reg_Geral_Contapropria.rtf) fs(10) dec(3) tzok 
est store reg_4a

* PROBIT - sem covariadas e peso SVY
probit conta_prop aposentado [pweight=peso_svy], cluster(id7) 
asdoc adjrr aposentado, append title('Probit sem covariadas e peso SVY - conta_propria') save(Impactos_Reg_Geral_Contapropria.rtf) fs(10) dec(3) tzok 
est store reg_5a

* PROBIT - com covariadas  e peso SVY
probit conta_prop aposentado $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr aposentado, append title('Probit com covariadas e peso SVY - conta_propria') save(Impactos_Reg_Geral_Contapropria.rtf) fs(10) dec(3) tzok 
est store reg_6a

// Gerar tabela
esttab reg_1a reg_2a reg_3a reg_4a reg_5a reg_6a  using "Efeito_Geral_Contapropria.rtf", b(%12.3f) se(2) stats(N r2_p r2) title(`x') star(* 0.10 ** 0.05 *** 0.01 ) replace

*----------------
// EMPREGADOR  //
*----------------

* OLS - sem covariadas e peso SVY
reg empregador aposentado [pweight=peso_svy], cluster(id7) 
est store reg_1b

* OLS - com covariadas  e peso SVY
reg empregador aposentado $covariadas [pweight=peso_svy], cluster(id7)
est store reg_2b

* LOGIT - sem covariadas e peso SVY
logit empregador aposentado [pweight=peso_svy], cluster(id7) 
asdoc adjrr aposentado, append title('logit sem covariadas e peso SVY - empregador') save(Impactos_Reg_Geral_Empregador.rtf) fs(10) dec(3) tzok 
est store reg_3b

* LOGIT - com covariadas  e peso SVY
logit empregador aposentado $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr aposentado, append title('logit com covariadas e peso SVY - empregador') save(Impactos_Reg_Geral_Empregador.rtf) fs(10) dec(3) tzok 
est store reg_4b

* PROBIT - sem covariadas e peso SVY
probit empregador aposentado [pweight=peso_svy], cluster(id7) 
asdoc adjrr aposentado, append title('Probit sem covariadas e peso SVY - empregador') save(Impactos_Reg_Geral_Empregador.rtf) fs(10) dec(3) tzok 
est store reg_5b

* PROBIT - com covariadas  e peso SVY
probit empregador aposentado $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr aposentado, append title('Probit com covariadas e peso SVY - empregador') save(Impactos_Reg_Geral_Empregador.rtf) fs(10) dec(3) tzok 
est store reg_6b

// Gerar tabela
esttab reg_1b reg_2b reg_3b reg_4b reg_5b reg_6b  using "Efeito_Geral_Empregador.rtf", b(%12.3f) se(2) stats(N r2_p r2) title(`x') star(* 0.10 ** 0.05 *** 0.01 ) replace



********************************************************************************
//                   INDICE DE LIBERDADE ECONOMICA (IMLEE)                    //         
********************************************************************************

* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Definir uma global com todos as variaveis explicativas 
global covariadas IMLEE mulher D_branco capital ensi_fund ensi_med ensi_sup urbano renda_de_Ntrab IFDM_Educacao IFDM_EmpRenda IFDM_Saude

* Deixar somente os aposentados
keep if aposentado==1


* OLS - com covariadas  e peso SVY
reg conta_prop $covariadas [pweight=peso_svy], cluster(id7)
est store reg_1c

* LOGIT - com covariadas  e peso SVY
logit conta_prop  $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr IMLEE, x0(5.074043) x1(5.735896), append title('logit com covariadas e peso SVY - conta_propria') save(Impactos_Reg_IMLEE.rtf) fs(10) dec(3) tzok 
est store reg_2c

* PROBIT - com covariadas  e peso SVY
probit conta_prop $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr IMLEE, x0(5.074043) x1(5.735896), append title('Probit com covariadas e peso SVY - conta_propria') save(Impactos_Reg_IMLEE.rtf) fs(10) dec(3) tzok 
est store reg_3c

* OLS - com covariadas  e peso SVY
reg empregador $covariadas [pweight=peso_svy], cluster(id7)
est store reg_4c

* LOGIT - com covariadas  e peso SVY
logit empregador  $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr IMLEE, x0(5.074043) x1(5.735896), append title('logit com covariadas e peso SVY - conta_propria') save(Impactos_Reg_IMLEE.rtf) fs(10) dec(3) tzok 
est store reg_5c

* PROBIT - com covariadas  e peso SVY
probit empregador $covariadas [pweight=peso_svy], cluster(id7)
asdoc adjrr IMLEE, x0(5.074043) x1(5.735896), append title('Probit com covariadas e peso SVY - conta_propria') save(Impactos_Reg_IMLEE.rtf) fs(10) dec(3) tzok 
est store reg_6c

// Gerar tabela
esttab reg_1c reg_2c reg_3c reg_4c reg_5c reg_6c  using "Efeito_Geral_IMLEE.rtf", b(%12.3f) se(2) stats(N r2_p r2) title(`x') star(* 0.10 ** 0.05 *** 0.01 ) replace


********************************************************************************
//                   FAIXA SALARIAL (SOMENTE APOSENTADOS)                     // 
********************************************************************************

* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Definir uma global com todos as variaveis explicativas 
global covariadas mulher D_branco capital ensi_fund ensi_med ensi_sup urbano renda_de_Ntrab IMLEE   IFDM_Educacao IFDM_EmpRenda IFDM_Saude

* Deixar somente os aposentados
keep if aposentado==1

* Apagar tabelas caso já tenham sido criadas
capture erase Impactos_faixas_salariais_logit_sem_cov_contapropria.rtf
capture erase Impactos_faixas_salariais_probit_sem_cov_contapropria.rtf
capture erase Impactos_faixas_salariais_logit_sem_cov_empregador.rtf
capture erase Impactos_faixas_salariais_probit_sem_cov_empregador.rtf


*------------------
// CONTA PROPRIA // 
*------------------
foreach x in apos_0L1 apos_1 apos_1L2 apos_2L4 apos_4L6 apos_6L8 apos_8L10 apos_10Lmax {

* LOGIT
logit conta_prop `x' $covariadas [pweight=peso_svy], cluster(id7) 

est store Reg_1`x'

*obter ARR e ARD
asdoc adjrr `x', append title('logit `x' conta propria com covariadas') save(Impactos_faixas_salariais_logit_com_cov_contapropria.rtf) fs(10) dec(3) tzok 
}


foreach x in apos_0L1 apos_1 apos_1L2 apos_2L4 apos_4L6 apos_6L8 apos_8L10 apos_10Lmax {

* PROBIT
probit conta_prop `x' $covariadas [pweight=peso_svy], cluster(id7)
est store Reg_2`x'

*obter ARR e ARD
asdoc adjrr `x', append title('probit `x' conta propria com covariadas') save(Impactos_faixas_salariais_probit_com_cov_contapropria.rtf) fs(10) dec(3) tzok 
}

// Gerar tabela
esttab Reg_1apos_0L1 Reg_1apos_1 Reg_1apos_1L2 Reg_1apos_2L4 Reg_1apos_6L8 Reg_1apos_8L10 Reg_1apos_10Lmax using "Efeito_faixas_salariais_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais logit) star(* 0.10 ** 0.05 *** 0.01 ) replace

esttab Reg_2apos_0L1 Reg_2apos_1 Reg_2apos_1L2 Reg_2apos_2L4 Reg_2apos_6L8 Reg_2apos_8L10 Reg_2apos_10Lmax  using "Efeito_faixas_salariais_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais probit) star(* 0.10 ** 0.05 *** 0.01 ) append


*----------------
// EMPREGADOR  // 
*----------------
foreach x in apos_0L1 apos_1 apos_1L2 apos_2L4 apos_4L6 apos_6L8 apos_8L10 apos_10Lmax {

* LOGIT
logit empregador `x' $covariadas [pweight=peso_svy], cluster(id7) 

est store Reg_3`x'

*obter ARR e ARD
asdoc adjrr `x', append title('logit `x' empregador com covariadas') save(Impactos_faixas_salariais_logit_com_cov_empregador.rtf) fs(10) dec(3) tzok 
}


foreach x in apos_0L1 apos_1 apos_1L2 apos_2L4 apos_4L6 apos_6L8 apos_8L10 apos_10Lmax {

* PROBIT
probit empregador `x' $covariadas [pweight=peso_svy], cluster(id7)
est store Reg_4`x'

*obter ARR e ARD
asdoc adjrr `x', append title('probit `x' empregador com covariadas') save(Impactos_faixas_salariais_probit_com_cov_empregador.rtf) fs(10) dec(3) tzok 
}

// Gerar tabela
esttab Reg_3apos_0L1 Reg_3apos_1 Reg_3apos_1L2 Reg_3apos_2L4 Reg_3apos_6L8 Reg_3apos_8L10 Reg_3apos_10Lmax using "Efeito_faixas_salariais_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais logit) star(* 0.10 ** 0.05 *** 0.01 ) append

esttab Reg_4apos_0L1 Reg_4apos_1 Reg_4apos_1L2 Reg_4apos_2L4 Reg_4apos_6L8 Reg_4apos_8L10 Reg_4apos_10Lmax  using "Efeito_faixas_salariais_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais probit) star(* 0.10 ** 0.05 *** 0.01 ) append


*--------------------------------
// GERAR GRÁFICO CONTA-PROPRIA //
*--------------------------------

* Plotando os resultados em um gráfico (tipo tempo de exposição)
coefplot Reg_1apos_0L1 Reg_1apos_1 Reg_1apos_1L2 Reg_1apos_2L4 Reg_1apos_4L6 Reg_1apos_6L8 Reg_1apos_8L10 Reg_1apos_10Lmax, vertical drop($covariadas _cons) yline(0) rename(apos_0L1= 0-1 apos_1L2= 1-2 apos_2L4= 2-4 apos_4L6= 4-6 apos_6L8= 6-8 apos_8L10= 8-10 apos_10Lmax= 10-Max)  graphregion(style(none) color(gs16))yline(0) msymbol(O) mcolor(black) ciopts(recast(rcap)) xtitle(Faixas Salariais, size(small)) legend(off) ytitle(Coeficientes) mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05,"*", ""))))
graph save Grafico_conta_prop_salarios_TODA_BASE.gph, replace

*--------------------------------
//    GERAR GRÁFICO EMPREGADOR //
*--------------------------------

* Plotando os resultados em um gráfico (tipo tempo de exposição)
coefplot Reg_3apos_0L1 Reg_3apos_1 Reg_3apos_1L2 Reg_3apos_2L4 Reg_3apos_6L8 Reg_3apos_8L10 Reg_3apos_10Lmax, vertical drop($covariadas _cons) yline(0) rename(apos_0L1= 0-1 apos_1L2= 1-2 apos_2L4= 2-4 apos_4L6= 4-6 apos_6L8= 6-8 apos_8L10= 8-10 apos_10Lmax= 10-Max)  graphregion(style(none) color(gs16))yline(0) msymbol(O) mcolor(black) ciopts(recast(rcap)) xtitle(Faixas Salariais, size(small)) legend(off) ytitle(Coeficientes) mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05,"*", ""))))
graph save Grafico_empregador_salarios_TODA_BASE.gph, replace


********************************************************************************
//                            LOOP POR FAIXA ETARIA                           //
********************************************************************************

* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Definir uma global com todos as variaveis explicativas 
global covariadas mulher D_branco capital ensi_fund ensi_med ensi_sup urbano renda_de_Ntrab IMLEE   IFDM_Educacao IFDM_EmpRenda IFDM_Saude

*keep aposentados
keep if aposentado==1

* Apagar tabelas caso já tenham sido criadas
capture erase Impactos_faixas_etarias_logit_sem_cov_contapropria.rtf
capture erase Impactos_faixas_etarias_probit_sem_cov_contapropria.rtf
capture erase Impactos_faixas_etarias_logit_sem_cov_empregador.rtf
capture erase Impactos_faixas_etarias_probit_sem_cov_empregador.rtf


*----------------
// CONTA PROPRIA 
*----------------
foreach x in apos_idade45L49 apos_idade50L54 apos_idade55L59 apos_idade60L64 apos_idade65L69 apos_idade70L74 apos_idade75L79 apos_idade80L89 apos_idade90Lmax {

* LOGIT
logit conta_prop `x' $covariadas [pweight=peso_svy], cluster(id7) 

est store Reg_5`x'

*obter ARR e ARD
asdoc adjrr `x', append title('logit `x' conta propria com covariadas') save(Impactos_faixas_etarias_logit_com_cov_contapropria.rtf) fs(10) dec(3) tzok 
}


foreach x in apos_idade45L49 apos_idade50L54 apos_idade55L59 apos_idade60L64 apos_idade65L69 apos_idade70L74 apos_idade75L79 apos_idade80L89 apos_idade90Lmax {

* PROBIT
probit conta_prop `x' $covariadas [pweight=peso_svy], cluster(id7)
est store Reg_6`x'

*obter ARR e ARD
asdoc adjrr `x', append title('probit `x' conta propria com covariadas') save(Impactos_faixas_etarias_probit_com_cov_contapropria.rtf) fs(10) dec(3) tzok 
}

// Gerar tabela
esttab Reg_5apos_idade45L49 Reg_5apos_idade50L54 Reg_5apos_idade55L59 Reg_5apos_idade60L64 Reg_5apos_idade65L69 Reg_5apos_idade70L74 Reg_5apos_idade75L79  Reg_5apos_idade80L89 Reg_5apos_idade90Lmax using "Efeito_faixas_etarias_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais logit) star(* 0.10 ** 0.05 *** 0.01 ) replace

esttab Reg_6apos_idade45L49 Reg_6apos_idade50L54 Reg_6apos_idade55L59 Reg_6apos_idade60L64 Reg_6apos_idade65L69 Reg_6apos_idade70L74 Reg_6apos_idade75L79  Reg_6apos_idade80L89 Reg_6apos_idade90Lmax using "Efeito_faixas_etarias_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais probit) star(* 0.10 ** 0.05 *** 0.01 ) append


*----------------
// EMPREGADOR 
*----------------
foreach x in apos_idade45L49 apos_idade50L54 apos_idade55L59 apos_idade60L64 apos_idade65L69 apos_idade70L74 apos_idade75L79 apos_idade80L89 apos_idade90Lmax {

* LOGIT
logit empregador `x' $covariadas [pweight=peso_svy], cluster(id7) 

est store Reg_7`x'

*obter ARR e ARD
asdoc adjrr `x', append title('logit `x' empregador com covariadas') save(Impactos_faixas_etarias_logit_com_cov_empregador.rtf) fs(10) dec(3) tzok 
}


foreach x in apos_idade45L49 apos_idade50L54 apos_idade55L59 apos_idade60L64 apos_idade65L69 apos_idade70L74 apos_idade75L79 apos_idade80L89 apos_idade90Lmax {

* PROBIT
probit empregador `x' $covariadas [pweight=peso_svy], cluster(id7)
est store Reg_8`x'

*obter ARR e ARD
asdoc adjrr `x', append title('probit `x' empregador com covariadas') save(Impactos_faixas_etarias_probit_com_cov_empregador.rtf) fs(10) dec(3) tzok 
}

// Gerar tabela
esttab Reg_7apos_idade45L49 Reg_7apos_idade50L54 Reg_7apos_idade55L59 Reg_7apos_idade60L64 Reg_7apos_idade65L69 Reg_7apos_idade70L74 Reg_7apos_idade75L79  Reg_7apos_idade80L89 Reg_7apos_idade90Lmax using "Efeito_faixas_etarias_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais logit) star(* 0.10 ** 0.05 *** 0.01 ) replace

esttab Reg_8apos_idade45L49 Reg_8apos_idade50L54 Reg_8apos_idade55L59 Reg_8apos_idade60L64 Reg_8apos_idade65L69 Reg_8apos_idade70L74 Reg_8apos_idade75L79  Reg_8apos_idade80L89 Reg_8apos_idade90Lmax using "Efeito_faixas_etarias_sem_covariadas.rtf", b(%12.3f) se(2) stats(N r2 r2_a) title(Reg por faixas salariais probit) star(* 0.10 ** 0.05 *** 0.01 ) append


*----------------------------------
//  GERAR GRÁFICO CONTA-PROPRIA  //  
*----------------------------------

* Plotando os resultados em um gráfico (tipo tempo de exposição)
coefplot Reg_5apos_idade45L49 Reg_5apos_idade50L54 Reg_5apos_idade55L59 Reg_5apos_idade60L64 Reg_5apos_idade65L69 Reg_5apos_idade70L74 Reg_5apos_idade75L79  Reg_5apos_idade80L89 Reg_5apos_idade90Lmax, vertical drop($covariadas _cons) yline(0)  rename( apos_idade45L49= 45-49 apos_idade50L54= 55-54 apos_idade55L59=55-59 apos_idade60L64= 60-64 apos_idade65L69= 65-69 apos_idade70L74= 70-74 apos_idade75L79= 75-79 apos_idade80L89= 80-89 apos_idade90Lmax= 90-max) graphregion(style(none) color(gs16))yline(0) msymbol(O) mcolor(black) ciopts(recast(rcap)) xtitle(Faixas Etárias, size(small)) legend(off)  ytitle(Coeficientes) mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05,"*", ""))))
graph save Grafico_conta_prop_Idades_TODA_BASE.gph, replace

*-------------------------------
//  GERAR GRÁFICO EMPREGADOR  //
*-------------------------------

* Plotando os resultados em um gráfico (tipo tempo de exposição)
coefplot Reg_7apos_idade45L49 Reg_7apos_idade50L54 Reg_7apos_idade55L59 Reg_7apos_idade60L64 Reg_7apos_idade65L69 Reg_7apos_idade70L74 Reg_7apos_idade75L79  Reg_7apos_idade80L89 Reg_7apos_idade90Lmax, vertical drop($covariadas _cons) yline(0)  rename( apos_idade45L49= 45-49 apos_idade50L54= 55-54 apos_idade55L59=55-59 apos_idade60L64= 60-64 apos_idade65L69= 65-69 apos_idade70L74= 70-74 apos_idade75L79= 75-79 apos_idade80L89= 80-89 apos_idade90Lmax= 90-max) graphregion(style(none) color(gs16))yline(0) msymbol(O) mcolor(black) ciopts(recast(rcap)) xtitle(Faixas Etárias, size(small)) legend(off)  ytitle(Coeficientes) mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05,"*", ""))))
graph save Grafico_conta_prop_Idades_TODA_BASE.gph, replace


********************************************************************************
//                           ESTATÍSTICAS                                     //
********************************************************************************

* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Definir uma global com todos as variaveis
global covariadas D_branco mulher renda_de_Ntrab ensi_fund ensi_med ensi_sup mes_doc urbano capital  
global salarios   apos_0L1 apos_1 apos_1L2 apos_2L4 apos_4L6 apos_6L8 apos_8L10 apos_10Lmax Napos_0L1 Napos_1 Napos_1L2 Napos_2L4 Napos_4L6 Napos_6L8 Napos_8L10 Napos_10Lmax
global idades     apos_idademinL44 apos_idade45L49 apos_idade50L54 apos_idade55L59 apos_idade60L64 apos_idade65L69 apos_idade70L74 apos_idade75L79 apos_idade80L89 apos_idade90Lmax
global outras     aposentado empregador conta_prop  

* Salvar resultados
logout, save(Descritivas) excel replace: sum aposentado $salarios $idades conta_prop empregador  ///
$covariadas [iw=peso_svy]


*----------------------------
// BALANÇO DAS COVARIADAS  // 
*----------------------------

* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Deixar somente as variáveis que vamos utilizar
keep mulher D_branco capital ensi_fund ensi_med ensi_sup mes_doc urbano renda_de_Ntrab aposentado peso_svy strato

* * Definir uma global
global covariadas mulher D_branco capital ensi_fund ensi_med ensi_sup mes_doc urbano renda_de_Ntrab 


* Diferenças de médias após o psw
svyset [pweight=peso_ATT], strata(strato) vce(linearized) singleunit(centered)

foreach var of varlist mulher D_branco capital ensi_fund ensi_med ensi_sup mes_doc urbano renda_de_Ntrab {
svy: mean `var' , over(aposentado2)
lincom [`var']0 - [`var']1
outreg2 using "Balanço_covaridas_geral apos.doc", title(Balanço Covariadas) ctitle(`var') addstat(lincom_p>|t|, `r(p)') noaster
}

* Diferenças de média antes o psw
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

foreach var of varlist mulher D_branco capital ensi_fund ensi_med ensi_sup mes_doc urbano renda_de_Ntrab {
svy: mean `var' , over(aposentado2)
lincom [`var']0 - [`var']1
outreg2 using "Balanço_covaridas_geral antes.doc", title(Balanço Covariadas) ctitle(`var') addstat(lincom_p>|t|, `r(p)') noaster
}

********************************************************************************
//              ESTATÍSTICAS PROPORÇÕES COM PESO E SEM PESO                   //
********************************************************************************


* Limpar tudo
clear all

* Importar dados 
use "D:\Dados.dta", clear

* Escolher pasta de saida dos resultaods
cd  "D:\RESULTADOS"

* Declarar que estamos trabalhando com amostra complexa
svyset [pweight=peso_svy], strata(strato) vce(linearized) singleunit(centered)

* Definir uma global com todos as variaveis explicativas 
global salarios   apos_0L1 apos_1 apos_1L2 apos_2L4 apos_4L6 apos_6L8 apos_8L10 apos_10Lmax 
global idades     apos_idademinL44 apos_idade45L49 apos_idade50L54 apos_idade55L59 apos_idade60L64 ///
apos_idade65L69 apos_idade70L74 apos_idade75L79 apos_idade80L89 apos_idade90Lmax

* salvar resultados

* sem pesos
asdoc prop $salarios $idades aposentado, replace title('proporção sem pesos (amostra)') save(Descritivas e proporções.rtf) fs(10) dec(3) tzok

*com pesos
asdoc prop $salarios $idades aposentado [iw=peso_svy] , append title('proporção com pesos (amostra)') save(Descritivas e proporções.rtf) fs(10) dec(3) tzok


* Descritivas somente para os aposentados
keep if aposentado==1

*conta propria
asdoc svy: mean $salarios $idades $covariadas if conta_prop==1, append title('Média contapropria') save(Descritivas e proporções.rtf) fs(10) dec(3) tzok

* esses não tem pesos
asdoc sum IFDM_Educacao IFDM_EmpRenda IFDM_Saude IMLEE if conta_prop==1, append title('min max contapropria') save(Descritivas e proporções.rtf) fs(10) dec(3) tzok

*empregador
asdoc svy: mean $salarios $idades $covariadas if empregador==1 , append title('Média empregador') save(Descritivas e proporções.rtf) fs(10) dec(3) tzok

* esses não tem pesos
asdoc sum IFDM_Educacao IFDM_EmpRenda IFDM_Saude IMLEE if empregador==1 , append title('min max empregador') save(Descritivas e proporções.rtf) fs(10) dec(3) tzok

*-------------------------------------------------------------------------------
* FIM

