import matplotlib.pyplot as plt
# import seaborn as sns
import pymysql  
from collections import Counter
import numpy as np
from decimal import *


################################
# Sql : connection au serveur sql (aka notre machine, user qui est le root, le mdp et le nom de la databse qu'on utilisera)
################################
conn = pymysql.connect(host='localhost', user='root', password='marques', database='saesql')
cursor = conn.cursor()  


    ##############################
    # PARTIE 1
    ##############################

##############################
# requete : V
##############################
sql_query = """
select count(num_form) nb_form, region_etab_aff 
    from REGION natural join DEPARTEMENT natural join ETABLISSEMENT natural join VOEUX natural join STATS 
        where session = 2022 group by region_etab_aff;
"""
cursor.execute(sql_query)
results = cursor.fetchall()


###########################################
# recuperation des donnée dans des listes
###########################################
nb_form = [row[0] for row in results]
region_etab_aff = [row[1] for row in results]
print("\033[1;33m nb_form : \033[0m",nb_form)
print("\033[1;33m region_etab_aff : \033[0m",region_etab_aff)


##############################
# V barre (la moyenne de V)
##############################
res = 0

for i in range(len(nb_form)):
    res += nb_form[i]
    
moyenne = res / (i+1)
print("\033[1;33m V(barre) : \033[0m", moyenne)


##############################
# Calcul de la médiane
##############################

tri_nb_form = sorted(nb_form)

