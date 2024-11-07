
# Bouton Run

# R est une calculatrice:
1 + 1

# Nous allons garder en mémoire plusieurs chiffres:
mes_chiffres <- c(1, 3, 5, 6, 7, 16, 23, 25, 28)
# R contient des instructions pré-définies qu'on peut utiliser
# sur notre liste de chiffres.
# Nous allons faire la somme de tous les éléments dans mes_chiffres:
sum(mes_chiffres)

# Nous allons remplacer 23 par 24 et refaire la somme:
mes_chiffres <- c(1, 3, 5, 6, 7, 16, 24, 25, 28)
# L'instruction pour faire la somme est la même!
sum(mes_chiffres)

# On peut complétement remplacer les chiffres:
mes_chiffres <- c(57, 46, 1, 23, 56, 27, 5, 17, 18, 19)
sum(mes_chiffres)

# Une autre instruction pour R: imprimer un texte:
texte <- "Bonjour la planète! Moi, c'est Tania"
print(texte)

# Mon premier programme: imprimer une salutation pour chaque participant:
prenom <- c("Tania", "Marguerite", "Rose", "Celia")

# On utilise une boucle qui reproduit la même salutation pour 
# chaque prénom:
for (i in 1:length(prenom)) {
  print( paste0("Bonjour la planète! Moi, c'est ", prenom[i]))
}

# Trouver 3 bases d'ADN dans un gène:
mon_gene <- "ATTCGGTATCCTAGTCATCG"
a_chercher <- "TAT"
# L'instruction grep permet de trouver des lettres dans un mélange
# de lettres plus long. Si la réponse =1, les lettres sont présentes.
# Si la réponse = integer(0), les lettres ne sont pas présentes.
grep(a_chercher, mon_gene)


# Les chats ont la gingivite !
# Create csv for all "final" files just before pca and heatmap.
# Import df with filtered counts without case20, use Import dataset in Files panel

load(selected var genes)
View()



