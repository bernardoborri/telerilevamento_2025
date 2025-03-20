#This code helps exporting graphs to images

#Exporting data
setwd("C:/Users/bobby/OneDrive/Desktop")
#a questo punto scrivendo
getwd()
#su R comparirà la scritta
"C:/Users/bobby/OneDrive/Desktop"
plot(gr)

#esporto dunque l'immagine in png sul desktop secondo i comandi che seguono
png("greenland_output.png")
plot(gr)
dev.off()

#provo ad esportare ora la stessa immagine come file PDF
pdf("greenland_output.png")
plot(gr)
dev.off()

#esporto direttamente una differenza come file pdf
pdf(difgreen.pdf")
plot(grdif)
dev.off()

#esporto in formato jpeg
jpeg("difgreen.jpeg")
plot(grdif)
dev.off()

#il pdf non perde definizione zoomando
