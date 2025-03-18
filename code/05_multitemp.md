#Reporting multitemporal analysis by Markdown
#il linguaggio Markdown
#in order to perform multitemporal analysis, datasets in different times can be imported, by:
#scarico le backtics da google da copiare e incollare a 3 a 3 ```

``` r
im.list()
gr = im.import("greenland")
```

#Once the set has been imported we can calculate the differences between different dates, as:
``` r
grdif = gr[[1]] - gr[[4]]
``` 
