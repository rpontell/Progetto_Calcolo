# Spiegazione funzioni matlab presenti nel codice
- **Transoponi** B = A.' opp. B = transpose(A)
- **Colonna** A(:)
- **Semicolonna** ; Il simbolo del punto e virgola (;) sopprime l'output di un singolo comando, separa più comandi sulla stessa riga sopprimendo l'output, e denota anche la fine di una riga quando si crea un array. Ad esempio, [12 13; 14 15] usa un punto e virgola per specificare la fine di una riga in un array.
- **.\* ./** Il simbolo del punto (.) separa la parte intera e frazionaria di un numero, denota operazioni elemento per elemento, e indicizza anche variabili di tabella, campi di struttura e proprietà e metodi di oggetti. Ad esempio, l'operazione elemento per elemento A.*B moltiplica ciascun elemento di A con l'elemento corrispondente in B.
- **n = numel(A)** restituisce il numero di elementi n nell’array A
- **T = true(n)** è una matrice n x n di uni logici.
- **X = ones(n)** restituisce una matrice n x n di numeri uno.
- **X = zeros(n)** restituisce una matrice di zeri n x n.
- **Y = abs(X)** restituisce il valore assoluto di ciascun elemento nell’input X.
- **M = max(A)** restituisce gli elementi massimi di un array. Se A è un vettore, max(A) restituisce il massimo di A. Se A è una matrice, max(A) è un vettore riga contenente il valore massimo di ciascuna colonna di A. Se A è un array multidimensionale, max(A) opera lungo la prima dimensione di A la cui grandezza non è uguale a 1, trattando gli elementi come vettori. La grandezza di M in questa dimensione diventa 1, mentre le grandezze di tutte le altre dimensioni rimangono le stesse come in A. Se A è un array vuoto la cui prima dimensione ha lunghezza pari a zero, M è un array vuoto con la stessa grandezza di A. Se A è una tabella o un orario, max(A) restituisce una tabella di una riga contenente il massimo di ciascuna variabile. (da R2023a)
- **ciclo For**
```matlab
  for index = values
     statements
  end
```
- if
```matlab
    if expression
        statements
    elseif expression
        statements
    else
        statements
    end
```
- **error(msg)** lancia un errore e visualizza un messaggio di errore.
- **M = min(A)** restituisce gli elementi minimi di un array. Se A è un vettore, allora min(A) restituisce il minimo di A. Se A è una matrice, allora min(A) è un vettore riga contenente il valore minimo di ciascuna colonna di A. Se A è un array multidimensionale, allora min(A) opera lungo la prima dimensione di A la cui dimensione non è uguale a 1, trattando gli elementi come vettori. La dimensione di M in questa dimensione diventa 1, mentre le dimensioni di tutte le altre dimensioni rimangono le stesse come in A. Se A è un array vuoto la cui prima dimensione ha lunghezza zero, allora M è un array vuoto con la stessa dimensione di A. Se A è una tabella o un orario, allora min(A) restituisce una tabella di una riga contenente il minimo di ciascuna variabile. (da R2023a)
- **Y = acos(X)** restituisce il Coseno inverso (cos<sup>-1</sup>) degli elementi di X in radianti. La funzione accetta sia input reali che complessi. Per i valori reali di X compresi nell'intervallo [-1, 1], acos(X) restituisce valori compresi nell'intervallo [0, π].
- **Y = cos(X)** restituisce il coseno per ciascun elemento di X. La funzione cos opera elemento per elemento sugli array. La funzione accetta sia input reali che complessi. Per i valori reali di X, cos(X) restituisce valori reali nell’intervallo [-1, 1].
- **[L,U,P] = lu(A,outputForm)** restituisce P nella forma specificata da outputForm. Specificare outputForm come 'vector' per restituire P come vettore di permutazione tale che A(P,:) = L*U. (nel codice ignoriamo i primi due valori usando ~)
- **B = prod(A)** restituisce il prodotto degli elementi dell'array A. Se A è un vettore, allora prod(A) restituisce il prodotto degli elementi. Se A è una matrice non vuota, allora prod(A) tratta le colonne di A come vettori e restituisce un vettore riga dei prodotti di ciascuna colonna. Se A è una matrice vuota 0x0, prod(A) restituisce 1. Se A è un array multidimensionale, allora prod(A) agisce lungo la prima dimensione non singleton e restituisce un array di prodotti. La dimensione di B in questa dimensione si riduce a 1, mentre le dimensioni di tutte le altre dimensioni rimangono le stesse come in A. Se A è una tabella o un orario, allora prod(A) restituisce una tabella di una riga dei prodotti di ciascuna variabile. prod calcola e restituisce B come single quando l'input, A, è single. Per tutti gli altri tipi di dati numerici e logici, prod calcola e restituisce B come double.
- **S = sum(A)** restituisce la somma degli elementi di A lungo la prima dimensione dell'array la cui dimensione è non è uguale a 1. Se A è un vettore, sum(A) restituisce la somma degli elementi. Se A è una matrice, sum(A) restituisce un vettore riga contenente la somma di ciascuna colonna. Se A è un array multidimensionale, sum(A) opera lungo la prima dimensione dell’array la cui grandezza non è uguale a 1, trattando gli elementi come vettori. La grandezza di S in questa dimensione diventa 1, mentre le grandezze di tutte le altre dimensioni rimangono le stesse come in A.
Se A è una tabella o un orario, sum(A) restituisce una tabella di una riga contenente la somma di ciascuna variabile.
- **y = linspace(x1,x2,n)** genera n punti. La spaziatura tra i punti è (x2-x1)/(n-1). linspace è simile all’operatore due punti “:”, ma consente di controllare direttamente il numero di punti e include sempre i punti finali. “lin” nel nome “linspace” si riferisce alla generazione di valori linearmente distanziati rispetto alla funzione sorella logspace che genera valori logaritmicamente distanziati.
- **figure** crea una nuova finestra della figura utilizzando i valori predefiniti delle proprietà. La figura risultante è la figura corrente.
- **plot(X,Y,LineSpec)** crea un grafico a linee bidimensionale dei dati in Y rispetto ai valori corrispondenti in X. Per tracciare un insieme di coordinate collegate da segmenti lineari, specificare X e Y come vettori di pari lunghezza.Per tracciare più insiemi di coordinate sullo stesso insieme di assi, specificare almeno X o Y come una matrice. crea il grafico utilizzando lo stile delle linee, il marcatore e il colore specificati.
- **semilogy(X,Y,LineSpec)** traccia coordinate x e y utilizzando una scala lineare sull'asse x e una scala logaritmica in base 10 sull'asse y. Per tracciare un insieme di coordinate collegate da segmenti lineari, specificare X e Y come vettori della stessa lunghezza. Per tracciare più insiemi di coordinate sullo stesso insieme di assi, specificare almeno uno tra X o Y come matrice. crea il grafico utilizzando lo stile delle linee, il marcatore e il colore specificati.
- **Marker** s- punti a quadrato e linea continua, o- punti circolari con linea continua, d- punti romboidali e linea continua
- **hold on** serve a far rimanere il primo piano il grafico che lo precede
- **grid on** mostra la griglia
- **xlabel** etichetta sull'asse x
- **ylabel** etichetta sull'asse y
- **title** titolo del grafico
- **legend(label1,...,labelN,'Location',lcn)** legend crea una legenda con etichette descrittive per ciascuna serie di dati tracciata. Per le etichette, la legenda utilizza il testo delle proprietà DisplayName delle serie di dati. Se la proprietà DisplayName è vuota, la legenda utilizza un'etichetta di formato 'dataN'. La legenda si aggiorna automaticamente quando si aggiungono o rimuovono serie di dati dagli assi. Questo comando crea una legenda negli assi correnti che viene restituita dal comando gca. Se gli assi correnti sono vuoti, la legenda è vuota. Se non esistono assi, legend crea degli assi cartesiani. imposta le etichette della legenda. Specificare le etichette come un elenco di vettori di caratteri o di stringhe, come legend('Jan','Feb','Mar'). imposta la posizione della legenda. Ad esempio, 'Location','northeast' posiziona la legenda nell'angolo superiore destro degli assi. Specificare la posizione dopo gli altri argomenti di input.