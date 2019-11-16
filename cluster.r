################################################################################################
#
# MÉTODOS MATRICIAIS E ANÁLISE SE CLUSTER - MBA Business Analytics e Big Data
# Por: RICARDO REIS
#      MÁRCIO EGGERS
#      FLÁVIO FREIRE
#
# CASE - BASE CASAMENTOS
#
################################################################################################


# Carrega Bibliotecas -----------------------------------------------------

library(readxl)
library(fpc)
library(factoextra)
library(cluster)
library(purrr)


# Análise da Base de Dados ------------------------------------------------

BASECASAMENTOS <- read_xlsx("~/R-Projetos/Casamentos/base_casamentos.xlsx", sheet = "CASAMENTOS", col_names = TRUE)
BASECASAMENTOS = BASECASAMENTOS[ -c(1),  ]

# Mapear os tipos dos dados das colunas da tabela importada.
sapply(BASECASAMENTOS, class)

# Sumarizar as características univariadas dos dados da tabela importada.
summary(BASECASAMENTOS)

# Repare que as variáveis estão sendo erroneamente tratadas como numéricas/character, quando na verdade são fatores.
# Mudar o tipo das variáveis para factor.
BASECASAMENTOS$aceitar_=as.factor(BASECASAMENTOS$aceitar_)
BASECASAMENTOS$gostar_...3=as.factor(BASECASAMENTOS$gostar_...3)
BASECASAMENTOS$emocionar=as.factor(BASECASAMENTOS$emocionar)
BASECASAMENTOS$conhecer_=as.factor(BASECASAMENTOS$conhecer_)
BASECASAMENTOS$diversao_=as.factor(BASECASAMENTOS$diversao_)
BASECASAMENTOS$gostar_...7=as.factor(BASECASAMENTOS$gostar_...7)
BASECASAMENTOS$cansar_=as.factor(BASECASAMENTOS$cansar_)
BASECASAMENTOS$casamento=as.factor(BASECASAMENTOS$casamento)
summary(BASECASAMENTOS)

# Selecionar somente as variáveis drivers de clustering.
BASECASAMENTOS_drivers = BASECASAMENTOS[ , -c(1,10,11)]

# Preparando dados, transformando tudo para tipo numérico e colocando as colunas em escala.
BASECASAMENTOS_drivers_num <- BASECASAMENTOS_drivers
BASECASAMENTOS_drivers_num$aceitar_ = as.numeric(BASECASAMENTOS_drivers_num$aceitar_)
BASECASAMENTOS_drivers_num$gostar_...3 = as.numeric(BASECASAMENTOS_drivers_num$gostar_...3)
BASECASAMENTOS_drivers_num$emocionar = as.numeric(BASECASAMENTOS_drivers_num$emocionar)
BASECASAMENTOS_drivers_num$conhecer_ = as.numeric(BASECASAMENTOS_drivers_num$conhecer_)
BASECASAMENTOS_drivers_num$diversao_ = as.numeric(BASECASAMENTOS_drivers_num$diversao_)
BASECASAMENTOS_drivers_num$gostar_...7 = as.numeric(BASECASAMENTOS_drivers_num$gostar_...7)
BASECASAMENTOS_drivers_num$cansar_ = as.numeric(BASECASAMENTOS_drivers_num$cansar_)
BASECASAMENTOS_drivers_num$casamento = as.numeric(BASECASAMENTOS_drivers_num$casamento)

# Neste momento não é necessário colocar os dados em escala pois eles já estão na mesma escala
# BASECASAMENTOS_drivers_num_z <- as.data.frame(lapply(BASECASAMENTOS_drivers_num, scale))

# Calculando a correlação entre as variáveis. Deve-se tomar o cuidado de que não hajam grandes correlações 
# entre as variáveis, pois estareamos considerando a mesma informação repetidas vezes, 
# aumentando o "peso" daquela informação na formação dos clusters.
cor(BASECASAMENTOS_drivers_num)

# Retirou-se a coluna emocionar
BASECASAMENTOS_drivers_num = BASECASAMENTOS_drivers_num[ , -c(3)]

cor(BASECASAMENTOS_drivers_num)

# K-MEANS -----------------------------------------------------------------

BASECASAMENTOS_drivers_num_dist <- dist(BASECASAMENTOS_drivers_num, method = "euclidean")

#### tot_withinss
tot_withinss <- map_dbl(2:29,  function(k){
  model <- kmeans(x = BASECASAMENTOS_drivers_num, centers = k)
  model$tot.withinss
})

# Gera o data frame contendo o k e tot_withinss
elbow_df <- data.frame(
  k = 2:29,
  tot_withinss = tot_withinss
)

ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
  geom_line() +
  scale_x_continuous(breaks = 2:29)

#### Silhouette Width
sil_width <- map_dbl(2:29,  function(k){
  model <- kmeans(x = BASECASAMENTOS_drivers_num, centers = k)
  cluster.stats(BASECASAMENTOS_drivers_num_dist, model$cluster)$avg.silwidth
})

