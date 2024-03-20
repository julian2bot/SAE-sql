-- MARQUES_Julian.sql
-- Devoir 178
-- Nom: MARQUES , Prenom: Julian

-- Feuille SAE2.04 Exploitation d'une base de donn�es

-- Veillez � bien r�pondre aux emplacements indiqu�s.
-- Seule la premi�re requ�te est prise en compte.

-- +-----------------------+--
-- * Question 178107 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Quelles sont les formations offertes par l'IUT d'Orl�ans en 2023? 
--  On veut le num�ro de formation, la fili�re, le nom (fil_lib_voe_acc)

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom! 
-- +----------+----------------------------------------------------------+---------------------+----------+-------------------+
-- | num_form | fil_lib_voe_acc | select_form | num_fili | fili |
-- +----------+----------------------------------------------------------+---------------------+----------+-------------------+
-- | etc... 
-- = Reponse question 178107.

-- select num_form, fil_lib_voe_acc, select_form, num_fili, fili, session
--     from FILIERE natural join FORMATION natural join VOEUX natural join STATS natural join ETABLISSEMENT
--         where session = 2023 and cod_uai ="0450092F"; -- code Uai qui correponds a I.U.T d'orleans
-- OU
select num_form, fil_lib_voe_acc, select_form, num_fili, fili, session
    from FILIERE natural join FORMATION natural join VOEUX natural join STATS natural join ETABLISSEMENT
        where session = 2023 and g_ea_lib_vx ="I.U.T d'Orléans";
    

-- +-----------------------+--
-- * Question 178152 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Quels sont les �tablissements de la Creuse qui offrent un BTS? 
--  On veut le code uai, le nom de l'�tablissement ( g_ea_lib_vx) et 
--  la ville.

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +----------+----------------------------------+------------+------+
-- | cod_uai  | g_ea_lib_vx                      | ville_etab | FILI |
-- +----------+----------------------------------+------------+------+
-- | etc...
-- = Reponse question 178152.
SELECT cod_uai, g_ea_lib_vx, ville_etab, fili
FROM ETABLISSEMENT natural JOIN DEPARTEMENT natural join VOEUX natural join FORMATION natural join FILIERE
WHERE dep_lib = 'Creuse'
AND fili = 'BTS'
group by cod_uai;


-- +-----------------------+--
-- * Question 178185 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Combien de candidats ont �t� class�s lors de la phase principale 
--  de 2023 par les diff�rents �tablissements qui d�livrent le BUT QLIO? aka "Qualité, logistique industrielle et organisation"
--  On veut le code uai, le nom et la ville de l'�tablissement et le nombre
--  de class�s lors de la phase principale (nb_cla_pp)

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +----------+-----------------------------------------------------+--------------------+-----------+
-- | cod_uai  | g_ea_lib_vx                                         | ville_etab         | nb_cla_pp |
-- +----------+-----------------------------------------------------+--------------------+-----------+
-- | etc...
-- = Reponse question 178185.

SELECT e.cod_uai, e.g_ea_lib_vx, e.ville_etab, s.nb_cla_pp
FROM ETABLISSEMENT e
JOIN VOEUX v ON e.cod_uai = v.cod_uai
JOIN STATS s ON v.num_voe = s.num_voe natural join FORMATION f
WHERE f.fil_lib_voe_acc = "Qualité, logistique industrielle et organisation"
AND s.session = 2023;

-- +-----------------------+--
-- * Question 178208 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  La liste des lyc�es publics du Loiret

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +----------+----------------------------------------+-------------------------+
-- | cod_uai  | g_ea_lib_vx | ville_etab |
-- +----------+----------------------------------------+-------------------------+
-- | etc...
-- = Reponse question 178208.

select cod_uai, g_ea_lib_vx, ville_etab
from ETABLISSEMENT natural join DEPARTEMENT 
where contrat_etab = "Public" and dep_lib="Loiret" and g_ea_lib_vx like ("%lycee%");


