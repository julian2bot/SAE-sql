###########################################
# Import : les imports essentiels au code
###########################################
import matplotlib.pyplot as plt
import seaborn as sns
import pymysql  

################################
# Sql : connection au serveur sql (aka notre machine, user qui est le root, le mdp et le nom de la databse qu'on utilisera)
################################
conn = pymysql.connect(host='localhost', user='root', password='marques', database='saesql')
cursor = conn.cursor()  

################################
# requete : graphique camembert
################################
sql_query = "select fili, count(num_form) nb_form from FORMATION natural join FILIERE natural join VOEUX natural join STATS natural join ETABLISSEMENT natural join DEPARTEMENT natural join ACADEMIE where session = 2023 group by fili, acad_mies having acad_mies like \"Orléans-Tours\";"
cursor.execute(sql_query)
results = cursor.fetchall()

##############################
# graphique camembert
##############################
def somme(list):
    res = 0
    for elem in list:
        res +=elem
    return res
    
labels = [row[0] for row in results]
sizes = [row[1] for row in results]
print(labels)
print(sizes)
somme_max = somme(sizes)

plt.figure(figsize=(8, 6))
plt.pie(sizes, labels=labels,  shadow = True,radius = 1.20 , autopct=lambda x: f'{x*somme_max/100:.0f}',  startangle=140)
plt.axis('equal') 
plt.title('Nombre de formations proposées par type de filiere en 2023')

plt.legend(loc='upper right')
plt.show()


######################################################################################################################################################
######################################################################################################################################################


##############################
# requete : graphique en barres
##############################
sql_query2 = """
with fili2023 (fili, capa_fin) as (
    select fili, capa_fin 
        from FILIERE natural left join FORMATION natural left join VOEUX natural join STATS
            where session = 2023 and select_form = "formation sélective"
                )

select fili filiere, ifnull(sum(capa_fin),0) nb_voeux 
    from FILIERE natural left join fili2023 
        group by fili 
            order by nb_voeux desc;
"""
cursor.execute(sql_query2)
results2 = cursor.fetchall()
##############################
# graphique en barres
##############################
sorted_results = sorted(results2, key=lambda x: x[1], reverse=True)
labels = [row[0] for row in sorted_results]
sizes = [int(row[1]) for row in sorted_results]
print(labels)
print(sizes)

plt.figure(figsize=(10, 6))
# plt.pie(sizes, labels=labels, autopct=lambda x: f'{x*somme_max/100:.0f}',  startangle=140)

sns.barplot(x=labels, y=sizes)
plt.xticks(rotation=45, ha='right')
plt.xlabel('Formation')
plt.ylabel('Total du nombre de formations')
plt.title('Nombre de places dans les formations selectives en 2023 par filière')
plt.legend(['nb_places_selectives'])
for i in range(len(labels)):
    plt.text(i, sizes[i] + 20, sizes[i], ha='center', va='bottom')

plt.tight_layout()
plt.show()


##################################
# Sql : fermer l'acces au serveur
##################################
cursor.close()
conn.close()

