*-----------------------------------------------------------------------------------
//INOVAÇÃO E CRESCIMENTO ECONÔMICO: UMA ANÁLISE EM PAINEL DINÂMICO PARA  O BRASIL //
*-----------------------------------------------------------------------------------
/*
NOTA: Este do-file não é o original, dado que ao fazermos testes adicionais alteramos o arquivo original, 
contudo, os resultados aqui obtidos são muito próximos dos apresentados no artigo. 
*/

* Instalar pacotes
*ssc install asdoc
*ssc install ftools
*ssc install mdesc
*net install st0085_2.pkg
*ssc install xtabond2

* Carregar dados
use "D:\OneDrive\Base_inovacao.dta", clear

* Declarar painel de dados
xtset id Ano 

* ver missings
mdesc

*--------------------------------------
* TABELA 2 - Estatisticas Descritivas *
*--------------------------------------
asdoc sum lnY_L lnK_L G_estaduais_PeDdef_Mi Dep_Pi_Mi Conc_PI_Mi Dep_MU_Mi Conc_MU_Mi D_crise Trend, replace title(TABELA 2 - Estatisticas Descritivas) save(Descritivas.rtf) fs(10) dec(6) tzok

*--------------------------------------------------------------------------------
// TABELA 3 Resultados SYS-GMM para depósito de pedidos de patentes de invenção *
*--------------------------------------------------------------------------------

*TWOSTEP LAGLIMITS, COLLAPSE PCA
xtabond2 D.lnY_L L.lnY_L lnK_L Dep_Pi_Mi  G_estaduais_PeDdef_Mi D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Dep_Pi_Mi  D_crise Trend) twostep robust pca components (19)
estimates store Reg_1_tab_3

xtabond2 D.lnY_L L.lnY_L lnK_L Dep_MU_Mi  G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Dep_MU_Mi  D_crise Trend) twostep robust pca components (19)
estimates store Reg_2_tab_3

xtabond2 D.lnY_L L.lnY_L lnK_L Conc_PI_Mi G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Conc_PI_Mi D_crise Trend) twostep robust pca components (19)
estimates store Reg_3_tab_3

xtabond2 D.lnY_L L.lnY_L lnK_L Conc_MU_Mi G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Conc_MU_Mi D_crise Trend) twostep robust pca components (19)
estimates store Reg_4_tab_3

esttab Reg_1_tab_3 Reg_2_tab_3 Reg_3_tab_3 Reg_4_tab_3  using "tabela_3.rtf", b(%12.3f) se(2) star(* 0.10 ** 0.05 *** 0.01 ) scalars(sargan sarganp hansen hansenp ar1 ar1p ar2 ar2p j) replace

*----------------------------------
// TABELA 4 - Resultados Robustez *
*----------------------------------

*TWOSTEP PCA
xtabond2 D.lnY_L L.lnY_L lnK_L Dep_Pi_Mi G_estaduais_PeDdef_Mi D_crise Trend, gmm(L.lnY_L lnK_L) iv(G_estaduais_PeDdef_Mi Dep_Pi_Mi D_crise Trend) twostep robust pca components (19)
estimates store Reg_1_tab_4

xtabond2 D.lnY_L L.lnY_L lnK_L Dep_MU_Mi  G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L ) iv(G_estaduais_PeDdef_Mi Dep_MU_Mi  D_crise Trend) twostep robust pca components (19)
estimates store Reg_2_tab_4

xtabond2 D.lnY_L L.lnY_L lnK_L Conc_PI_Mi G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L ) iv(G_estaduais_PeDdef_Mi Conc_PI_Mi D_crise Trend) twostep robust pca components (19)
estimates store Reg_3_tab_4

xtabond2 D.lnY_L L.lnY_L lnK_L Conc_MU_Mi G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L ) iv(G_estaduais_PeDdef_Mi Conc_MU_Mi D_crise Trend) twostep robust pca components (19)
estimates store Reg_4_tab_4

*TWOSTEP LAGLIMITS E COLLAPSE
xtabond2 D.lnY_L L.lnY_L lnK_L Dep_Pi_Mi  G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Dep_Pi_Mi  D_crise Trend) twostep robust 
estimates store Reg_5_tab_4

xtabond2 D.lnY_L L.lnY_L lnK_L Dep_MU_Mi  G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Dep_MU_Mi  D_crise Trend) twostep robust 
estimates store Reg_6_tab_4

xtabond2 D.lnY_L L.lnY_L lnK_L Conc_PI_Mi G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Conc_PI_Mi D_crise Trend) twostep robust 
estimates store Reg_7_tab_4

xtabond2 D.lnY_L L.lnY_L lnK_L Conc_MU_Mi G_estaduais_PeDdef_Mi  D_crise Trend, gmm(L.lnY_L lnK_L , lag(1 9) collapse) iv(G_estaduais_PeDdef_Mi Conc_MU_Mi D_crise Trend) twostep robust 
estimates store Reg_8_tab_4

esttab Reg_1_tab_4 Reg_2_tab_4 Reg_3_tab_4 Reg_4_tab_4 Reg_5_tab_4 Reg_6_tab_4 Reg_7_tab_4 Reg_8_tab_4  using "tabela_4.rtf", b(%12.3f) se(2) star(* 0.10 ** 0.05 *** 0.01 ) scalars(sargan sarganp hansen hansenp ar1 ar1p ar2 ar2p j) replace
*-------------------------------------------------------------------------------
