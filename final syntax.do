/******WHAT IS IT?*****/

/***This is the do-file for the analyses behind the 2018 Acta Sociologica paper https://doi.org/10.1177/0001699317748340*/

/******LICENSE AND CITATION?*****/

/**This do-file is open accessible under the Open Data Commons Public CDomain Dedication and License (PDDL)
- Read the summary https://opendatacommons.org/licenses/pddl/summary/
- Read the full legal text https://opendatacommons.org/licenses/pddl/1-0/

Please be sure to check the Community Norms https://opendatacommons.org/norms/odc-by-sa/
It would be awesome if you would credit the author of the do-file: Karlijn Roex (2017)*/

/*For citation/ referral, please mention one of these links:
- https://github.com/Buro89/ActaSociologica2018/final syntax.do
- https://karlijnroex.net/Academic/ActaSociologica2018/final syntax.do
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


/*1. Prepare data***************************************************************************************/

/**1.1 Education*/
recode EDUCYRS (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (11=11) (12=12) (13 95=13) (14=14) (15 96=15) (16=16) (17=17) (18=18) (19=19) (20=20) (21=21) (22=22) (23=23) (24/81=24)(97 98 99=.), into(educ)
/*Still at school, calculated as (resp minimally 15 yr old) 8yr primary school+5yr high school = 13 yr schooling.
Still at univ, = 8 yr primary school+6 years high school+1 year undergraduate = 15 yrs schooling.
Everyone with more than 8+6+10 (long university attendance and doing phd) = 24 yr schooling*/

/*Centering*/
egen educ_A = mean(educ)
gen EDUC_C = educ - educ_A

/*1.2 Gender*/
recode SEX (1=1 "male") (nonm=0 "female"), into(male)
tab V5, gen(country)


/*1.3 Meritocratic perceptions scale micro*/


/*Meritperc consistency and cleaneness of data*/
tab V9
tab V9, nola /*1= high*/
tab V8
tab V8, nola /*1 = high*/
tab V6
tab V6, nola /*5 = high*/
tab V11
tab V11, nola /*5 = high*/
tab V12
tab V12, nola /*idem*/
tab V16
tab V16, nola /*idem*/
tab V14
tab V14, nola /*idem*/

/*recode*/

replace V9 = . if (V9 ==.a | V9== .c | V9== .b | V9== .n | V9== .)
replace V8 = . if (V8 ==.a | V8== .c | V8== .b | V8== .n | V8== .)
replace V6 = . if (V6 ==.a | V6== .c | V6== .b | V6== .n | V6== .)
replace V11 = . if (V11 ==.a | V11== .c | V11== .b | V11== .n | V11== .)
replace V12 = . if (V12 ==.a | V12== .c | V12== .b | V12== .n | V12== .)
replace V16 = . if (V16 ==.a | V16== .c | V16== .b | V16== .n | V16== .)
replace V14 = . if (V14 ==.a | V14== .c | V14== .b | V14== .n | V14== .)
replace V10 = . if (V10 ==.a | V10== .c | V10== .b | V10== .n | V10== .)
replace V13 = . if (V13 ==.a | V13== .c | V13== .b | V13== .n | V13== .)
replace V7 = . if (V7 ==.a | V7== .c | V7== .b | V7== .n | V7== .)


recode V9 (1=5 "essential") (2=4 "very important") (3=3 "fairly important") (4=2 "not very important") (5=1 "not important at all"), into(meritperc_item1)
label variable meritperc_item1   "get ahead: how important is having ambition?"
recode V8 (1=5 "essential") (2=4 "very important") (3=3 "fairly important") (4=2 "not very important") (5=1 "not important at all"), into(meritperc_item2)
label variable meritperc_item2   "get ahead: how important is having a good education yourself?"
rename V6 meritperc_item3
label variable meritperc_item3   "get ahead: how important is coming from a wealthy family?"
rename V11 meritperc_item4
label variable meritperc_item4   "get ahead: how important is knowing the right people?"
rename V12 meritperc_item5
label variable meritperc_item5   "get ahead: how important is having political connections?"
recode V10 (1=5 "essential") (2=4 "very important") (3=3 "fairly important") (4=2 "not very important") (5=1 "not important at all"), into(meritperc_item8)
label variable meritperc_item8   "get ahead: hard work"
gen meritperc_item9 = V7
gen meritperc_item10 = V13
label variable meritperc_item9   "get ahead: well educ parents"
label variable meritperc_item10   "get ahead: bribes"



/****construct complete meritocratic perception scale***/

  /*.75*/
alpha meritperc_item3 meritperc_item4  meritperc_item5  meritperc_item9 meritperc_item10 if GDP!=.&GINI_SWIID!=.

/*Add meritocratic aspects: doesn't become much worse (.73)*/
alpha meritperc_item1 meritperc_item2 meritperc_item8 meritperc_item3 meritperc_item4  meritperc_item5  meritperc_item9 meritperc_item10 if GDP!=.&GINI_SWIID!=.


gen meritperc_volledig = (meritperc_item1 +meritperc_item2 +meritperc_item8 +meritperc_item3+ meritperc_item4+  meritperc_item5 + meritperc_item9+ meritperc_item10)/8


/*Keep people with 1 of 2 missings*/

gen meritperc_Volledig_mis1 = (meritperc_item2+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/7
gen meritperc_Volledig_mis2 = (meritperc_item1+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8 + meritperc_item9 + meritperc_item10)/7
gen meritperc_Volledig_mis3 = (meritperc_item1+meritperc_item2+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/7
gen meritperc_Volledig_mis4 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/7
gen meritperc_Volledig_mis5 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item8+ meritperc_item9 + meritperc_item10)/7
gen meritperc_Volledig_mis8 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item5 + meritperc_item9+meritperc_item10)/7
gen meritperc_Volledig_mis9 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item10)/7
gen meritperc_Volledig_mis10 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item5 + meritperc_item8+meritperc_item9)/7