-- +-----------------------+--
-- * Question 178253 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Donner la liste des d�partements dans lesquels il n'y a aucune offre 
--  de BUT

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +-----+-----------------+
-- | dep | dep_lib         |
-- +-----+-----------------+
-- | etc...
-- = Reponse question 178253.

-- REVOIR ! 666
-- SELECT distinct dep, dep_lib
-- FROM DEPARTEMENT
-- natural JOIN ETABLISSEMENT WHERE dep NOT IN (
--     SELECT DISTINCT dep FROM ETABLISSEMENT natural join VOEUX 
--     natural join FORMATION natural join FILIERE where fili='BUT'
-- );

SELECT distinct dep, dep_lib
FROM DEPARTEMENT
natural JOIN ETABLISSEMENT WHERE not exists (
    SELECT DISTINCT * FROM ETABLISSEMENT natural join VOEUX 
    natural join FORMATION natural join FILIERE where fili='BUT'
) ORDER BY dep;

-- SELECT distinct dep, dep_lib
-- FROM DEPARTEMENT
-- natural JOIN ETABLISSEMENT WHERE exists (
--     SELECT DISTINCT * FROM ETABLISSEMENT natural join VOEUX 
--     natural join FORMATION natural join FILIERE where fili='BUT'
-- );

-- +-----------------------+--
-- * Question 178309 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Donner la liste des �tablissements qui offrent � la fois 
--  une licence de Droit et une licence informatique

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +----------+--------------------------------------------------------------+----------------+
-- | cod_uai  | g_ea_lib_vx | ville_etab     | --
-- +----------+--------------------------------------------------------------+----------------+
-- | etc...
-- = Reponse question 178309.

    SELECT cod_uai, g_ea_lib_vx, ville_etab
    FROM ETABLISSEMENT natural join VOEUX natural join FORMATION natural join FILIERE
    WHERE fili = 'Licence' and fil_lib_voe_acc="Informatique"
intersect 
    SELECT cod_uai, g_ea_lib_vx, ville_etab
    FROM ETABLISSEMENT natural join VOEUX natural join FORMATION natural join FILIERE
    WHERE fili = 'Licence' and fil_lib_voe_acc="Droit";

-- -- +-----------------------+--
-- -- * Question 178321 : 2pts --
-- -- +-----------------------+--
-- -- Ecrire une requ�te qui renvoie les informations suivantes:
-- --  Donner la liste des �tablissements de l'acad�mie de Versailles qui 
-- -- n'offrent que des Licences

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +----------+---------------------------------------------------------------------------------+---------------------+
-- | cod_uai  | g_ea_lib_vx | ville_etab | --
-- +----------+---------------------------------------------------------------------------------+---------------------+
-- | etc...
-- = Reponse question 178321.

select distinct cod_uai, g_ea_lib_vx, ville_etab, fili, acad_mies
from ETABLISSEMENT natural join DEPARTEMENT natural join ACADEMIE 
natural join VOEUX natural join FORMATION natural join FILIERE
where acad_mies ="Versailles" and fili="Licence"; 

--  OU (qui est theoriquement mieux ?)
-- SELECT cod_uai, g_ea_lib_vx, ville_etab, fili, acad_mies
-- from ETABLISSEMENT natural join DEPARTEMENT natural join ACADEMIE 
-- natural join VOEUX natural join FORMATION natural join FILIERE
-- WHERE acad_mies = "Versailles" 
-- AND fili = "Licence"
-- AND cod_uai NOT IN (
--     SELECT cod_uai
--     FROM FORMATION
--     WHERE num_form NOT IN (
--         SELECT num_form
--         FROM FORMATION
--         WHERE fili = "Licence"
--     )
-- );


-- +-----------------------+--
-- * Question 178376 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Donner pour chaque type de filiere le nombre d'�tablissements 
--  priv�s offrant des places de cette fili�re

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +-------------------+-------+
-- | fili              | nb_et |
-- +-------------------+-------+
-- | etc...
-- = Reponse question 178376.

