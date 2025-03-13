#richiamo i pacchetti
library (terra)
library (imageRy)
library (viridis)

im.list
mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
#se devo orientare il nord alla parte giusta uso il comando che segue
mato1992 = flip(mato1992)
plot(mato)1992)
# 1 = NIR
# 2 = red
# 3 = green
#plotto con RGB
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato1992, r=2, g=3, b=1)

#import the 2006 image of the Mato Grosso area
mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg)
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
