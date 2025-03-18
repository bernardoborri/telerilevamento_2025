#Reporting multitemporal analysis by Markdown
#il linguaggio Markdown
#scarico le backtics da google da copiare e incollare a 3 a 3 ```
#in order to perform multitemporal analysis, datasets in different times can be imported, by:


``` r
im.list()
gr = im.import("greenland")
```

#Once the set has been imported we can calculate the differences between different dates, as:
``` r
grdif = gr[[1]] - gr[[4]]
``` 

the output will be something like (i 2 puntini iniziali e lo slash servono per salire di livello):
<img src="../Pics/difgreen.jpeg" width=100%/>
#se voglio l'immagine grande, ad esempio, la metà, scriverò 50% anziché 100%

>Note: information on the Copernicus program che be find at the [Copernicus_page](https://www.copernicus.eu/en)
