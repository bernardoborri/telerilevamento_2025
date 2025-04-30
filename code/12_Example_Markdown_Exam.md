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
setwd("~/Desktop/") #for windows users change the backslash \ to slash /
dust = rast("dust.jpg")
plot(dust)
dust = flip(dust)
plot(dust)
```
The image looks like:

![dust](https://github.com/user-attachments/assets/a8328350-1608-41bf-86e2-dfd9d8375276)

# Data analysis
Based on the data gathered we can calculate the index:
``` r
dust index = dust [[1]] - dust [[3]]
plot(dustindex)
```
# Correlations of bands
Based on the data gathered, we can calculated the following index:

``` r
dustindex = dust[[1]]- dust[[3]]
plot(dustindex)
```
The output image is the following:

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



