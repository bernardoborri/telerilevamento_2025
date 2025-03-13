#richiamo i pacchetti
library (terra)
library (imageRy)
library (viridis)

im.list()
mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
#se devo orientare il nord alla parte giusta uso il comando che segue
mato1992 = flip(mato1992)
plot(mato1992)
# 1 = NIR
# 2 = red
# 3 = green
#plotto con RGB
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato1992, r=2, g=3, b=1)

#import the 2006 image of the Mato Grosso area
mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

#uso mltiframe per mettere a confronto '92 e '06
im.multiframe(1, 2)
im.plotRGB(mato1992, r=2, g=3, b=1, title="Mato Grosso 1992")
im.plotRGB(mato2006, r=2, g=3, b=1, title="Mato Grosso 2006")

#variazioni nel numero di righe e colonne e nella scelta delle bande da rappresentare

im.multiframe(3,2)
# NIR ontop of red
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato2006, r=1, g=2, b=3)

# NIR ontop of green
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato2006, r=2, g=1, b=3)

# NIR ontop of blue
im.plotRGB(mato1992, r=3, g=2, b=1)
im.plotRGB(mato2006, r=3, g=2, b=1)

# Exercise: plot only the first layer of mato2006
dev.off()

# scelgo i colori dal pacchetto viridis
plot(mato2006[[1]])
plot(mato2006[[1]], col=magma(100))
plot(mato2006[[1]], col=mako(100))

# DVI: Difference Vegetation Index
#Tree
NIR=255, red=0, DVI=NIR-red=255
#stressedtree
NIR=100, red=20, DVI=NIR-red=100-20=80

#calculating DVI
# reimporto le 2 mappe di matogrosso
# 1 = NIR
# 2 = red

dvi1992 = mato1992[[1]] - mato1992 [[2]] #NIR - red
plot (dvi1992)

#range DVI
#maximum: NIR -red = 255 - 0 = 255
#minimum: NIR - red = 0 - 255 = -255

plot(dvi1992, col=inferno (100))

#Calculate dvi for 2006
dvi2006 = mato2006[[1]] - mato2006 [[2]] #NIR - red
plot (dvi2006)
plot(dvi2006, col=inferno (100))

#fare multiframe

#Different radiometric resolutions
#DVI 8 bit: range (0 - 255, in un'immagine a 8 bit ci sono questi valori)
#maximum: NIR -red = 255 - 0 = 255
#minimum: NIR - red = 0 - 255 = -255

#DVI 4 bit: range (0 - 15)
#maximum: NIR -red = 15 - 0 = 15
#minimum: NIR - red = 0 - 15 = -15

#ndvi fa la differenza tra NIR e red e li divide per la loro somma = standardizzazione
#DVI 8 bit: range (0 - 255)
#maximum: (NIR-red)/(NIR+red) = (255 - 0) / (255 + 0) = 1
#minimum: (NIR-red)/(NIR+red) = (255 - 0) / (255 + 0) = -1

#DVI 4 bit: range (0 - 15)
#maximum: (NIR-red)/(NIR+red) = (15 - 0) / (15 + 0) = 1
#minimum: (NIR-red)/(NIR+red) = (15 - 0) / (15 + 0) = -1

#DVI 3 bit: range (0 - 7)
#maximum: (NIR-red)/(NIR+red) = (7 - 0) / (7 + 0) = 1
#minimum: (NIR-red)/(NIR+red) = (7 - 0) / (7 + 0) = -1

ndvi1992 = (mato1992 [[1]] - mato1992 [[2]]) / mato1992 [[1]] + mato1992 [[2]])
#ndvi1992 = dvi1992 / (mato1992 [[1]] + mato1992 [[2]])
plot (ndvi1992)

#via più veloce per fare la stessa cosa tramite una funzione di ImageRy
ndvi1992auto = im.ndvi(mato1992, 1, 2) 
