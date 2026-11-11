library(ggplot2)
library(ggrepel)

## Explorer R

# Bouton Run

# R est une calculatrice:
1 + 1

# La programmation: un langage à apprendre et à pratiquer.

# Nous allons garder en mémoire plusieurs chiffres:
mes_chiffres <- c(1, 3, 5, 6, 7, 16, 23, 25, 28)
# R contient des instructions pré-définies qu'on peut utiliser
# sur notre liste de chiffres.
# Nous allons faire la somme de tous les éléments dans mes_chiffres:
sum(mes_chiffres)

# Une autre instruction pour R: imprimer un texte:
texte <- "Bonjour la planète! Moi, c'est Celia"
print(texte)

# Mon premier programme: imprimer une salutation pour chaque participant:
prenom <- c("Celia", "Sasha", "Abigaelle")

# On utilise une boucle qui reproduit la même salutation pour 
# chaque prénom:
for (i in 1:length(prenom)) {
  print( paste0("Bonjour la planète! Moi, c'est ", prenom[i]))
}

# Jouons aux détectives pour retrouver un chat suspect qui a laissé
# des poils le jour de la disparition du rouge-gorge.
# Après avoir analysé l'ADN sur les poils retrouvés, 
# la séquence d'ADN que nous avons trouvée est:
indice <- "GTATACT"

# On compare à l'ADN des chats suspects:
suspects <- c(Tigri  = "GGCATCCGATTAGGCATCCGATTAGGCATCCGATTAGGCATCCGATTAGGCATCCGATTA",
              Bianca = "ATTCGGTATCCTAGATTCGGTATCCTAGATTCGGTATACTAGATTCGGTATCCTAG",
              Biscotte   = "CCTAGAGGTAACCCTAGAGGTAACCCTAGAGGTAACCCTAGAGGTAACCCTAGAGGTAACCCTAGAGGTAAC")

for (nom in names(suspects)) {
  if (grepl(indice, suspects[nom])) {
    print(paste("Les poils sont à", nom, "!"))
  } else {
    print(paste("Les poils ne sont pas à", nom))
  }
}

## Les chats ont la gingivite !

# Nous allons importer dans R une table qui contient l'expression des gènes.
genes_chat <- read.csv("genes_gingivite_chats.csv", row.names = 1)

# Nous allons explorer la structure de notre table: chaque ligne correspond à un
# gène, et chaque colonne correspond à un échantillon de chat.
# Les chiffres nous donnent la quantité de chaque gène dans chaque gencive.
# Les noms de colonnes nous donnent le numéro d'échantillon et la 
# maladie de chaque chat:
head(genes_chat)

# La PCA: regrouper des échantillons similaires sur la base de leur expression
# des gènes.
pca <- prcomp(t(genes_chat), scale. = TRUE, center = TRUE)$x
pca <- as.data.frame(pca)

pca$condition<-sapply(strsplit(colnames(genes_chat), "_"), '[', 2)

ggplot(pca, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point() 

# Ajouter les noms de chats:
ggplot(pca, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point() +
  geom_text_repel(label=rownames(pca))

## Cappuccino
# Importer la table des gènes de Cappuccino:
cappuccino <- read.csv("chat20_cappuccino_genes.csv", row.names = 1)

# Combiner les gènes de Cappuccino avec les gènes des autres chats:
genes_avec_cappuccino <- cbind(genes_chat, cappuccino)

pca <- prcomp(t(genes_avec_cappuccino), scale. = TRUE, center = TRUE)$x
pca <- as.data.frame(pca)

pca$condition <- sapply(strsplit(colnames(genes_avec_cappuccino), "_"), '[', 2)

ggplot(pca, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point(size=2) +
  geom_text_repel(label=rownames(pca))

# Mon chat Cappuccino a't-il la gingivite? Devra t'il prendre
# des médicaments?!

# Heatmap: carte de couleurs
# Des gènes qui sont différents entre la gingivite chronique et la
# gencive saine:
genes <- c("ENSFCAG00000005637", "ENSFCAG00000045399", "ENSFCAG00000009165",
           "ENSFCAG00000013829", "ENSFCAG00000013269" ,
           "ENSFCAG00000015193", "ENSFCAG00000036851", "ENSFCAG00000009900",
           "ENSFCAG00000041420", "ENSFCAG00000041248")

# Extraire ces gènes de la table
diff_genes <- genes_avec_cappuccino[genes,]    

# Créer une carte de couleurs: les colonnes contiennent les échantillons
# de chats, et les lignes les gènes:
# Ajuster la taille du texte 
heatmap(as.matrix(diff_genes), cexCol = 0.6, cexRow = 0.8)
# Les gènes changent-ils?

# Jouer avec les couleurs:
# options:
# terrain.colors(50)
# rainbow(50)
# heat.colors(50)
# topo.colors(50)
# cm.colors(50)
# hcl.colors(50)

# par exemple: arc-en-ciel:
heatmap(as.matrix(diff_genes), 
        col=rainbow(50) , 
        cexCol = 0.6, cexRow = 0.8)

# Maintenant, le travail du biologiste avec lequel le/la bioinformaticienne
# collabore c'est de comprendre le rôle des gènes et voir si on peut donner 
# un médicament aux chats malades.
# Eg ENSFCAG00000013269 = CSF3R, gène du système immunitaire

