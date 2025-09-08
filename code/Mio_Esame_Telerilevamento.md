# Analisi della Copertura Vegetazionale in Toscana (2000, 2010, 2020)

---

## **1. Script Google Earth Engine**
> Questo script produce 3 immagini RGB della Toscana (2000, 2010, 2020) e aggiunge l’export della banda **NIR** per consentire il calcolo dell’NDVI **in R**.

```javascript
// ===================================================== 
// IMMAGINI RGB TOSCANA - 2000, 2010, 2020 
// =====================================================

// 1. Definisci l'area di interesse (AOI)
// Ritaglio il perimetro della Toscana con lo strumento Geometry e lo chiamo aoi (Area of interest)
var aoi = aoi;

// Funzione per mascherare nuvole (Landsat 5 e 8)
function maskLandsat(image) {
  var qa = image.select('QA_PIXEL');
  var mask = qa.bitwiseAnd(1 << 3).eq(0)   // 1=nuvola, 0=clear
               .and(qa.bitwiseAnd(1 << 4).eq(0)); // shadow
  return image.updateMask(mask);
}

// Per la mappa di ogni anno definisco un intervallo di 3 anni includendo l'anno antecedente e quello successivo
// In questo modo la mappa avrà meno "buchi"

// La mediana di ogni anno crea un collage dalla collezione di immagini a disposizione in quell'intervallo temporale

// ----------------------------------------------------
// ANNO 2000 — Landsat 5 TM (Collection 2)
// ----------------------------------------------------
var l5_2000 = ee.ImageCollection("LANDSAT/LT05/C02/T1_L2")
  .filterDate('1999-01-01', '2001-12-31')
  .filterBounds(aoi)
  .map(maskLandsat)
  .median()
  .clip(aoi);

Map.addLayer(
  l5_2000,
  {bands: ['SR_B3','SR_B2','SR_B1'], min: 7000, max: 12000},
  'RGB Toscana 2000'
);

// ----------------------------------------------------
// ANNO 2010 — Landsat 5 TM (Collection 2)
// ----------------------------------------------------
var l5_2010 = ee.ImageCollection("LANDSAT/LT05/C02/T1_L2")
  .filterDate('2009-01-01', '2011-12-31')
  .filterBounds(aoi)
  .map(maskLandsat)
  .median()
  .clip(aoi);

Map.addLayer(
  l5_2010,
  {bands: ['SR_B3','SR_B2','SR_B1'], min: 7000, max: 12000},
  'RGB Toscana 2010'
);

// ----------------------------------------------------
// ANNO 2020 — Landsat 8 OLI (Collection 2)
// ----------------------------------------------------
var l8_2020 = ee.ImageCollection("LANDSAT/LC08/C02/T1_L2")
  .filterDate('2019-01-01', '2021-12-31')
  .filterBounds(aoi)
  .map(maskLandsat)
  .median()
  .clip(aoi);

Map.addLayer(
  l8_2020,
  {bands: ['SR_B4','SR_B3','SR_B2'], min: 7000, max: 12000},
  'RGB Toscana 2020'
);

// ----------------------------------------------------
// ESPORTAZIONE IMMAGINI RGB + NIR PER POTER CALCOLARE POI NDVI IN R
// ----------------------------------------------------

// RGB + NIR per Landsat 5 (2000)
Export.image.toDrive({
  image: l5_2000.select(['SR_B3','SR_B2','SR_B1','SR_B4']), // Aggiungo SR_B4=NIR
  description: 'RGBN_Tuscany_2000',
  folder: 'GEE_exports',
  fileNamePrefix: 'rgbn_tuscany_2000_1999_2001',
  region: aoi,
  scale: 30,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

// RGB + NIR per Landsat 5 (2010)
Export.image.toDrive({
  image: l5_2010.select(['SR_B3','SR_B2','SR_B1','SR_B4']),
  description: 'RGBN_Tuscany_2010',
  folder: 'GEE_exports',
  fileNamePrefix: 'rgbn_tuscany_2010_2009_2011',
  region: aoi,
  scale: 30,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

// RGB + NIR per Landsat 8 (2020)
Export.image.toDrive({
  image: l8_2020.select(['SR_B4','SR_B3','SR_B2','SR_B5']), // SR_B5=NIR Landsat 8
  description: 'RGBN_Tuscany_2020',
  folder: 'GEE_exports',
  fileNamePrefix: 'rgbn_tuscany_2020_2019_2021',
  region: aoi,
  scale: 30,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
```

## **2. Script R — Analisi NDVI e visualizzazioni**

