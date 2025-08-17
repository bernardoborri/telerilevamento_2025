# Presentation title
## Data gathering
Data were gathered from the [earth observatory site](https://earthobservatory.nasa.gov/)

Packages used:
``` r
library (terra)
library (imageRy)
```
Setting the working directory and importing the data
``` r
setwd("~/Desktop/")
# per windows è necessario cambiare il backslash \ in slash /
# si consideri che questo comando può cambiare notevolmente e quindi è meglio verififare il "path", per il mio pc è stato per esempio il seguente: setwd ("C:/Users/bobby/OneDrive/Desktop")
dust = rast("dust.jpg")
# a questo punto potrebbe apparire il seguente messaggio di avvertimento su R: Messaggio di avvertimento:[rast] unknown extent, ma noi proseguiremo plottando l'immagine col comando di seguito e la visualizzeremo comunque
plot(dust)
# dopodiché se eventualmente fosse girata la flipperemo col comando di seguito e ripeteremo il plot
dust = flip(dust)
plot(dust)
```
The image looks like:

![dust](https://github.com/user-attachments/assets/a8328350-1608-41bf-86e2-dfd9d8375276)

# Data analysis
Basandoci sui dati ottenuti possiamo calcolare il seguente indice:

``` r
dustindex=dust[[1]]-dust[[3]]
plot(dustindex)
# trattandosi di due bande molto vicine non avrò ovviamente un'immagine granché eloquente...
```
Per esportare l'indice, possiamo utilizzare la funzione png() come di seguito:

``` r
png("dustindex.png")
plot(dustindex)
dev.off()
```
Output image is the following:

![dustindex](https://github.com/user-attachments/assets/1d99d740-0f43-4f7a-b50f-a0ddb78321fe)

## Correlation of bands

Since the RGB is composed by visible bands, a high correlation is expected:

``` r
pairs(dust)
```

This is also graphically apparent:

![pairsout](https://github.com/user-attachments/assets/c16c84dd-dc4f-42f9-be48-75a9d3b17a4e)

## Visualization of the image

The visualization of the index can be changed to any viridis palette:

``` r
plot(dustindex, col=inferno(100))
```

The image will look like:

![dustinferno](https://github.com/user-attachments/assets/f871cc40-afb8-4d0b-9ce0-b3d6bcb7ace0)



