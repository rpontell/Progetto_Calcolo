Interpolazione polinomiale con i nodi di Leja Approssimati

L’obiettivo del progetto è implementare in Matlab l’interpolazione polinomiale sfruttando i nodi di Leja
sull'intervallo [−1,1], testandola con la funzione data 1/(x-1.3). Essendo il calcolo dei veri nodi computazionalmente molto oneroso, ci basiamo sui nodi di Leja approssimati estratti da una mesh fitta di 10^5 punti.
Nel progetto verranno implementati due metodi per il calcolo dell’interpolazione, DLP e DLP2, di cui si
stimerà la costante di Lebesgue per valutarne la stabilità e successivamente, verrà comparata
l’accuratezza dell’interpolante del metodo più efficace, confrontandola con quella ottenuta utilizzando i nodi equispaziati.
Andando più nello specifico.
L’implementazione del metodo DLP si basa sulla massimizzazione della produttoria. Si parte da un vettore colonna x (inizializzato con tutti uno) che memorizza, per ogni punto della
mesh, il prodotto cumulativo delle distanze dai nodi di Leja già selezionati. In seguito verrà aggiornato
moltiplicandolo con il vettore contenente le distanze (in modulo) dall’ultimo nodo scelto rispetto a tutti i punti di x. La vettorializzazione è un’operazione efficiente in MATLAB, e aggiorna tutti gli elementi simultaneamente. 
L’implementazione del metodo DLP2 si basa sulla fattorizzazione LU con pivoting sulle righe di matrice di Vandermonde in base di Chebyshev. Si parte sempre da un vettore colonna x che avrà i valori tra -1 e 1, con cui si calcolerà theta = arccos(x). Poi si calcola la matrice di Vandermode = cos di theta per il vettore riga che comprende i d+1 gradi dei polinomi (d=50). Infine viene eseguita la fattorizzazione LU con Pivoting parziale PV = LU e si restituiscono solo i primi d+1 indici di P (vettore di permutazione). Come ultimo passaggio si estraggono i punti della mesh corrispondenti agli indici selezionati e si esegue la funzione dlp su di essi. 
In entrambi gli algoritmi si forza il primo valore uguale 1.
I tempi, calcolati con le funzioni tic toc, mostrano che l’algoritmo DLP è più veloce rispetto a DLP2. Questa differenza è dovuta alla presenza della fattorizzazione LU che aggiunge del tempo ma guadagna in stabilità per gradi d alti. Con grado 50 sia DLP che DLP2 producono la stessa sequenza di nodi e di conseguenza anche l’andamento della costante di Lebesgue coincide.
La costante di Lebesgue è stimata con la quantità MAXxk∈M λd(xk) su una griglia densa M di 5000 punti equispaziati nell’intervallo [−1,1]. Viene calcolata la costante valutando la funzione di Lebesgue su ogni punto della griglia con la formula baricentrica. Prima costruisce i pesi baricentrici \(w_j = 1/\prod_{k\neq j}(z_j-z_k)\); poi, per ogni \(x_i\), valuta i termini \(w_j/(x_i-z_j)\) e calcola
\[
\lambda_d(x_i)=\frac{\sum_j |w_j/(x_i-z_j)|}{\big|\sum_j w_j/(x_i-z_j)\big|}.
\]
Nei punti coincidenti con i nodi il valore è posto pari a 1. Il massimo su tutti gli \(x_i\) è restituito come costante \(L\).
Presi dei nodi “buoni” (di Leja) la crescita della costante è lenta, circa O(log d) stabilizzandosi per gradi d ≥40 ed ha un andamento molto lento in scala semilogaritmica, a differenza nodi equispaziati, in cui la costante cresce rapidamente, quasi in modo esponenziale (appare pressoché lineare nel grafico) causando il fenomeno di Runge.
In conclusione l’errore dell’interpolante sui nodi di Leja, al crescere di d, descresce in maniera lineare per, mentre
per nodi equispaziati, con grado d ≈ 35 −40, l’errore si stabilizza e per grado d > 40, l’errore torna ad aumentare.