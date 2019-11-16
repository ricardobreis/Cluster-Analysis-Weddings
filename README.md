# Cluster-Analysis-Weddings

## Breve Explicação

Trinta entrevistas foram feitas, pedindo-se para dar uma nota de 1 (discordo totalmente)
a 5 (concordo totalmente) às seguintes afirmações:

1. Sempre vou a casamentos quando sou convidado.
2. A parte mais interessante dos casamentos são os doces.
3. Me emociono com a cerimônia de casamento.
4. Casamentos são boas ocasiões para se conhecer pessoas.
5. Me divirto com amigos nas festas de casamento.
6. Gosto de ver vídeos e fotos de casamentos.
7. Cerimônias de casamento longas me cansam.
8. Acho que casamento no civil não é casamento de verdade.

Os resultados estão na tabela em arquivo Excel localizado neste repositório.

## Pré-processamento dos Dados

### Checando Tipos de Dados

![Summary](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/summary.PNG)

![Classes](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/class.PNG)

![Summary - Tratado](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/summarytratado.PNG)

### Checando Correlações

![Correlações](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/correlacao.PNG)

Observando a imagem acima pode-se constatar que houve correlações consideráveis entre as variáveis:

- Emocionar-Cansar: .67
- Emocionar-Casamento: .69

Quando uma quantidade relevante de variáveis é altamente correlacionada, a característica que elas representam está sendo mais considerada que as outras características, representadas por variáveis não correlacionadas. Isso é nocivo, pois uma característica estará sendo privilegiada em relação à outra. Nesse caso, retirou-se a variável "emocionar", para que todas as correlações ficassem abaixo de .60.

![Correlações - Tratadas](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/correlacaotratada.PNG)

## AGNES - Método WARD

Seguindo o Elbow Method, podemos observar nos gráficos beetweens e whithinss abaixo que o cotovelo se encontra no k = 3. Já observando o dendograma, é possível fazer um corte nas pernas mais longas gerando também 3 clusters, corroborando o elbow method. O Silhouette Width aponta para um resultado ótimo em k = 3.

Clusters             |  Dendograma
:-------------------------:|:-------------------------:
![Clusters](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20ward%20clusters.png)  |  ![Dendograma](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20ward%20dendograma.png)


### Elbow Method           

![Elbow Method](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20ward%20elbow.png)

### Silhouette Width

![Silhouette Width](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20ward%20silhouette.png)

## AGNES - Método AVERAGE

Seguindo o Elbow Method, podemos observar nos gráficos beetweens e whithinss abaixo que o cotovelo se encontra no k = 3. Já observando o dendograma, é possível fazer um corte nas pernas mais longas gerando 3 clusters. O Silhouette Width aponta para um resultado ótimo em k = 3, por isso optou-se por manter o k = 3 como melhor resultado seguindo a análise do elbow e silhouette width.

Clusters             |  Dendograma
:-------------------------:|:-------------------------:
![Clusters](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20average%20clusters.png)  |  ![Dendograma](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20average%20dendograma.png)


### Elbow Method            

![Elbow Method ](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20average%20elbow.png)

### Silhouette Width

![Silhouette Width](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/img/Agnes%20average%20silhouette.png)

## K-Means

Utilizando o K-means é possível observar pelo plot dos clusters que ele consegue separar melhor os grupos. Analisando os gráficos whithinss e betweenss fica claro que para o k = 3 existe uma quebra na suavidade da curva, sendo assim esse o nosso elbow. O ASW mostra que para o k = 3 se tem o melhor resultado, 0.34, apesar da estrutura de agrupamento ainda ser fraca. Portanto, o K-Means gera um resultado melhor que o AGNES, para o k = 3.

### Clusters
![Clusters](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/K-means%20Cluster.png)

### Withinss|Betweenss           

![Withinss|Betweenss](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/Elbow.png)

### Silhouette Width

![Silhouette Width](https://github.com/ricardobreis/Cluster-Analysis-Weddings/blob/master/Silhouette.png)
