#  ICLR 2018 Reproducibility Challenge
### Final project report: Neural Networks and Deep Learning 2017, University of Wrocław
#### [*Wojciech Fica*](wojtekfica@gmail.com), [*Jakub Piecuch*](j.piecuch96@gmail.com), [*Julian Pszczołowski*](julian.pszczolowski@gmail.com)


The aim of this report is to discuss results presented in [_Word translation without parallel data_](https://arxiv.org/pdf/1710.04087.pdf) by A. Conneau, G. Lample, M. Ranzato, L. Denoyer and H. Jegou. The report consists of two parts. First, we answer question raised by our instructor. Then, we give a summary of our efforts to reproduce results claimed by the authors.

We found the paper clearly written and the subject matter very interesting. We appreciate the fact that the authors made the code available on github. This allowed us to thorougly analyse all the steps of the training procedure.

## Part 1: The Instructor's Questions

### 1. Is the code consistent with the paper?
Yes, it is. In particular:
- Every step of the training procedure is visible in the source code
- The parameters are initialized using some default method from PyTorch. There are no hidden constants used
  to initialize the model's parameters.

Some minor comments:
- The paper states:
> we include a smoothing coefficient s = 0.2 in the discriminator predictions,

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;while the default value of the ```dis_smooth``` parameter is `0.1`.
- In the paper, the generator's loss takes into account the discriminator's accuracy on samples from the target language (i.e. the worse the accuracy, the lower the loss). It is not clear to us why this is the case. On the one hand, the accuracy does not depend on generator's parameters, which is why it seems unnecessary to include this term. On the other hand, it does not break anything, since it does not affect the gradient.
- The authors cite the paper _Adversarial Training for Unsupervised Bilingual Lexicon Induction_ by Zhang et al. (2017), in which the generator's loss does not take into account the discriminator's accuracy on embeddings of the target language.

### 2. What is the validation method? How many words are used for validation?
The validation method is as follows:
- k is chosen from {1, 5, 10},
- Let W consist of 1500 words that are arbitrarily chosen to be translated,
- Let D consist of 200k most frequent words from the target language,
- For each word of W: k best translations belonging to D are chosen,
- The percentage of correct translations is calculated.

### 3. How does the criterion from chapter 3.5 work?
The criterion is used to select the best model after adversarial training. It works as follows:
- Using the learned mapping, a dictionary is created from 10k most frequent words from both languages.
- For each (source word, target word) pair in the dictionary, the cosine similarity between the
  mapped source word vector and the target word vector is computed.
- Finally, the average over all such pairs is computed and used as the unsupervised criterion.

### 4. How many most frequent words are used during each stage of the algorithm?

- 200k most frequent words are used for the validation (see 1.2).
- 50k most frequent words are used for training the discriminator.
- The Procrustes step considers as many pairs as the algorithm produces. That is, a pair (Wx, y) is considered to be a translation if y is a kNN of Wx and Wx is a kNN of y. (The constant k = 10 is used for kNN. The authors claim that they did experiments with k = 5, 10 or 50 and the results were comparable.)
- In the validation step 10k most frequent words are considered. CSLS is used to find translations of those, and then the average cosine similarity between the words and their translations is computed.

### 5. The authors use their own high-quality dictionaries. Can you comment on them?

We looked closely at, in the paper called ground-truth, English-German dictionary.

The dictionary contains 951 (95.1%) words out of 1000 most frequent English words. The following are missing:
```
a ago American among another as at be by Congress Democrat do establish go he herself himself I if in into it me Mr Mrs my no n't of oh ok on onto or PM relate Republican so than themselves those throughout to toward TV up upon us we
```
The dictionary contains 2857 (95.2%) words out of 3000 most frequent English words. The following are missing:
```
a ad African African-American ago ah AIDS AM American among another anymore appreciate Arab as Asian at be Bible British by Canadian Catholic CEO Chinese Christian Christmas conclude Congress congressional consist Democrat depending differently distinct DNA do elect e-mail emerge English entirely essentially establish European facility French furthermore German go God he heavily herself hi himself I ie if in incorporate Indian Internet into Iraqi Irish Islamic Israeli it Italian Japanese Jew Jewish Latin long-term manner me Mexican mm-hmm moreover Mr Mrs Ms Muslim my newly no nod notion n't obtain of oh ok Olympic on onto or ought ourselves Palestinian pant PC PM portion pursue rapidly regard regarding relate rely Republican Russian Senate shortly shrug so so-called Soviet Spanish suppose Supreme tablespoon tale than themselves those throughout to toward towards TV undergo United unless unlike up upon us vs we whenever whereas
```

The dictionary consists of 101931 pairs of translations, some of which are repeated. There are 74655 unique words.
It seems that there would be no benefit from enlarging the dictionary as it is already of not so high quality.


## Part 2: The reproduction of the results

We focused on word translation retrieval using CSLS KNN. First we attempted to reproduce the results in the EN to ES translation task, then we trained the model in the EN to PL translation task.

### EN to ES

To start with, we ran 5 epochs of adversarial training to learn a mapping from EN to ES embeddings.

EN to ES word translation accuracy:
- @1 `31.8%`
- @5 `49.0%`
- @10 `56.5%`

where @k (as in the paper) means that we looked for correct translation among k nearest neighbours of source word multiplied by matrix `W`.

Then, we ran EN-ES for a large amount of epochs, but it automatically stoped near epoch 25, when the improvement in the unsupervised criterion was negligible.

Results for EN-ES word translation accuracy:
- @1 `75.7%`
- @5 `87.8%`
- @10 `90.3%`

The results for EN-ES are comparable to those presented in the paper.

---

We also changed the source code a little in order to get those translations and not only percentage accuracy.

Here are some sample translations for EN-ES:
```
thursday: sábado miércoles viernes martes jueves lunes mañana madrugada día víspera
operators: operadores operadoras operador demostradores prestadores contadores suministradores operados cooperadores operadas
chilean: chileno chileno» peruano chilena chilenos chilenas chile, arequipeño chilena» arequipeña
departed: arribando embarcaría partió partieron regresarían regresaba regresaron embarcaron arribó embarcando
dirty: sucia sucios sucias sucio limpia poquianchis trapos harapos maldita morocha
dimension: dimensión dimensionalidad dimensionado dimensionar dimensionales dimensional dimensionamiento tetradimensional unidimensional espaciotemporal
cleared: despejando despejar despeja despejaron despejó adelantadas quedando allanando aclaradas adelantando
simpson: simpson mcbain stewart matthews reubens partridge reid mccauley buckley willis
thriller: thriller suspense policiaca suspenso policíaca policíaco policiaco littín fotonovela ambientada
richardson: crowell willis richardson hollingsworth woodard stowell howells mcwilliams mcgillis milligan
grants: otorgaran becas concedan concedidos otorgara otorgamiento conceden otorgadas otorguen otorgados
tested: probando probados probadas probaron pruebas probado prueba probada probó probar
paying: pagar pagando pagada pago remuneración paga adeudaba retribución pagaran pagase
spy: espía espías espionaje contraespionaje secreta secreto desertor secretos encubierto exagente
silly: absurda tonta tontería estúpida ridícula ridículo descabellada absurdas chocante pataleta
novelists: novelistas ensayistas cuentistas escritoras escritores autobiógrafos literarios dramaturgos ilustradores poetas
warrior: guerrera espadachín guerreros samurái valeroso guerreras gladiador samurai paladín guerrero
cornell: cornell stanford tufts yale harvard northwestern depaul duke ucla wesleyan
probability: probabilidad probabilidades probabilístico probabilísticas probabilística probabilísticos probabilista estimador varianza estocástico
subway: metro monorraíl monorail –avenida premetro metrotrén square–calle metrotranvía shinkansen autobus
```

---
### EN to PL

Again, we ran 5 epochs of adversarial training, this time to learn a mapping from EN to PL embeddings.

EN to PL word translation accuracy:
- @1 `0.0%`
- @5 `0.0%`
- @10 `0.0%`

Clearly, after 5 epochs on the EN-PL task the model works terribly, whereas on EN-ES it worked OK.

This significant difference might be caused by the fact that, compared to English or Spanish, there is an enormous number of inflection rules in Polish. For example, the word 'mam' could be derived from any of these: 'mama' [mother], 'mamić' [to beguile] or 'mieć' [to have]. Another example: the word 'dwa' [two] appears in Polish in a lot of forms: 'dwaj', 'dwie', 'dwóch', 'dwu', 'dwóm', 'dwom', 'dwoma', 'dwiema', 'dwójce', 'dwojgiem', 'dwojga', 'dwojgu', 'dwójka', etc. -- each means "two" but in different contexts.

---

We tried to improve the model's performance on the EN-PL translation task by using custom Polish embeddings. First, using [PoliMorf](http://zil.ipipan.waw.pl/PoliMorf), a Polish morphological dictionary, we mapped words common Polish words to their uninflected forms. If there were multiple uninflected forms of a word then we chose the one which appeared more times frequently on Wikipedia (e.g. for 'mam' we chose 'mieć'). Then, we processed the entire text of Wikipedia using our mapping, and used it as our corpus on which we trained new Polish embeddings. The model appeared to learn more quickly and we could gain acceptable results instead of just 0%.

This time, we ran EN-PL tasks for a large amount of epochs but it automatically stoped near epoch 25, when the improvement in the criterion was too small.

Results for EN-PL word translation accuracy:
- @1 `43.3%`
- @5 `60.7%`
- @10 `66.5%`


Here are some samples of EN-PL translations. 10 nearest neighbours are given, starting with the closest (the most probable):
```
fountain: fontanna grota nimfeum wodotrysk kandelabr skwer kapliczny zdrojowy fontanka altana
vernon: michalin puchała augustynek tworek roszczynialski miegoń pietraszek kobiela poreda krzymiński
dust: szron pył pyłowy mgiełka dziura obłok drobinka kropelka brud okruch
moments: przebłysk przedsmak dwudziestominutowy emocjonować trzyminutowy dwuminutowy kilkuminutowy dziesięciominutowy pamiętny jednominutowy
discography: dyskografia bublé tangled foxy discografia koяn p-funk ub40 jarboe audioslave
barrier: bariera barierowy przegrodzić ochronny newralgiczny wodochronny odgrodzić zakotwić chronić igielny
bee: szerszeń chrabąszcz szarak świerszczak ćma skakun cykada szarańczak szpak trzmiel
gathering: zbierać urządzać zebranie gromadzić zebrać doroczny dorocznie odbywać dożynek obywać
researcher: naukowiec ekspertka badaczka amerykanista biolog badanie iranista biocybernetyka radiobiologia neurobiolog
lover: kochanek ukochać kochanka zakochać pokochać wejrzeć nieznajomy rozkochać pocałunek ukochany
rap: hip-hopowy trip-hop hip-hop hopowy rap gangsta hop doggystyle rapcore crunk
casting: montaż casting charakteryzacja ekranowy superprodukcja podkładać gorący castingowy obsada spellinga
morrison: roniewicz kwietniewski rynkowski solak promiński piętowski sipiński koralewski konwiński mazolewski
honored: uhonorować honorować wręczać nagrodzić zasłużyć honorowy patronować przyznawać cześć uczcić
chest: piersiowy dłoń klatka szyja głowa przedramię brzuch kark plecy pierś
strait: cieśnina półwysep morze zatoka płw kerczeński atlantyk bering kaletański mierzeja
indo: austronezyjski austroazjatycki indoirański indoeuropejski indoaryjski nieindoeuropejski atapaskański wschodnioazjatycki mon-khmer zachodniogermański
announcement: zapowiedzieć zapowiedź oficjalny poinformować zaanonsować ogłosić intencyjny anonsować sierpniowy oświadczyć
harmony: harmonia harmonijny dysharmonia harmonista harmonijnie harmonica instrumentalizacja współbrzmienie harmonies armonia
accuracy: niedokładność dokładność precyzja precyzyjność niedokładny korygować dokładny trafność poprawność porównywalność
```

To conclude, the paper is nicely written, the subject is interesting, and the method gives good performance.

## Acknowledgments
The authors thank Google for GCE Credits awarded through Google Cloud Platform Education Grants to the Neural Networks and Deep Learning course and to this project.