-- select fili, count(cod_uai) nb_et 
-- from ETABLISSEMENT natural join VOEUX natural join FORMATION natural join FILIERE
-- where contrat_etab = "Privé enseignement supérieur" group by fili;
select fili, count(cod_uai) nb_et 
from ETABLISSEMENT natural join VOEUX natural join FORMATION natural join FILIERE
where contrat_etab like "%Privé%" group by fili;

-- select *
-- from ETABLISSEMENT natural join VOEUX natural join FORMATION natural join FILIERE
--  group by fili;

-- select *
-- from FORMATION natural join FILIERE
--  group by fili;


-- +-----------------------+--
-- * Question 178400 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Donner le nombre de candidatures en BUT lors de la phase principale 
--  de 2022 par acad�mie

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +---------------------+------------+
-- | acad_mies           | nb_voe_but |
-- +---------------------+------------+
-- | etc...
-- = Reponse question 178400.

select acad_mies, sum(voe_tot) nb_voe_but from
ACADEMIE natural join DEPARTEMENT natural join ETABLISSEMENT natural join VOEUX 
natural join FORMATION natural join FILIERE natural join STATS
where fili = "BUT" and session = 2022 group by acad_mies;



-- +-----------------------+--
-- * Question 178433 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Donner la ou les formations qui ont re�u le plus de voeux en phase 
--  principale en 2023

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +----------+-------------+--------------+-------------------+-----------+
-- | cod_uai  | g_ea_lib_vx | ville_etab   | fili | nb_voe_pp | --
-- +----------+-------------+--------------+-------------------+-----------+
-- | etc...
-- = Reponse question 178433.


select cod_uai, g_ea_lib_vx, ville_etab, fili, max(nb_voe_pp) 
from ACADEMIE natural join DEPARTEMENT natural join ETABLISSEMENT natural join 
VOEUX natural join FORMATION natural join FILIERE natural join STATS
where session = 2023 and nb_voe_pp = 
(select max(nb_voe_pp) from stats);

-- +-----------------------+--
-- * Question 178466 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Donner la liste des r�gions qui ont re�u plus de voeux en 2022 
--  qu'en 2023

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +-------------------------+
-- | region_etab_aff         |
-- +-------------------------+
-- | etc...
-- = Reponse question 178466.

-- select region1.region_etab_aff, 
--        region1.nb_voeux "session 2022", 
--        region2.nb_voeux "session 2023" 
-- from (
-- select sum(voe_tot) AS nb_voeux, region_etab_aff 
-- from REGION natural join DEPARTEMENT natural join Etablissement natural join VOEUX natural join STATS 
-- where session = 2022 group by region_etab_aff
-- )  AS region1 join (
-- select sum(voe_tot)  AS nb_voeux, region_etab_aff 
-- from REGION natural join DEPARTEMENT natural join Etablissement natural join VOEUX natural join STATS 
-- where session = 2023 group by region_etab_aff 
-- ) AS region2 ON region1.region_etab_aff = region2.region_etab_aff
--  where region1.nb_voeux > region2.nb_voeux;

select region1.region_etab_aff

from (
select sum(voe_tot) AS nb_voeux, region_etab_aff 
from REGION natural join DEPARTEMENT natural join Etablissement natural join VOEUX natural join STATS 
where session = 2022 group by region_etab_aff
)  AS region1 join (
select sum(voe_tot)  AS nb_voeux, region_etab_aff 
from REGION natural join DEPARTEMENT natural join Etablissement natural join VOEUX natural join STATS 
where session = 2023 group by region_etab_aff 
) AS region2 ON region1.region_etab_aff = region2.region_etab_aff
 where region1.nb_voeux > region2.nb_voeux;

