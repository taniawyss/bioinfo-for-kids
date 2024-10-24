
# R est une calculatrice:
1 + 1

# R contient des instructions pré-définies:
mes_chiffres <- c(1, 3, 5, 6, 7, 16, 23, 25, 28)
# Nous allons faire la somme de tous les éléments dans mes_chiffres:
sum(mes_chiffres)

# Nous allons remplacer 23 par 24 et refaire la somme:
mes_chiffres <- c(1, 3, 5, 6, 7, 16, 24, 25, 28)
sum(mes_chiffres)

# On peut complétement remplacer les chiffres:
mes_chiffres <- c(57, 46, 1, 23, 56, 27, 5, 17, 18, 19)
sum(mes_chiffres)

# Une autre instruction pour R: imprimer un texte:
texte <- "Bonjour la planète! Moi, c'est Tania"
print(texte)

# Mon premier programme: imprimer une salutation pour chaque participant:
prenom <- c("Tania", "Marguerite", "Rose", "Celia")

for (i in 1:length(prenom)) {
  print( paste0("Bonjour la planète! Moi, c'est ", prenom[i]))
}

# Trouver 3 bases d'ADN dans un gène:
mon_gene <- "ATTCGGTATCCTAGTCATCG"
a_chercher <- "TAT"
grep(a_chercher, mon_gene)


# Les chats ont la gingivite!