```r

# ----------------------------
# 2.1 Caricamento pacchetti 
# ----------------------------
library(imageRy)   # imageRy::im.plot()
library(terra)     # terra::rast(), terra::values(), terra::plot()
library(viridis)   # viridis::scale_fill_viridis()
library(ggplot2)   # ggplot2::ggplot(), geom_density(), theme_minimal()

# ----------------------------
# 2.2 Importazione immagini RGB+NIR (terra::rast)
# ----------------------------
toscana_2000 <- rast("rgbn_tuscany_2000_1999_2001.tif")  # terra::rast()
toscana_2010 <- rast("rgbn_tuscany_2010_2009_2011.tif")  # terra::rast()
toscana_2020 <- rast("rgbn_tuscany_2020_2019_2021.tif")  # terra::rast()

# ----------------------------
# 2.3 Visualizzazione RGB a confronto (par + terra::plotRGB)
# ----------------------------
par(mfrow = c(1,3))                                   # base::par()
plotRGB(toscana_2000, r=1, g=2, b=3, stretch="lin")   # terra::plotRGB()
title("RGB Toscana 2000")                             # base::title()
plotRGB(toscana_2010, r=1, g=2, b=3, stretch="lin")
title("RGB Toscana 2010")
plotRGB(toscana_2020, r=1, g=2, b=3, stretch="lin")
title("RGB Toscana 2020")

# ----------------------------
# 2.4 Calcolo NDVI in R (terra::)
# Landsat 5 (2000, 2010): banda NIR = SR_B4 (4° banda export)
# Landsat 8 (2020): banda NIR = SR_B5 (4° banda export)
# ----------------------------
ndvi_2000 <- (toscana_2000[[4]] - toscana_2000[[1]]) / (toscana_2000[[4]] + toscana_2000[[1]])  # terra::
ndvi_2010 <- (toscana_2010[[4]] - toscana_2010[[1]]) / (toscana_2010[[4]] + toscana_2010[[1]])  # terra::
ndvi_2020 <- (toscana_2020[[4]] - toscana_2020[[1]]) / (toscana_2020[[4]] + toscana_2020[[1]])  # terra::

# ----------------------------
# 2.5 Visualizzazione NDVI in multiframe
# ----------------------------
par(mfrow = c(1,3))                                # base::par()
plot(ndvi_2000, col=viridis(100), main="NDVI 2000") # terra::plot(), viridis::viridis()
plot(ndvi_2010, col=viridis(100), main="NDVI 2010")
plot(ndvi_2020, col=viridis(100), main="NDVI 2020")

# ----------------------------
# 2.6 Estrazione valori NDVI (terra::values, base::is.na)
# ----------------------------
v2000 <- values(ndvi_2000) ; v2000 <- v2000[!is.na(v2000)]
v2010 <- values(ndvi_2010) ; v2010 <- v2010[!is.na(v2010)]
v2020 <- values(ndvi_2020) ; v2020 <- v2020[!is.na(v2020)]

# ----------------------------
# 2.7 Analisi statistica (base::summary, base::mean, base::sd)
# ----------------------------
summary(v2000)
summary(v2010)
summary(v2020)

mean(v2000); sd(v2000)
mean(v2010); sd(v2010)
mean(v2020); sd(v2020)

# ----------------------------
# 2.8 Distribuzione NDVI con ggplot2
# ----------------------------
df_ndvi <- data.frame(
  NDVI = c(v2000, v2010, v2020),
  Anno = rep(c("2000","2010","2020"),
             times=c(length(v2000), length(v2010), length(v2020)))
) # base::data.frame()

ggplot(df_ndvi, aes(x=NDVI, fill=Anno)) +      # ggplot2::ggplot()
  geom_density(alpha=0.4) +                    # ggplot2::geom_density()
  scale_fill_viridis(discrete=TRUE) +          # viridis::scale_fill_viridis()
  labs(title="Distribuzione NDVI Toscana (2000,2010,2020)",
       x="NDVI", y="Densità") +
  theme_minimal()                             # ggplot2::theme_minimal()
```


## **3. Script LaTeX per presentazione su Overleaf**
```latex
\documentclass{beamer}
\usepackage{graphicx}
\usetheme{Madrid}
\title{Copertura Vegetazione Toscana (2000-2020)}
\author{Esame di Telerilevamento}
\date{\today}
\begin{document}

\frame{\titlepage}

\begin{frame}{RGB Toscana}
\includegraphics[width=0.32\linewidth]{rgb_tuscany_2000_1999_2001.png}
\includegraphics[width=0.32\linewidth]{rgb_tuscany_2010_2009_2011.png}
\includegraphics[width=0.32\linewidth]{rgb_tuscany_2020_2019_2021.png}
\end{frame}

\begin{frame}{NDVI Toscana}
\includegraphics[width=0.32\linewidth]{ndvi_tuscany_2000.png}
\includegraphics[width=0.32\linewidth]{ndvi_tuscany_2010.png}
\includegraphics[width=0.32\linewidth]{ndvi_tuscany_2020.png}
\end{frame}

\begin{frame}{Distribuzione NDVI}
\includegraphics[width=0.8\linewidth]{ndvi_density_overlay.png}
\end{frame}

\end{document}
```