-- +-----------------------+--
-- * Question 178512 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Requ�te pour le 1er graphique

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +-------------------+---------+
-- | fili              | nb_form |
-- +-------------------+---------+
-- | etc...
-- = Reponse question 178512.
-- select fili, count(num_form) nb_form 
-- from FORMATION natural join FILIERE natural join VOEUX natural join STATS 
-- where session = 2023 group by fili;

select fili, count(num_form) nb_form 
from FORMATION natural join FILIERE natural join VOEUX natural join STATS natural join ETABLISSEMENT natural join DEPARTEMENT natural join ACADEMIE
where session = 2023 group by fili, acad_mies having acad_mies like "Orléans-Tours";



-- +-----------------------+--
-- * Question 178567 : 2pts --
-- +-----------------------+--
-- Ecrire une requ�te qui renvoie les informations suivantes:
--  Requ�te pour le 2eme graphique

-- Voici le d�but de ce que vous devez obtenir.
-- ATTENTION � l'ordre des colonnes et leur nom!
-- +-------------------+----------+
-- | filiere           | nb_voeux |
-- +-------------------+----------+
-- | etc...
-- = Reponse question 178567.


-- select fili filiere, ifnull(sum(capa_fin),0) nb_voeux 
-- from FILIERE natural left join FORMATION natural left join VOEUX natural  join STATS
-- where session = 2023 and select_form ="formation sélective" group by fili order by nb_voeux desc;

-- select fili filiere, ifnull(sum(capa_fin),0) nb_voeux 
-- from FILIERE natural left join FORMATION natural left join VOEUX natural  join STATS
-- where session = 2023 and select_form ="formation sélective" group by fili order by nb_voeux desc;

-- create or replace view fili2023 as (
--     select fili, capa_fin 
--         from FILIERE natural left join FORMATION natural left join VOEUX natural join STATS
--             where session = 2023 and select_form = "formation sélective"
--                 );

-- select fili filiere, ifnull(sum(capa_fin),0) nb_voeux 
--     from FILIERE natural left join fili2023 
--         group by fili 
--             order by nb_voeux desc;

with fili2023 (fili, capa_fin) as (
    select fili, capa_fin 
        from FILIERE natural left join FORMATION natural left join VOEUX natural join STATS
            where session = 2023 and select_form = "formation sélective"
                )

select fili filiere, ifnull(sum(capa_fin),0) nb_voeux 
    from FILIERE natural left join fili2023 
        group by fili 
            order by nb_voeux desc;

-- +-------------------+----------+-------------------+
-- | 4 Insertion dans la base de données
-- | Indiquez les insertions à effectuer dans la base de données pour indiquer qu’un nouveau lycée
-- | public appelé Lucie Aubrac a ouvert à Orléans. Ce lycée porte le code 0459876L et a proposé 15
-- | places pour un BTS Gestion forestière en 2023 (tous les autres chiffres étant positionnés à NULL).
-- +-------------------+----------+-------------------+


-- INSERT INTO ETABLISSEMENT(cod_uai, g_ea_lib_vx, contrat_etab, dep, ville_etab) VALUES
-- 		('0459876L', 'Lucie Aubrac', 'Public', '45', 'Orléans');

-- -- INSERT INTO FILIERE(num_fili, fili) VALUES
-- -- 		(2, 'BTS');
-- INSERT INTO FORMATION(num_form, fil_lib_voe_acc, select_form, num_fili) VALUES
-- 		(572, "BTS Gestion forestière", 'formation sélective', 2);

-- INSERT INTO DEPARTEMENT(dep, dep_lib, num_reg, num_aca) VALUES
-- 		('45', 'Loiret', 5, 5);