# Gera o data frame contendo o k e sil_width
sil_df <- data.frame(
  k = 2:29,
  sil_width = sil_width
)

# Plot the relationship between k and sil_width
ggplot(sil_df, aes(x = k, y = sil_width)) +
  geom_line() +
  scale_x_continuous(breaks = 2:29)

#### analisando os gráficos de whithinss, betweenss e silhouette, o modelo que otmiza os resultados utiliza k=3
KMeans_clustering_k3 <- kmeans(BASECASAMENTOS_drivers_num, 3)
KMeans_clustering_k3
KMeans_clustering_k3$cluster
KMeans_clustering_k3$centers
KMeans_clustering_k3$totss
KMeans_clustering_k3$withinss
KMeans_clustering_k3$tot.withinss
KMeans_clustering_k3$betweenss
KMeans_clustering_k3$size
KMeans_clustering_k3$iter
KMeans_clustering_k3$ifault

#Plotando clusters
plotcluster(BASECASAMENTOS_drivers_num, KMeans_clustering_k3$cluster)
fviz_cluster(list(data = BASECASAMENTOS_drivers_num, cluster = KMeans_clustering_k3$cluster),  show.clust.cent = T)

# AGNES -------------------------------------------------------------------

# Padronizar as variáveis e calcular a matriz de distancias por métrica de Gower.
# md = daisy(BASECASAMENTOS_drivers)

BASECASAMENTOS_drivers_num_dist <- dist(BASECASAMENTOS_drivers_num, method = "euclidean")

# Ward

agnes_clustering_ward <- agnes(BASECASAMENTOS_drivers_num_dist, diss = TRUE, method = "ward")

#### tot_withinss
tot_withinss <- map_dbl(2:29,  function(k){
  agnes_clustering_ward_k <- cutree(agnes_clustering_ward, k = k)
  cluster.stats(BASECASAMENTOS_drivers_num_dist, agnes_clustering_ward_k)$n.within
})

# Gera o data frame contendo o k e tot_withinss
elbow_df <- data.frame(
  k = 2:29,
  tot_withinss = tot_withinss
)

ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
  geom_line() +
  scale_x_continuous(breaks = 2:29)

#### Silhouette Width
sil_width <- map_dbl(2:29,  function(k){
  agnes_clustering_ward_k <- cutree(agnes_clustering_ward, k = k)
  cluster.stats(BASECASAMENTOS_drivers_num_dist, agnes_clustering_ward_k)$avg.silwidth
})

# Gera o data frame contendo o k e sil_width
sil_df <- data.frame(
  k = 2:29,
  sil_width = sil_width
)

# Plot the relationship between k and sil_width
ggplot(sil_df, aes(x = k, y = sil_width)) +
  geom_line() +
  scale_x_continuous(breaks = 2:29)

# Para o k = 3

agnes_clustering_ward_k3 <- cutree(agnes_clustering_ward, k = 3)
agnes_clustering_ward_k3
fviz_dend(agnes_clustering_ward, k=3)
fviz_cluster(list(data = BASECASAMENTOS_drivers_num, cluster = agnes_clustering_ward_k3),  show.clust.cent = F)

# Utilizar a função cluster.stats da library fpc para uma lista maior de métricas da solução de clusters encontrada.
cluster.stats(BASECASAMENTOS_drivers_num_dist, agnes_clustering_ward_k3)


# Average

agnes_clustering_average <- agnes(BASECASAMENTOS_drivers_num_dist, diss = TRUE, method = "average")

#### tot_withinss
tot_withinss <- map_dbl(2:29,  function(k){
  agnes_clustering_average_k <- cutree(agnes_clustering_average, k = k)
  cluster.stats(BASECASAMENTOS_drivers_num_dist, agnes_clustering_average_k)$n.within
})

# Gera o data frame contendo o k e tot_withinss
elbow_df <- data.frame(
  k = 2:29,
  tot_withinss = tot_withinss
)

ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
  geom_line() +
  scale_x_continuous(breaks = 2:29)

#### Silhouette Width
sil_width <- map_dbl(2:29,  function(k){
  agnes_clustering_average_k <- cutree(agnes_clustering_average, k = k)
  cluster.stats(BASECASAMENTOS_drivers_num_dist, agnes_clustering_average_k)$avg.silwidth
})

# Gera o data frame contendo o k e sil_width
sil_df <- data.frame(
  k = 2:29,
  sil_width = sil_width
)

# Plot the relationship between k and sil_width
ggplot(sil_df, aes(x = k, y = sil_width)) +
  geom_line() +
  scale_x_continuous(breaks = 2:29)

# Para o k = 3

agnes_clustering_average_k3 <- cutree(agnes_clustering_average, k = 3)
agnes_clustering_average_k3
fviz_dend(agnes_clustering_average, k=3)
fviz_cluster(list(data = BASECASAMENTOS_drivers_num, cluster = agnes_clustering_average_k3),  show.clust.cent = F)

# Utilizar a função cluster.stats da library fpc para uma lista maior de métricas da solução de clusters encontrada.
cluster.stats(BASECASAMENTOS_drivers_num_dist, agnes_clustering_average_k3)

