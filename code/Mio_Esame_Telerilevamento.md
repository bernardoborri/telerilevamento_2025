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

>Segui questo link per saperne di più sui [Satelliti Landsat](https://landsat.gsfc.nasa.gov/)


<img width="1914" height="865" alt="gee exam" src="https://github.com/user-attachments/assets/7d75d080-c6b0-4ad0-ab28-44e10b4b9692" />

## **2. Script R — Analisi NDVI e visualizzazioni**

```r

# ----------------------------
# 2.1 Caricamento pacchetti 
# ----------------------------

# Di seguito i pacchetti e le relative funzioni utilizzate in questo script

library(terra)     # terra::rast(), terra::values(), terra::plot()
library(viridis)   # viridis::scale_fill_viridis()
library(ggplot2)   # ggplot2::ggplot(), geom_density(), theme_minimal()
library(patchwork)   # patchwork::wrap_plots()
library(imageRy)   # imageRy::im.multiframe()
# più alcune funzioni base di R

# ----------------------------
# 2.2 Importazione immagini RGB+NIR (terra::rast)
# ----------------------------

getwd() # per verificare dapprima la working directory dove vanno spostate le immagini

"C:/Users/bobby/OneDrive/Documents" # nel mio caso

# Di seguito importo le immagini ottenute da Google Earth Engine
# Oltre alle bande dei colori reali (RGB) viene importata anche la banda NIR (near infra red)
# La banda NIR ci consentirà dopo di calcolare l'Indice di Vegetazione Normalizzato (NDVI)

toscana_2000 <- rast("rgbn_tuscany_2000_1999_2001.tif")  # terra::rast()
toscana_2010 <- rast("rgbn_tuscany_2010_2009_2011.tif")  # terra::rast()
toscana_2020 <- rast("rgbn_tuscany_2020_2019_2021.tif")  # terra::rast()

# ----------------------------
# 2.3 Visualizzazione RGB a confronto (par + terra::plotRGB)
# ----------------------------

# Di seguito le funzioni per ottenere le immagini con colori naturali (RGB) dei 3 periodi di riferimento

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

# Procediamo adesso col calcolo del Normalized Difference Vegetation Index (NDVI)
# I satelliti Landsat coinvolti in queste funzioni sono 2
# Landsat 5 per il 2000 ed il 2010
# Landsat 8 per il 2020

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
# 2.6 Estrazione valori NDVI (terra::values, base::head, base::is.na)
# ----------------------------

# La funzione values() serve per estrarre tutti i valori numerici dei pixel da un raster, ad esempio i valori NDVI calcolati

v2000 <- values(ndvi_2000) ; v2000 <- v2000[!is.na(v2000)]
v2010 <- values(ndvi_2010) ; v2010 <- v2010[!is.na(v2010)]
v2020 <- values(ndvi_2020) ; v2020 <- v2020[!is.na(v2020)]

# Osserviamo a questo punto gli output con la funzione head()
# Numeri compresi normalmente tra -1 e 1, dove valori vicini a 1 indicano vegetazione molto densa, 0 aree prive di vegetazione e valori negativi corrispondono di solito ad acqua, neve o superfici artificiali

head(v2000)
0.3160424 0.2591038 0.2591038 0.2582499 0.2751155 0.2886932
head(v2010)
0.3596130 0.3521736 0.3521736 0.3488576 0.3711064 0.3805258
head(v2020)
0.3791036 0.3719755 0.3719755 0.3742538 0.3773779 0.3766964

# Questa funzione mostra solo i primi 6 valori tra tutti i valori dei pixel NDVI estratti dal raster

# ----------------------------
# 2.7 Analisi statistica (base::summary, base::mean, base::sd)
# ----------------------------

summary(v2000)
# risultato = Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
             -0.2249  0.2031  0.2797  0.2703  0.3427  0.5498 

summary(v2010)
 # risutato = Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
             -0.2268  0.2115  0.2825  0.2716  0.3408  0.5420 

summary(v2020)
# risultato =  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
              -0.2904  0.2508  0.3125  0.2993  0.3626  0.5670 

# La funzione summary() calcola e mostra le statistiche descrittive di valori NDVI
# Essa usa tutti i valori estratti con la funzione values(), non solo i primi mostrati da head()
# Min. → valore minimo NDVI
# 1st Qu. → primo quartile
# Median → mediana
# Mean → media
# 3rd Qu. → terzo quartile
# Max. → valore massimo NDVI

mean(v2000); sd(v2000)
#risultati di seguito
0.2703031
0.09904466

mean(v2010); sd(v2010)
#risultati di seguito
0.2716097
0.09357948

mean(v2020); sd(v2020)
#risultati di seguito
0.2992663
0.09118385

# I valori ottenuti con la funzione mean() corrispondono alla media aritmetica di tutti i valori NDVI, cioè alla media della vegetazione per l’intera area della Toscana

# ----------------------------
# 2.8 Distribuzione NDVI con ggplot2
# ----------------------------

# La funzione data.frame() crea una tabella di dati con i valori NDVI estratti da v2000, v2010, v2020

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

# La funzione ggplot() (ggplot2) → inizializza il grafico, specificando dati e variabili estetiche
# La funzione geom_density() (ggplot2) → disegna la curva di densità per visualizzare la distribuzione dei valori NDVI.
# La funzione labs() (ggplot2) → aggiunge titolo, etichette degli assi e legenda al grafico
# La funzione theme_minimal() (ggplot2) → applica un tema pulito e minimale al grafico
# La funzione ggtitle() (ggplot2) → imposta un titolo principale per il grafico
# La funzione scale_color_manual() (ggplot2) → assegna colori personalizzati alle curve NDVI di ciascun anno
```
<img width="1386" height="564" alt="ggplot" src="https://github.com/user-attachments/assets/f0fc7459-90e5-49ec-9e0a-95da5c911092" />

```r



```


## **3. Script LaTeX per presentazione su Overleaf**

[Clicca qui per aprire la mia presentazione LaTeX su Overleaf](https://www.overleaf.com/project/68c069dce98c3ff6c016a54e)

```latex
\documentclass{beamer}
\usetheme{Berlin} % tema che evita gli Overfull visti con Madrid

% codifica e font
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}

% grafica e link
\usepackage{graphicx}
\usepackage{hyperref}

% Macro robusta per visualizzare nomi di funzioni, pacchetti, nomi di file, ecc.
% \detokenize stampa i caratteri speciali come testo, evitando che TeX li interpreti.
\newcommand{\code}[1]{\texttt{\detokenize{#1}}}

\title{Copertura Vegetazione Toscana (2000 -- 2020)}
\author{Bernardo Borri}
\date{\today}

\begin{document}

% --------------------------------------
% SLIDE 1 - TITOLO
% --------------------------------------
\frame{\titlepage}

% --------------------------------------
% SLIDE 2 - ABSTRACT
% --------------------------------------

\begin{frame}{Abstract}
\begin{block}{Sintesi del progetto}
In questo lavoro analizziamo l'evoluzione della \textbf{copertura vegetale in Toscana} tra il 2000 e il 2020 utilizzando immagini satellitari \textbf{Landsat} elaborate tramite \textbf{Google Earth Engine (GEE)} e \textbf{R}.  
L'obiettivo principale è individuare le variazioni di vegetazione attraverso il calcolo dell'indice \textbf{NDVI} e la produzione di mappe tematiche e grafici statistici.  
L'integrazione tra \textbf{GEE} e \textbf{R} permette di gestire grandi quantità di dati e realizzare un'analisi accurata, riproducibile e facilmente interpretabile.
\end{block}
\end{frame}

% --------------------------------------
% SLIDE 3 - OBIETTIVI
% --------------------------------------
\begin{frame}{Obiettivi del lavoro}
\begin{itemize}
    \item Analizzare la variazione della copertura vegetale in Toscana tra il 2000, 2010 e 2020.
    \item Utilizzare immagini satellitari Landsat scaricate da \code{Google Earth Engine (GEE)}.
    \item Calcolare l'indice di vegetazione \code{NDVI} in R.
    \item Visualizzare i cambiamenti tramite mappe RGB, NDVI e grafici statistici.
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 4 - FUNZIONI USATE IN GEE
% --------------------------------------
\begin{frame}[fragile]{Materiali e metodi: Funzioni principali di Google Earth Engine (GEE)}
\begin{itemize}
    \item \code{ee.ImageCollection()} -- Carica le immagini satellitari Landsat.
    \item \code{filterDate()} -- Seleziona un intervallo temporale di acquisizione.
    \item \code{filterBounds()} -- Ritaglia l'area di interesse (AOI, Toscana).
    \item \code{map(maskLandsat)} -- Maschera le nuvole e le ombre.
    \item \code{median()} -- Calcola il composito mediano delle immagini.
    \item \code{clip()} -- Ritaglia le immagini esattamente sull'area della Toscana.
    \item \code{Map.addLayer()} -- Visualizza i layer RGB nel pannello GEE.
    \item \code{Export.image.toDrive()} -- Esporta le immagini GeoTIFF (RGB + NIR).
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 5 - FUNZIONI USATE IN R
% --------------------------------------
\begin{frame}[fragile]{Materiali e metodi: Funzioni principali di R}
\begin{itemize}
    \item \code{terra::rast()} -- Importazione dei raster GeoTIFF.
    \item \code{terra::plotRGB()} -- Visualizzazione delle immagini RGB.
    \item \code{par(mfrow=...)} -- Creazione di multiframe per il confronto di più immagini.
    \item \code{terra::values()} -- Estrazione dei valori numerici dai raster.
    \item \code{viridis::viridis()} -- Generazione delle palette di colori per le mappe.
    \item \code{ggplot2::ggplot()} -- Creazione di grafici di distribuzione dei valori NDVI.
    \item \code{geom_density()} -- Visualizzazione della densità dei valori NDVI.
    \item \code{theme_minimal()} -- Impostazione di un tema pulito per i grafici.
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 6 - IMMAGINI RGB
% --------------------------------------
\begin{frame}{Risultati: Immagini RGB della Toscana}
\begin{center}

\includegraphics[width=0.80\linewidth]{Toscana_RGB.png}
\end{center}
\footnotesize{Immagini RGB Toscana — Landsat (2000, 2010, 2020)}
\end{frame}

% --------------------------------------
% SLIDE 7 - MAPPE NDVI
% --------------------------------------
\begin{frame}{Risultati: NDVI calcolato in R}
\begin{center}
\includegraphics[width=0.90\linewidth]{ndvi_tuscany_2000.png}
\end{center}
\footnotesize{Mappe NDVI Toscana — Calcolate in R}
\end{frame}

% --------------------------------------
% SLIDE 8 - DISTRIBUZIONE NDVI
% --------------------------------------
\begin{frame}{Risultati: Distribuzione NDVI per anno}
\begin{center}
\includegraphics[width=0.90\linewidth]{ndvi_density_overlay.png}
\end{center}
\footnotesize{Distribuzione dei valori NDVI (2000, 2010, 2020)}
\end{frame}

% --------------------------------------
% SLIDE 9 - CONCLUSIONI
% --------------------------------------
\begin{frame}{Conclusioni}
\begin{itemize}
    \item Tra il 2000 e il 2020 si osserva una variazione della copertura vegetale in Toscana.
    \item L'uso combinato di \code{GEE} e \code{R} permette di gestire grandi dataset e calcolare indici complessi.
    \item Il calcolo dell'NDVI in R consente un'analisi flessibile e riproducibile.
    \item La rappresentazione tramite grafici e mappe rende immediata l'interpretazione dei risultati.
\end{itemize}
\end{frame}

% --------------------------------------
% SLIDE 10 - LINK IPERTESTUALI UTILI
% --------------------------------------

\begin{frame}{Link Utili}
\begin{itemize}
    \item \href{https://landsat.gsfc.nasa.gov/}{\textbf{\underline{Per saperne di più sui satelliti Landsat clicca qui}}}
    \item \href{https://github.com/bernardoborri/telerilevamento_2025/blob/main/code/Mio_Esame_Telerilevamento.md}{\textbf{\underline{Per consultare tutto il codice R clicca qui}}}
\end{itemize}
\end{frame}

\end{document}
```