-- INSERT INTO STATS(session, capa_fin, voe_tot, voe_tot_f, nb_voe_pp, nb_voe_pp_internat, nb_voe_pp_bg, nb_voe_pp_bg_brs, nb_voe_pp_bt, nb_voe_pp_bt_brs, nb_voe_pp_bp, nb_voe_pp_bp_brs, nb_voe_pp_at, nb_voe_pc, nb_voe_pc_bg, nb_voe_pc_bt, nb_voe_pc_bp, nb_voe_pc_at, nb_cla_pp, nb_cla_pc, nb_cla_pp_internat, nb_cla_pp_pasinternat, nb_cla_pp_bg, nb_cla_pp_bg_brs, nb_cla_pp_bt, nb_cla_pp_bt_brs, nb_cla_pp_bp, nb_cla_pp_bp_brs, nb_cla_pp_at, prop_tot, acc_tot, acc_tot_f, acc_pp, acc_pc, acc_debutpp, acc_datebac, acc_finpp, acc_internat, acc_brs, acc_neobac, acc_bg, acc_bt, acc_bp, acc_at, acc_mention_nonrenseignee, acc_sansmention, acc_ab, acc_b, acc_tb, acc_tbf, acc_bg_mention, acc_bt_mention, acc_bp_mention, acc_term, acc_term_f, acc_aca_orig, acc_aca_orig_idf, prop_tot_bg, prop_tot_bg_brs, prop_tot_bt, prop_tot_bt_brs, prop_tot_bp, prop_tot_bp_brs, prop_tot_at, lib_grp1, ran_grp1, lib_grp2, ran_grp2, lib_grp3, ran_grp3, num_voe) VALUES
-- 		(2023, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Autres candidats',NULL, NULL, 'Autres formations',NULL, NULL, NULL, NULL, NULL);

-- OU

-- INSERT INTO STATS(session, capa_fin) VALUES (2023, 15);


-- +-------------------+----------+-------------------+
-- | 7 Analyse statistique
-- | L’objectif de cette partie est d’analyser certaines données de la base d’un point de vue statistique.
-- | Les notations utilisées ici sont celles du cours de statistiques descriptives.
-- |
-- | 1) Extraire de la base de données le nombre de formations par région en 2022, vous obtenez un
-- | premier jeu de 21 données notée V. Calculez
-- | (bar)V =
-- | La médiane de V =
-- | Le mode de V =
-- +-------------------+----------+-------------------+

-- select count(num_form) nb_form, region_etab_aff from REGION natural join DEPARTEMENT 
-- natural join ETABLISSEMENT natural join VOEUX natural join STATS 
-- where session = 2022 group by region_etab_aff;

-- +-------------------+----------+-------------------+
-- | 7 Analyse statistique
-- | L’objectif de cette partie est d’analyser certaines données de la base d’un point de vue statistique.
-- | Les notations utilisées ici sont celles du cours de statistiques descriptives.
-- |
-- | 1) Extraire de la base de données le nombre de formations par région en 2022, vous obtenez un
-- | premier jeu de 21 données notée V. Calculez
-- | (barre)V = 570.15
-- | La médiane de V = 506
-- | Le mode de V = 1336
-- |
-- |2) Extraire le nombre de candidatures effectuées par région en 2022 lors de la phase principale,
-- | ces valeurs constituent une seconde statistique notée E. Vous obtenez ainsi la statistique double
-- | (V, E). Tracez le nuage de points (V, E).
-- | Voyez-vous apparaitre (visuellement) une corrélation linéaire entre V et E ?
-- | Oui on peut en appercevoir une (la ou il y a le plus gros des points on peut appercevoir vers ou elle sera)
-- |
-- | Calculez le coefficient de corrélation ρV,E du couple (V, E)
-- | ρV,E =  0.4899266024077246
-- | Qu’en déduisez vous ?
-- | une corrélation de 0.4899 est une corrélation positive entre ces deux ensembles on sait que si l'un monde l'autre aussi et vice versa
-- |
-- | 3) En vous servant d’un outil mathématiques de prédiction vu en cours de statistiques, quel
-- | nombre de candidatures minimum anticipez-vous si le nombre de formations d’une région augmente 
-- | au-delà de 2500 ? (Détaillez votre démarche et vos calculs)
-- | jsp
-- |
-- |
-- | VOIR AnalyseStatistique.py
-- +-------------------+----------+-------------------+




