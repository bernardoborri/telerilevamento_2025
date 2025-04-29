# Code to build your own functions
# La sintassi per creare una funzione in R è: nome_funzione <- function(argomento1, argomento2) {#corpo della funzione}
# Di seguito un esempio

somma <- function(x,y) {
  z=x+y
  return(z)
  }
# Le parentesi graffe contengono il corpo della funzione, cioè le istruzioni da eseguire 

# Ora che ho creato la funzione, la provo con degli argomenti (numeri) scelti arbitrariamente
somma(3, 5)
# Il risultato sarà:
[1] 8


# Exercise: make a new function called differenza
differenza <- function(x,y){
  z=x-y
  return(z)
  }

# Provo adesso a creare una funzione che faccia un multiframe
mf <- function(nrow,ncol) {
  par(mfrow=c(nrow,ncol))
  }


 # Creo ora una funzione che mi riveli se un numero è positivo o meno e gli do nome “positivo”
positivo <- function(x) {
  if(x>0) {
    print("Questo numero è positivo, non lo sai?")
    }
  # Qui sopra “x” è il numero che inserirò per capire se è positivo. 
  # “if” è una funzione molto utilizzata e qui si dice che è “nested”, ovvero annidata nella nostra nuova funzione. 
  # Altrettanto nested è qui sopra la funzione “print”, che fa comparire un messaggio: in questo caso qualora x sia positivo apparirà il messaggio "Questo numero è positivo, non lo sai?"
  
  else if(x<0) {
    print("Questo numero è negativo, studia!") 
    }
# Qui sopra con l’ulteriore funzione nested “else if” definiamo che se x è minore di 0 la funzione nested “print” ci darà il messaggio "Questo numero è negativo, studia!"

  # A questo punto, con i medesimi metodi e funzioni nested definiamo anche che cosa accadrà qualora il numero sia zero, ovvero che appaia il messaggio “lo zero è zero”  
  else {
    print("Lo zero è zero.")}
  }

flipint <- function(x) {
  x = flip(x)
  plot(x)
  }
