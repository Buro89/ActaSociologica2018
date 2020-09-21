
/******WHAT IS IT?*****/

/***This is the do-file for the graphs in the 2018 Acta Sociologica paper https://doi.org/10.1177/0001699317748340*/


/******LICENSE AND CITATION?*****/

/**This do-file is open accessible under the Open Data Commons Public CDomain Dedication and License (PDDL)
- Read the summary https://opendatacommons.org/licenses/pddl/summary/
- Read the full legal text https://opendatacommons.org/licenses/pddl/1-0/

Please be sure to check the Community Norms https://opendatacommons.org/norms/odc-by-sa/
It would be awesome if you would credit the author of the do-file: Karlijn Roex (2017)*/

/*When citing this do-file, please mention one of these urls:
- https://github.com/Buro89/ActaSociologica2018/figure 1 and 2 final syntax.do
- https://karlijnroex.net/Academic/ActaSociologica2018/figure 1 and 2 final syntax.do
*/

/******CREDITS & PRACTICAL INFO*****/
/**Use this datafile ISSP2009_sessionmarch2017_new*/

When citing this dataset, please mention one of this url:
- https://surfdrive.surf.nl/files/index.php/s/nl88elX7PL0mYKL

That dataset is a derivative from the original ISSP 2009 DATASET DOWNLOADABLE HERE https://www.gesis.org/issp/modules/issp-modules-by-topic/social-inequality/2009/
ISSP Social Inequality Module IV 2009
DOI: doi:10.4232/1.11506

The language used is STATA
*/


/******START DO-FILE*****/


/**Making graph*/
collapse V5 (mean) inequalitytolerance (mean) V32 (mean) meritperc_volledig_threshmacro (mean) GDP (mean) meritperc_volledig_macro (mean) GINI_SWIID (mean) UPWARD_macro (mean) MIDDLECLASS_PERC_macro (mean) NATION (mean) BOT_catb (mean) TOP_catb (mean) V32_topb (mean) V32_botb (mean) EDUC_low (mean) EDUC_high (mean) V32_educlow (mean) V32_educhigh, by(COUNTRY)

/**Adding labels*/
drop COUNTRY
recode V5 (32=50 "ARG") (36 = 1 "AUS") (40=2 "AUT") (56=3 "BEL") (100=36 "BG") (152=5 "CHL") (156 = 51 "CHN") (158=52 "TAI") (191=37 "HR") (196=53 "CY") (203 =6 "CZ") (208 =7 "DK") (233 = 8  "EST") (246 = 9 "FI") (250 =10 "FR" ) (276 =11 "DE")  (348= 13 "HU") (352 =14 "ICE") (376 =16 "ISR") (380 =17 "IT") (392=18 "JPN") (410 =19 "KOR") (428 = 38 "LV") (554 =23 "NZ") (578 =24 "NO") (608 = 54 "PHIL") (616 = 25 "PL") (620 =26 "PT") (643 = 55 "RU") (703 =27 "SK") (705 = 28 "SL") (710 =35 "SA") (724 = 29 "SP") (752 =30 "SE") (756 =31 "CH") (792 = 32 "TUR") (804 = 56 "UKR") (826=33 "UK") (840 = 34 "US")(862 = 57 "VNZ"), into(COUNTRY)
recode V5 (32=50 "Argentina") (36 = 1 "Australia") (40=2 "Austria") (56=3 "Belgium") (100=36 "Bulgaria") (152=5 "Chile") (156 = 51 "China") (158=52 "Taiwan") (191=37 "Croatia") (196=53 "Cyprus") (203 =6 "Czech Rep.") (208 =7 "Denmark") (233 = 8  "Estonia") (246 = 9 "Finland") (250 =10 "FR" ) (276 =11 "Germany")  (348= 13 "Hungary") (352 =14 "Iceland") (376 =16 "Israel") (380 =17 "Italy") (392=18 "Japan") (410 =19 "S. Korea") (428 = 38 "Latvia") (554 =23 "New Zealand") (578 =24 "Norway") (608 = 54 "Philippines") (616 = 25 "Poland") (620 =26 "Portugal") (643 = 55 "Russia") (703 =27 "Slovakia") (705 = 28 "Slovenia") (710 =35 "South Africa") (724 = 29 "Spain") (752 =30 "Sweden") (756 =31 "Switzerland") (792 = 32 "Turkey") (804 = 56 "Ukraine") (826=33 "United Kingdom") (840 = 34 "United States")(862 = 57 "Venezuela"), into(Country)


gen polarization1 = V32_topb - V32_botb
gen polarization2 = V32_educhigh - V32_educlow


/*Figure 1*/

twoway scatter V32 meritperc_volledig_macro if GDP!=.&UPWARD_macro!=.&GINI_SWIID!=.&NATION!=., title(Meritocratic perceptions and inequality tolerance for countries) mlabel(COUNTRY)

/*Figure 2a*/

twoway scatter polarization1 meritperc_volledig_macro if GDP!=.&UPWARD_macro!=.&GINI_SWIID!=.&NATION!=., title(Meritocratic perceptions and inequality tolerance for countries) mlabel(COUNTRY)

/*Figure 2b*/

twoway scatter polarization2 meritperc_volledig_macro if GDP!=.&UPWARD_macro!=.&GINI_SWIID!=.&NATION!=., title(Meritocratic perceptions and inequality tolerance for countries) mlabel(COUNTRY)
