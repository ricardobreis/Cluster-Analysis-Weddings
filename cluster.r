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

BASECASAMENTOS_drivers_num_z <- as.data.frame(lapply(BASECASAMENTOS_drivers_num, scale))

# Calculando a correlação entre as variáveis. Deve-se tomar o cuidado de que não hajam grandes correlações 
# entre as variáveis, pois estareamos considerando a mesma informação repetidas vezes, 
# aumentando o "peso" daquela informação na formação dos clusters.
cor(BASECASAMENTOS_drivers_num_z)

# Padronizar as variáveis e calcular a matriz de distancias por métrica de Gower.
md = daisy(BASECASAMENTOS_drivers)

# K-MEANS -----------------------------------------------------------------

matrizrespostas <- data.frame()
k<-2

####looping para armazenar respostas
while(k<30){
  KMeans_clustering_k3 <- kmeans(BASECASAMENTOS_drivers_num_z, k, nstart = 20)
  KMeans_clustering_k3
  KMeans_clustering_k3$cluster
  KMeans_clustering_k3$centers
  KMeans_clustering_k3$totss
  KMeans_clustering_k3$withinss
  KMeans_clustering_k3$tot.withinss
  KMeans_clustering_k3$betweenss
  KMeans_clustering_k3$size
  BASECASAMENTOS_drivers_num_z_dist <- dist(BASECASAMENTOS_drivers_num_z, method = "euclidean")
  BASECASAMENTOS_drivers_num_z_dist
  cluster.stats(BASECASAMENTOS_drivers_num_z_dist, KMeans_clustering_k3$cluster)
  cluster.stats(BASECASAMENTOS_drivers_num_z_dist, KMeans_clustering_k3$cluster)$avg.silwidth
  matrizrespostasparcial<-data.frame(whithinss=KMeans_clustering_k3$tot.withinss,betweenss=KMeans_clustering_k3$betweenss,silhouette=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, KMeans_clustering_k3$cluster)$avg.silwidth)
  matrizrespostas<-rbind(matrizrespostas,matrizrespostasparcial)
  k<-k+1
}

#### plotando respostas
plot(matrizrespostas$whithinss, type="l")
plot(matrizrespostas$betweenss, type="l")
plot(matrizrespostas$silhouette, type="l")
matplot(cbind(matrizrespostas$whithinss, matrizrespostas$betweenss), type = 'l')

#### analisando os gráficos de whithinss, betweenss e silhouette, o modelo que otmiza os resultados utiliza k=3
KMeans_clustering_k3 <- kmeans(BASECASAMENTOS_drivers_num_z, 3, nstart = 20)
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

plotcluster(BASECASAMENTOS_drivers_num_z, KMeans_clustering_k3$cluster)

fviz_cluster(list(data = BASECASAMENTOS_drivers_num_z, cluster = KMeans_clustering_k3$cluster),  show.clust.cent = T)
BASECASAMENTOS_drivers_num_z_dist <- dist(BASECASAMENTOS_drivers_num_z, method = "euclidean")
BASECASAMENTOS_drivers_num_z_dist
cluster.stats(BASECASAMENTOS_drivers_num_z_dist, KMeans_clustering_k3$cluster)
cluster.stats(BASECASAMENTOS_drivers_num_z_dist, KMeans_clustering_k3$cluster)$avg.silwidth


# AGNES -------------------------------------------------------------------

# Ward

agnes_clustering_ward <- agnes(md, diss = TRUE, method = "ward")
matrizrespostas <- data.frame()
k <- 2

####looping para armazenar respostas
while(k<30){
  agnes_clustering_ward_k <- cutree(agnes_clustering_ward, k = k)
  
  matrizrespostasparcial <- data.frame(whithinss=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_ward_k)$n.within
                                     ,betweenss=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_ward_k)$n.between
                                     ,silhouette=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_ward_k)$avg.silwidth)
  matrizrespostas <- rbind(matrizrespostas,matrizrespostasparcial)
  k <- k+1
}

plot(matrizrespostas$whithinss, type="l")
plot(matrizrespostas$betweenss, type="l")
plot(matrizrespostas$silhouette, type="l")

# Para o k = 3

agnes_clustering_ward_k3 <- cutree(agnes_clustering_ward, k = 3)
agnes_clustering_ward_k3
fviz_dend(agnes_clustering_ward, k=3)
fviz_cluster(list(data = BASECASAMENTOS_drivers_num_z, cluster = agnes_clustering_ward_k3),  show.clust.cent = F)
# Utilizar a função cluster.stats da library fpc para uma lista maior de métricas da solução de clusters encontrada.
cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_ward_k3)


# Average

agnes_clustering_average <- agnes(md, diss = TRUE, method = "average")

matrizrespostas <- data.frame()
k <- 2

####looping para armazenar respostas
while(k<30){
  agnes_clustering_average_k <- cutree(agnes_clustering_average, k = k)
  
  matrizrespostasparcial <- data.frame(whithinss=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_average_k)$n.within
                                       ,betweenss=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_average_k)$n.between
                                       ,silhouette=cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_average_k)$avg.silwidth)
  matrizrespostas <- rbind(matrizrespostas,matrizrespostasparcial)
  k <- k + 1
}

plot(matrizrespostas$whithinss, type="l")
plot(matrizrespostas$betweenss, type="l")
plot(matrizrespostas$silhouette, type="l")

# Para o k = 4

agnes_clustering_average_k4 <- cutree(agnes_clustering_average, k = 3)
agnes_clustering_average_k4
fviz_dend(agnes_clustering_average, k=3)
fviz_cluster(list(data = BASECASAMENTOS_drivers_num_z, cluster = agnes_clustering_average_k4),  show.clust.cent = F)
# Utilizar a função cluster.stats da library fpc para uma lista maior de métricas da solução de clusters encontrada.
cluster.stats(BASECASAMENTOS_drivers_num_z_dist, agnes_clustering_average_k4)