gen meritperc_Volledig_mis12  = (meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis13  = (meritperc_item2+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis14  = (meritperc_item2+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis15  = (meritperc_item2+meritperc_item3+meritperc_item4 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis18  = (meritperc_item2+meritperc_item3+meritperc_item4 + meritperc_item5 +  meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis19  = (meritperc_item2+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8+  meritperc_item10)/6
gen meritperc_Volledig_mis110 = (meritperc_item2+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 )/6
gen meritperc_Volledig_mis23 = (meritperc_item1+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis24 = (meritperc_item1+meritperc_item3 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis25 = (meritperc_item1+meritperc_item3+meritperc_item4  + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis28 = (meritperc_item1+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis29 = (meritperc_item1+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8 + meritperc_item10)/6
gen meritperc_Volledig_mis210 = (meritperc_item1+meritperc_item3+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 )/6
gen meritperc_Volledig_mis34 = (meritperc_item1+meritperc_item2 + meritperc_item5 + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis35 = (meritperc_item1+meritperc_item2+meritperc_item4  + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis38 = (meritperc_item1+meritperc_item2+meritperc_item4 + meritperc_item5 + meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis39 = (meritperc_item1+meritperc_item2+meritperc_item4 + meritperc_item5 + meritperc_item8 + meritperc_item10)/6
gen meritperc_Volledig_mis310 = (meritperc_item1+meritperc_item2+meritperc_item4 + meritperc_item5 + meritperc_item8+ meritperc_item9 )/6
gen meritperc_Volledig_mis45 = (meritperc_item1+meritperc_item2+meritperc_item3  + meritperc_item8+ meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis48 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item5 + meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis49 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item5 + meritperc_item8 + meritperc_item10)/6
gen meritperc_Volledig_mis410 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item5 + meritperc_item8+ meritperc_item9 )/6
gen meritperc_Volledig_mis58 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item9 + meritperc_item10)/6
gen meritperc_Volledig_mis59 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item8 + meritperc_item10)/6
gen meritperc_Volledig_mis510 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item8+ meritperc_item9 )/6
gen meritperc_Volledig_mis89 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item5 +meritperc_item10)/6
gen meritperc_Volledig_mis810 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item5 + meritperc_item9)/6
gen meritperc_Volledig_mis910 = (meritperc_item1+meritperc_item2+meritperc_item3 + meritperc_item4 + meritperc_item5 + meritperc_item8)/6

replace meritperc_volledig = meritperc_Volledig_mis1 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis2 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis3 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis4 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis5 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis8 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis9 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis10 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10==.)

replace meritperc_volledig = meritperc_Volledig_mis12 if (meritperc_item1==.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis13 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis14 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis15 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis18 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis19 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis110 if (meritperc_item1==.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10==.)
replace meritperc_volledig = meritperc_Volledig_mis23 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis24 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis25 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis28 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis29 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis210 if (meritperc_item1!=.&meritperc_item2==.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10==.)
replace meritperc_volledig = meritperc_Volledig_mis34 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis35 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis38 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis39 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis310 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3==.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10==.)
replace meritperc_volledig = meritperc_Volledig_mis45 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis48 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis49 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis410 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4==.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10==.)
replace meritperc_volledig = meritperc_Volledig_mis58 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis59 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis510 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5==.&meritperc_item8!=.&meritperc_item9!=.&meritperc_item10==.)
replace meritperc_volledig = meritperc_Volledig_mis89 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9==.&meritperc_item10!=.)
replace meritperc_volledig = meritperc_Volledig_mis810 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8==.&meritperc_item9!=.&meritperc_item10==.)
replace meritperc_volledig = meritperc_Volledig_mis910 if (meritperc_item1!=.&meritperc_item2!=.&meritperc_item3!=.&meritperc_item4!=.&meritperc_item5!=.&meritperc_item8!=.&meritperc_item9==.&meritperc_item10==.)


/**Centering**/

egen meritperc_volledig_A = mean(meritperc_volledig)
gen meritperc_volledig_C  = meritperc_volledig - meritperc_volledig_A


/*1.4 Meritocratic perceptions scale macrolevel*/


bys COUNTRY: egen meritperc_volledig_macro = mean(meritperc_volledig)

/*Centre*/
egen meritperc_volledig_macro_A = mean(meritperc_volledig_macro)
gen meritperc_volledig_macro_C = meritperc_volledig_macro - meritperc_volledig_macro_A





/*1.5 INCOME self-placement*/
tab TOPBOT
/*I run the analyses separately for the highest and lowest groups. Let's put
the threshold at the lowest three and the highest three groups*/
recode TOPBOT (1 2 3 = 1) (nonm=0), into(BOTTOM)
recode TOPBOT (8 9 10 = 1) (nonm=0), into(TOP)
tab TOPBOT BOTTOM


/*For practical reasons, consistent country coding with my other project (two revisions)*/
tab V5
tab V5, nola
recode V5 (32=50 "ARG") (36 = 1 "AUS") (40=2 "AUT") (56=3 "BEL") (100=36 "BG") (152=5 "CHILE") (156 = 51 "CHIN") (158=52 "TAI") (191=37 "CRO") (196=53 "CYP") (203 =6 "CZ") (208 =7 "DK") (233 = 8  "EST") (246 = 9 "FI") (250 =10 "FR" ) (276 =11 "DE")  (348= 13 "HUN") (352 =14 "ICELAND") (376 =16 "ISRAEL") (380 =17 "ITALY") (392=18 "JAP") (410 =19 "KOR") (428 = 38 "LV") (554 =23 "NZ") (578 =24 "NO") (608 = 54 "PHIL") (616 = 25 "POL") (620 =26 "PORT") (643 = 55 "RUSSIA") (703 =27 "SLOVAK") (705 = 28 "SLOVEN") (710 =35 "SA") (724 = 29 "SPAIN") (752 =30 "SWE") (756 =31 "SWI") (792 = 32 "TURK") (804 = 56 "UKR") (826=33 "UK") (840 = 34 "US")(862 = 57 "VENEZUELA"), into(COUNTRY)
recode COUNTRY (36=38) (38=40) (53=45)(55=47)(56=48)(51=52)(54=80 "Phil") (57=82 "Venez") (52=83 "Tai"), into(NATION)

/*1.6 Gini*/

egen GINI_SWIID_A = mean(GINI_SWIID)
gen GINI_SWIID_C = GINI_SWIID - GINI_SWIID_A


recode NATION (1=32.67138)(2=28.23706)(3=25.21454)(4=31.56029)  (5=48.74039)(6=24.6513)(7=24.53119)(8=32.21969)(9=26.23677) (10=29.43168)(11=28.78434)(12=32.76256)(13=26.5315)(14=25.45792) (15=29.28866)(16=37.5617)(17=32.55279)(18=30.67924)(19=31.36901) (20=27.2104)(21=44.35597)(22=26.36616)(23=33.00904)(24=24.3711) (25=30.95572)(26=33.93617)(27=25.76585)(28=24.39728)(29=32.57923) (30=24.45007)(31=30.17735)(32=37.9652)(33=35.70866)(34=37.41134) (35=59.53127)(37=28.69186)(38=35.39886)(39=33.54734)(40=34.67152) (41=35.33187)(44=29.07699)(45=27.07138)(47=41.00348)(48=27.63591)(50=40.94913)(52=53.36763)(80=43.03026)(82=37.45855)(83=31.57788)(nonm=.),into(GINI_SWIID_new)


/*1.7 GDP World Bank 2009*/
recode COUNTRY (1 =42715.13226) (2=47654.18721) (3=44880.56015)(5=10217.31403) (6= 19698.49209)(7= 57895.50122)(8=14726.31391) (9=47107.15571) (10=41631.13141) (11=41732.70725)  (13=12948.07667) (14=40362.04159) (16=27795.87671) (17=36995.10693) (18= 39322.60473)(19=18338.70637)  (23=27998.56644) (24=80017.77681) (25=11440.57813) (26=23063.97161) (27=16460.2224) (28=24633.79608) (29=32333.4661) (30=46207.0592) (31=69672.00471) (32=8623.949625) (33=37166.27597) (34=47001.55535) (35=5912.143179) (36=6955.987733)(37=14157.14416) (38= 12207.58707)(50 =9231.3829) (51=3800.474542) (52=.) (53=31673.45771) (54= 1836.87412)(55=8562.813697) (56= 2545.480341)(57=11534.8406)(nonm=.) , into(GDP)

egen GDP_A = mean(GDP)
gen GDP_C = GDP - GDP_A



/*1.8 Social mobility*/
tab V45
gen SOCMOBI = TOPBOT - V45

/*Also looking for upward and downward mobiles*/
tab SOCMOBI
*/
recode SOCMOBI (-9/-1= 1 "social downward") (0=2 "stable") (1/9=3 "social upward"), into(SOCMOBI_cats)
gen UPWARD = 1 if SOCMOBI>0
replace UPWARD = 0 if SOCMOBI<=0
replace UPWARD = . if SOCMOBI==.
tab SOCMOBI UPWARD
gen DOWNWARD = 1 if SOCMOBI<0
replace DOWNWARD = 0 if SOCMOBI>=0
replace DOWNWARD = . if SOCMOBI==.

/*Taking the average SOCMOBI is a bit odd. You can get a low mean value while people move equally much upward as downward. I prefer to look at % mobile*/
/*People can say to be really mobile if they are at least 1 tread higher or lower than their parents*/
gen MOBILE = 1 if SOCMOBI!=0
replace MOBILE = 0 if SOCMOBI==0
replace MOBILE = . if SOCMOBI==.

/*One can also look at  % of upwardly socially mobile*/
/*Now the % upwardly mobile and the % downwardly mobile in a society: preliminary, because unweighted*/
bys COUNTRY: egen DOWNWARD_macro = mean(DOWNWARD)
bys COUNTRY: egen UPWARD_macro = mean(UPWARD) */

/*Centre*/
egen UPWARD_macro_A = mean(UPWARD_macro)
gen UPWARD_macro_C = UPWARD_macro - UPWARD_macro_A

/*1.9 Middle class society perception (Larsen, 2016)*/
recode V54 (1 2 3 5 = 0) (4=1), into(MIDDLECLASS_PERC_micro)
bys COUNTRY: egen MIDDLECLASS_PERC_macro = mean(MIDDLECLASS_PERC_micro)
egen MIDDLECLASS_PERC_macro_A = mean(MIDDLECLASS_PERC_macro)
gen MIDDLECLASS_PERC_macro_C = MIDDLECLASS_PERC_macro - MIDDLECLASS_PERC_macro_A


/***1.10 World region (to keep country context a bit constant*/

recode NATION (1 4 15 23 33 34 =1 "New World/ Angelsaxon") (12 16 17 26 29 32 45 = 2 "Mediterranean area")(6 8 13 25 27 28 37 38 40 47 48 = 3 "Eastern Europe") (5 21 50 82 = 4 "Latin America") (18 19 52 80 83 = 5 "East Asia") (35= 6 "Africa") (2 3 10 11 20 22 31 =7 "Continental West-Mid Europe") (7 9 14 24 30 =8 "Nordic")(nonm=.),into(WORLDREGION)



/**1.11 Remove odd missings*/

replace AGE = . if (AGE ==.a | AGE== .c | AGE== .b | AGE== .n | AGE== .)
replace V32 = . if (V32 ==.a | V32== .c | V32== .b | V32== .n | V32== .)
replace MIDDLECLASS_PERC_micro = . if (MIDDLECLASS_PERC_micro ==.a | MIDDLECLASS_PERC_micro== .c | MIDDLECLASS_PERC_micro== .b | MIDDLECLASS_PERC_micro== .n | MIDDLECLASS_PERC_micro== .)
replace meritperc_volledig_C = . if (meritperc_volledig_C ==.a | meritperc_volledig_C== .c | meritperc_volledig_C== .b | meritperc_volledig_C== .n | meritperc_volledig_C== .)
replace EDUC_C = . if (EDUC_C ==.a | EDUC_C== .c | EDUC_C== .b | EDUC_C== .n | EDUC_C== .)
replace TOPBOT_C = . if (TOPBOT_C ==.a | TOPBOT_C== .c | TOPBOT_C== .b | TOPBOT_C== .n | TOPBOT_C== .)
replace male = . if (male ==.a | male== .c | male== .b | male== .n | male== .)
replace WRKST = . if (WRKST ==.a | WRKST== .c | WRKST== .b | WRKST== .n | WRKST== .)
replace SOCMOBI_cat = . if (SOCMOBI_cat ==.a | SOCMOBI_cat== .c | SOCMOBI_cat== .b | SOCMOBI_cat== .n | SOCMOBI_cat== .)
replace GINI_SWIID_C = . if (GINI_SWIID_C ==.a | GINI_SWIID_C== .c | GINI_SWIID_C== .b | GINI_SWIID_C== .n | GINI_SWIID_C== .)
replace GDP_C = . if (GDP_C ==.a | GDP_C== .c | GDP_C== .b | GDP_C== .n | GDP_C== .)
replace UPWARD_macro_C = . if (UPWARD_macro_C ==.a | UPWARD_macro_C== .c | UPWARD_macro_C== .b | UPWARD_macro_C== .n | UPWARD_macro_C== .)
replace meritperc_volledig_threshmacro_C = . if (meritperc_volledig_threshmacro_C ==.a | meritperc_volledig_threshmacro_C== .c | meritperc_volledig_threshmacro_C== .b | meritperc_volledig_threshmacro_C== .n | meritperc_volledig_threshmacro_C== .)




/*******************************************************************************************************2. Main models**/

/*2.1 Regression Table 2*/
eststo clear
/*M1*/
eststo: xtmixed V32 AGE  i.male EDUC_C TOPBOT_C   meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C  meritperc_volledig_macro_C                                                                                         || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M2a*/
eststo: xtmixed V32 AGE  i.male EDUC_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M2b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.EDUC_C##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C EDUC_C, mle nolog
esttab using Mainmodel_sept.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using Mainmodel_sept.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast

/*2.2 Looking at the interaction effect more in detail Figure 3*/
xtmixed V32 AGE  i.male EDUC_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.TOPBOT##c.meritperc_volledig_macro                                           || COUNTRY: TOPBOT EDUC_C, mle nolog
su meritperc_volledig_macro
set scheme s1mono
margins, dydx(TOPBOT) at(meritperc_volledig_macro=(3.05(.10)3.96)) atmeans noatlegend
marginsplot,  recast(line) recastci(rline) ci1opts(lp(dash)) yline(0) l(95)


/*2.3 And at that of educ Figure 4*/

/*Looking at the interaction effect more in detail*/
xtmixed V32 AGE  i.male TOPBOT_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.educ##c.meritperc_volledig_macro                                           || COUNTRY: TOPBOT_C educ, mle nolog
su meritperc_volledig_macro
set scheme s1mono
margins, dydx(educ) at(meritperc_volledig_macro=(3.05(.10)3.96)) atmeans noatlegend
marginsplot,  recast(line) recastci(rline) ci1opts(lp(dash)) yline(0) l(95)



/***Table 4 Appendix: logistic**/
tab V32
recode V32 (4 5 = 1) (nonm=0),into(inequalitytolerance)

/**In many countries, the highest income group is rare. This gives estimation problems. So I make the income variable into a dichotomous one*/

recode TOPBOT (1 2 3 4 5 = 0) (6 7 8 9 10=1),into(HIGH_INCOME)


/*Table 4 Appendix Model*/
eststo clear
/*M1*/
eststo: xtmelogit inequalitytolerance AGE  i.male EDUC_C TOPBOT_C   meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C  meritperc_volledig_macro_C                                                                                         || COUNTRY: TOPBOT_C EDUC_C, intpoints(2)
/*M2a*/
eststo: xtmelogit inequalitytolerance AGE  i.male EDUC_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   C.TOPBOT_C##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C EDUC_C, intpoints(2)
/*M2b*/
eststo: xtmelogit inequalitytolerance AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.EDUC_C##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C EDUC_C, intpoints(2)
esttab using AppendixB_nov.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using AppendixB_nov.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast


/***** Appendix Table 5: True believers***/


/***Robustness check: people score at least a 4 on non-meritocratic factors (=unimportant) and the meritocratic ones (=important)*/
gen meritperc_positive = (meritperc_item1+meritperc_item2+meritperc_item8)/3

/**Keep people with missings*/
gen meritperc_positivemiss1 = (meritperc_item2+meritperc_item8)/2
gen meritperc_positivemiss2 = (meritperc_item1+meritperc_item8)/2
gen meritperc_positivemiss8 = (meritperc_item1+meritperc_item2)/2
replace meritperc_positive = meritperc_positivemiss1 if meritperc_item1==.&meritperc_item2!=.&meritperc_item8!=.
replace meritperc_positive = meritperc_positivemiss2 if meritperc_item1!=.&meritperc_item2==.&meritperc_item8!=.
replace meritperc_positive = meritperc_positivemiss8 if meritperc_item1!=.&meritperc_item2!=.&meritperc_item8==.
su meritperc_positive
pwcorr meritperc_positive meritperc_Larsen,sig

/* meritperc_negative = meritperc_Larsen!*/
gen meritperc_alt = 1 if meritperc_Larsen>=4&meritperc_positive>=4
replace meritperc_alt = 0 if meritperc_Larsen<4|meritperc_positive<4
replace meritperc_alt = . if meritperc_Larsen==.|meritperc_positive==.

/*macro*/
bys COUNTRY: egen meritperc_alt_macro = mean(meritperc_alt)
egen meritperc_alt_macro_mean = mean(meritperc_alt_macro)
gen meritperc_alt_macro_C = meritperc_alt_macro - meritperc_alt_macro_mean

/**Regression model Table 5 Appendix*/
eststo clear
/*M1*/
eststo: xtmixed V32 AGE  i.male EDUC_C TOPBOT_C   i.meritperc_alt   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C  meritperc_alt_macro_C                                                                                         || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M2a*/
eststo: xtmixed V32 AGE  i.male EDUC_C            i.meritperc_alt    i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_alt_macro_C                                           || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M2b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           i.meritperc_alt    i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.EDUC_C##c.meritperc_alt_macro_C                                           || COUNTRY: TOPBOT_C EDUC_C, mle nolog
esttab using AppendixB_sept.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using AppendixB_sept.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast




/***Table 6 Appendix: additional interactions*/

eststo clear
/*M3a*/
eststo: xtmixed V32 AGE  i.male EDUC_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C                                                    c.TOPBOT_C##c.meritperc_volledig_macro_C    c.TOPBOT_C##c.UPWARD_macro_C           || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M4a*/
eststo: xtmixed V32 AGE  i.male EDUC_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C         UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_volledig_macro_C    c.TOPBOT_C##c.GDP_C                    || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M6a*/
eststo: xtmixed V32 AGE  i.male EDUC_C            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat              GDP_C   UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_volledig_macro_C    c.TOPBOT_C##c.GINI_SWIID_C               || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M7a*/
eststo: xtmixed V32 AGE  i.male EDUC_C                                   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_volledig_macro_C      c.TOPBOT_C##c.meritperc_volledig_C         || COUNTRY: TOPBOT_C EDUC_C, mle nolog

/***Table 7 Appendix: additional interactions*/
/*M3b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C                                                    c.EDUC_C##c.meritperc_volledig_macro_C    c.EDUC_C##c.UPWARD_macro_C           || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M4b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C         UPWARD_macro_C                                   c.EDUC_C##c.meritperc_volledig_macro_C    c.EDUC_C##c.GDP_C                    || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M6b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat              GDP_C   UPWARD_macro_C                                   c.EDUC_C##c.meritperc_volledig_macro_C    c.EDUC_C##c.GINI_SWIID_C               || COUNTRY: TOPBOT_C EDUC_C, mle nolog
/*M7b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C                                  i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.EDUC_C##c.meritperc_volledig_macro_C    c.EDUC_C##c.meritperc_volledig_C         || COUNTRY: TOPBOT_C EDUC_C, mle nolog
esttab using appendix_A_nov.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using appendix_A_nov.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast



/***Appendix Table 8: an 'irrelevant' cleavage*/

eststo clear
/*M1*/
eststo: xtmixed V32 AGE  i.male EDUC_C TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C  meritperc_volledig_macro_C                                                                                         || COUNTRY: R.male, mle nolog
/*M2 another cleavage:gender*/
eststo: xtmixed V32   AGE EDUC_C   TOPBOT_C         meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   i.male##c.meritperc_volledig_macro_C                                           || COUNTRY:  R.male, mle nolog
esttab using AppendixC_nov.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using AppendixC_nov.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast




/*****Robusness: two other measure of education**/

eststo clear
/*M1*/
eststo: xtmixed V32 AGE  i.male i.DEGREE TOPBOT_C   meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C  meritperc_volledig_macro_C                                                                                         || COUNTRY: TOPBOT_C DEGREE, mle nolog
/*M2a*/
eststo: xtmixed V32 AGE  i.male i.DEGREE            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C DEGREE, mle nolog
/*M2b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   i.DEGREE##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C DEGREE, mle nolog
esttab using Mainmodel_march.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) se(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using Mainmodel_march.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) se(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast



bys COUNTRY: egen educ_A_country = mean(educ)
bys COUNTRY: gen educ_C_country = educ - educ_A_country

tab COUNTRY, nola


/****Main models**/

eststo clear
/*M1*/
eststo: xtmixed V32 AGE  i.male educ_C_country TOPBOT_C   meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C  meritperc_volledig_macro_C                                                                                         || COUNTRY: TOPBOT_C educ_C_country, mle nolog
/*M2a*/
eststo: xtmixed V32 AGE  i.male educ_C_country            meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.TOPBOT_C##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C educ_C_country, mle nolog
/*M2b*/
eststo: xtmixed V32 AGE  i.male        TOPBOT_C           meritperc_volledig_C   i.MIDDLECLASS_PERC_micro i.WRKST i.SOCMOBI_cat GINI_SWIID_C GDP_C   UPWARD_macro_C                                   c.educ_C_country##c.meritperc_volledig_macro_C                                           || COUNTRY: TOPBOT_C educ_C_country, mle nolog
esttab using Mainmodel_march2.txt, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
esttab using Mainmodel_march2.rtf, replace star(+ 0.1 * 0.05 ** 0.01 *** 0.001) b(3) t(3) sca(r2_p ll df_m chi2  aic bic  N_sub N) obslast
