
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

# Heatmap: carte de couleurs
# Des gènes qui sont différents entre la gingivite chronique et la
# gencive saine:
genes <- c("ENSFCAG00000005637", "ENSFCAG00000045399", "ENSFCAG00000009165",
         "ENSFCAG00000013829", "ENSFCAG00000013269" ,
         "ENSFCAG00000015193", "ENSFCAG00000036851", "ENSFCAG00000009900",
         "ENSFCAG00000041420", "ENSFCAG00000041248")

# Extraire ces gènes de la table
diff_genes <- genes_chat[genes,]    

# Créer une carte de couleurs: les colonnes contiennent les échantillons
# de chats, et les lignes les gènes:
heatmap(as.matrix(diff_genes))
# Ajuster la taille du texte 
heatmap(as.matrix(diff_genes), cexCol = 0.6, cexRow = 0.8)
# Les gènes changent-ils?

# Jouer avec les couleurs:
# options:
# terrain.colors(50), rainbow(50), heat.colors(50), topo.colors(50), cm.colors(50)
# par exemple: arc-en-ciel:
heatmap(as.matrix(diff_genes), col=rainbow(50))
heatmap(as.matrix(diff_genes), col=heat.colors(50), cexCol=0.8, cexRow = 0.5)

# Maintenant, le travail du biologiste avec lequel le/la bioinformaticienne
# collabore c'est de comprendre le rôle des gènes et voir si on peut donner 
# un médicament aux chats malades.
# Eg ENSFCAG00000013269 = CSF3R, gène du système immunitaire

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

# Oh non, mon chat Cappuccino a la gingivite chronique! Il devra prendre
# ses médicaments!

