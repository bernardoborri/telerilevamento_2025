# Analisi della Copertura Vegetazionale in Toscana (2000, 2010, 2020)

---

## **1. Script Google Earth Engine**
> Questo script produce 3 immagini RGB della Toscana (2000, 2010, 2020) e aggiunge l’export della banda **NIR** per consentire il calcolo dell’NDVI **in R**.

```javascript
// ===================================================== 
// IMMAGINI RGB TOSCANA - 2000, 2010, 2020 
// =====================================================

// 1. Definisco l'area di interesse (AOI)
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
>Ti piacerebbe approfondire le tue conoscenze sulla [SATELLITI LANDSAT]?([https://dataspace.copernicus.eu/explore-data/data-collections/sentinel-data/sentinel-2](https://landsat.gsfc.nasa.gov/))
<img width="1914" height="865" alt="gee exam" src="https://github.com/user-attachments/assets/7d75d080-c6b0-4ad0-ab28-44e10b4b9692" />

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
getwd() # per verificare dapprima la working directory dove vanno spostate le immagini
"C:/Users/bobby/OneDrive/Documents" # nel mio caso
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
```
<img width="1400" height="698" alt="toscana paar" src="https://github.com/user-attachments/assets/3c39f0e9-a6e8-4a90-8367-b85f44d9d8cb" />

```r
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
```
<img width="1018" height="457" alt="ndvi" src="https://github.com/user-attachments/assets/29be7530-1685-406e-b85b-ca25881823b2" />

```r
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
\usepackage{hyperref}
\usetheme{Madrid}

\title{Copertura Vegetazione Toscana (2000 -- 2020)}
\author{Bernardo Borri}
\date{\today}

\begin{document}

% --------------------------------------
% SLIDE 1 - TITOLO
% --------------------------------------
\frame{\titlepage}

% --------------------------------------
% SLIDE 2 - OBIETTIVI
% --------------------------------------
\begin{frame}{Obiettivi del lavoro}
\begin{itemize}
    \item Analizzare la variazione della copertura vegetale in Toscana tra il 2000, 2010 e 2020.
    \item Utilizzare immagini satellitari Landsat scaricate da Google Earth Engine (GEE).
    \item Calcolare l'indice di vegetazione NDVI in R.
    \item Visualizzare i cambiamenti tramite mappe RGB, NDVI e grafici statistici.
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 3 - FUNZIONI USATE IN GEE
% --------------------------------------
\begin{frame}{Funzioni principali di Google Earth Engine (GEE)}
\begin{itemize}
    \item \textbf{ee.ImageCollection()} -- Carica le immagini satellitari Landsat.
    \item \textbf{filterDate()} -- Seleziona un intervallo temporale di acquisizione.
    \item \textbf{filterBounds()} -- Ritaglia l'area di interesse (AOI, Toscana).
    \item \textbf{map(maskLandsat)} -- Maschera le nuvole e le ombre.
    \item \textbf{median()} -- Calcola il composito mediano delle immagini.
    \item \textbf{clip()} -- Ritaglia le immagini esattamente sull'area della Toscana.
    \item \textbf{Map.addLayer()} -- Visualizza i layer RGB nel pannello GEE.
    \item \textbf{Export.image.toDrive()} -- Esporta le immagini GeoTIFF (RGB + NIR).
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 4 - FUNZIONI USATE IN R
% --------------------------------------
\begin{frame}{Funzioni principali di R}
\begin{itemize}
    \item \textbf{terra::rast()} -- Importazione dei raster GeoTIFF.
    \item \textbf{terra::plotRGB()} -- Visualizzazione delle immagini RGB.
    \item \textbf{par(mfrow=...)} -- Creazione di multiframe per il confronto di più immagini.
    \item \textbf{terra::values()} -- Estrazione dei valori numerici dai raster.
    \item \textbf{viridis::viridis()} -- Generazione delle palette di colori per le mappe.
    \item \textbf{ggplot2::ggplot()} -- Creazione di grafici di distribuzione dei valori NDVI.
    \item \textbf{geom_density()} -- Visualizzazione della densità dei valori NDVI.
    \item \textbf{theme_minimal()} -- Impostazione di un tema pulito per i grafici.
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 5 - IMMAGINI RGB
% --------------------------------------
\begin{frame}{Immagini RGB della Toscana}
\begin{center}
\includegraphics[width=0.32\linewidth]{rgb_tuscany_2000_1999_2001.png}
\includegraphics[width=0.32\linewidth]{rgb_tuscany_2010_2009_2011.png}
\includegraphics[width=0.32\linewidth]{rgb_tuscany_2020_2019_2021.png}
\end{center}
\caption{Immagini RGB Toscana — Landsat (2000, 2010, 2020)}
\end{frame}

% --------------------------------------
% SLIDE 6 - MAPPE NDVI
% --------------------------------------
\begin{frame}{NDVI calcolato in R}
\begin{center}
\includegraphics[width=0.32\linewidth]{ndvi_tuscany_2000.png}
\includegraphics[width=0.32\linewidth]{ndvi_tuscany_2010.png}
\includegraphics[width=0.32\linewidth]{ndvi_tuscany_2020.png}
\end{center}
\caption{Mappe NDVI Toscana — Calcolate in R}
\end{frame}

% --------------------------------------
% SLIDE 7 - DISTRIBUZIONE NDVI
% --------------------------------------
\begin{frame}{Distribuzione NDVI per anno}
\begin{center}
\includegraphics[width=0.8\linewidth]{ndvi_density_overlay.png}
\end{center}
\caption{Distribuzione dei valori NDVI (2000, 2010, 2020)}
\end{frame}

% --------------------------------------
% SLIDE 8 - CONCLUSIONI
% --------------------------------------
\begin{frame}{Conclusioni}
\begin{itemize}
    \item Tra il 2000 e il 2020 si osserva una variazione della copertura vegetale in Toscana.
    \item L'uso combinato di \textbf{GEE} e \textbf{R} permette di gestire grandi dataset e calcolare indici complessi.
    \item Il calcolo dell'NDVI in R consente un'analisi flessibile e riproducibile.
    \item La rappresentazione tramite grafici e mappe rende immediata l'interpretazione dei risultati.
\end{itemize}
\end{frame}

\end{document}
```