n = len(tri_nb_form)
if n % 2 == 0:
    median = (tri_nb_form[n // 2 - 1] + tri_nb_form[n // 2]) / 2
else:
    median = tri_nb_form[n // 2]
print("\033[1;32m La median de V est:", median,"\033[0m")

##############################
# Calcul du mode
##############################


mode_counter = Counter(nb_form)
mode = mode_counter.most_common(1)[0][0]
print("\033[1;31m le mode de V est:", mode,"\033[0m")


# x=[] # juste une liste de [0,1,2,3....,n] pour avoir des valeurs pour afficher les courbes
# for i in range(len(nb_form)):
#     x.append(i)
x = region_etab_aff
###########################################
# Tracer la courbe
###########################################
plt.plot(x, nb_form)
plt.plot(x, [median]*len(x), color='green', label='median')
plt.plot(x, [mode]*len(x), color='red', label='mode')

plt.title('affichage de nb_form en fonction de la quantité (de region)')

plt.ylabel('nb_from')
plt.xlabel('les regions')
plt.xticks(rotation=45, ha='right')

plt.legend(loc='upper right')
plt.grid(True)
plt.show()


    ##############################
    # PARTIE 2
    ##############################

##############################
# requete : E
##############################
# sql_query = "select nb_voe_pp nb_candi, region_etab_aff from REGION natural join DEPARTEMENT natural join ETABLISSEMENT natural join VOEUX natural join STATS where session = 2022 group by region_etab_aff;"
sql_query = """select nb_form,nb_candi, A.region_etab_aff from
(select count(num_form) nb_form, region_etab_aff 
    from REGION natural join DEPARTEMENT natural join ETABLISSEMENT natural join VOEUX natural join STATS 
    where session = 2022 group by region_etab_aff) AS A
JOIN
    (select sum(nb_voe_pp) nb_candi, region_etab_aff 
    from REGION natural join DEPARTEMENT natural join ETABLISSEMENT natural join VOEUX natural join STATS
    where session = 2022 group by region_etab_aff
) AS B ON A.region_etab_aff=B.region_etab_aff group by B.region_etab_aff;"""

cursor.execute(sql_query)
results = cursor.fetchall()

##############################
# corrélation entre V & E
##############################

###########################################
# recuperation des donnée dans des listes
###########################################
v = [row[0] for row in results]
e = [int(row[1]) for row in results]
region_etab_aff1 = [row[2] for row in results]
print("region_etab_aff1", region_etab_aff1)
print("\033[1;33m E: \033[0m",e)
print("\033[1;33m V: \033[0m",v)
print("\033[1;33m E: \033[0m",len(e))
print("\033[1;33m V: \033[0m",len(v))

# faux resultat de requete: (pour des tests sans base de données)
# v = [1336, 506, 614, 386, 62, 14, 970, 111, 54, 1094, 1871, 215, 108, 39, 544, 989, 1003, 674, 67, 744, 2]
# e = [10572, 3902, 5221, 3065, 555, 92, 7382, 785, 505, 8336, 17027, 1850, 769, 251, 4147, 9085, 9326, 6419, 534, 6987, 14]

plt.figure(figsize=(8, 6))
plt.scatter(v, e, color='blue', alpha=0.5)

######################################
# courbe de corrélation entre V & E
######################################
# correlation = np.corrcoef(v, e)[0, 1]
# print("\033[1;33m Corrélation entre e et v : \033[0m", correlation)
# coefficients = np.polyfit(e, v, 1) # Régression linéaire d'ordre 1 (linéaire)
# p = np.poly1d(coefficients)  
# plt.plot(p(e), e, color='red', label='Régression linéaire')

########################################################################################################################################################
correlation = np.corrcoef(v, e)[0, 1]
print("\033[1;33m Corrélation entre e et v : \033[0m", correlation)
coefficients = np.polyfit(e, v, 1) # Régression linéaire d'ordre 1 (linéaire)
p = np.poly1d(coefficients)  
plt.plot(p(e), e, color='red', label='Régression linéaire')

from scipy import stats
#linregress() renvoie plusieurs variables de retour. On s'interessera 
# particulierement au slope et intercept
slope, intercept, r_value, p_value, std_err = stats.linregress(v, e)
print('prediction pour 2500:', slope * 2500 + intercept)
print('prediction a b :', slope, intercept)
########################################################################################################################################################
a,b = slope, intercept

print("La droite de régression linéaire a pour équation y=",round(a,3),"x+",round(b,3))
print("a:",a, "b:",+b)
x1=2500
calcRG=a*x1+b   
print("calcul de prediction avec","\nax+b","\na:",a,"x:",+x1, "b:",+b, "\n=", calcRG )
plt.axhline(y=calcRG,color='gray',linestyle='--')
plt.axvline(x=x1,color='gray',linestyle='--')



######################################
#   prediction, courbe representation
######################################

# a,b = 0.0008718, 155.05281 # valeur de scilab pour CETTE regression

# print("La droite de régression linéaire a pour équation y=",round(a,3),"x+",round(b,3))
# print("a:",a, "b:",+b)
# x1=2500
# calcRG=a*x1+b 
# print("calcul de prediction avec","\nax+b","\na:",a,"x:",+x1, "b:",+b, "\n=", calcRG*10**4 )
# # plt.axhline(y=calcRG*10**4,color='gray',linestyle='--')
# # plt.axvline(x=x1,color='gray',linestyle='--')




##############################################
# courbe de moyenne entre V & E (vaux rien)
##############################################
moyenne_v_e = [] 
for i    in range(len(v)):
    var= (v[i]+e[i])//2
    moyenne_v_e.append(var)
print("\033[1;32mmoyenne:",moyenne_v_e,"\033[0m")
# plt.plot(v, moyenne_v_e, color='green', label='moyenne')
# plt.plot(moyenne_v_e, e, color='yellow', label='moyennev2')

# plt.plot(e, x1, color='yellow', label='moyennev2')
# plt.plot(v, v, color='green', label='moyennev2')



plt.xlabel('Nombre de formations par région en 2022 (V)')
plt.ylabel('Nombre de candidatures par région en 2022 (E) (*10000)')
plt.title('Nuage de points (V, E)')

plt.legend(loc='upper right')
plt.grid(True)
plt.show()


############################################################
# calcul coefficient de corelation P_V,E du couple (V,E)
# P_V,E =  0.4899266024077246
# Déduction: une corrélation de 0.4899 est une corrélation 
# positive entre ces deux ensembles on sait que si l'un monde
# l'autre aussi et vice versa
############################################################
import numpy as np

correlation_coefficient = np.corrcoef(v, e)[0, 1]
print("\033[1;33m Coefficient de corrélation ρV,E : \033[0m", correlation_coefficient)


    ##############################
    # PARTIE 3
    ##############################
# 3) En vous servant d’un outil mathématiques de prédiction vu en cours de statistiques, quel
# nombre de candidatures minimum anticipez-vous si le nombre de formations d’une région augmente au-delà de 2500 ? 
# (Détaillez votre démarche et vos calculs)

# 

##################################
# Sql : fermer l'acces au serveur
##################################
cursor.close()
conn.close()

