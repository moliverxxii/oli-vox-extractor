programme pour extraire les voix à partir d'un morceau original et de sa
version instrumentale.

TODO:
1/creation "d'empreinte acoustique":
	entrée:
		vecteur multicanal (n_echantillons x n_canaux), 
		taille de bloc (s), 
		saut (s),
		frequence d'echantillonage (Hz)
	sortie:
		vecteur multi_paramètres (n_blocs x n_paramètres) 
			exemple de "paramètres": puissances bandes de 
				fréquences.(dBFS)
		taille de bloc (échantillon)
		saut (échantillon)
2/algorithme de positionnement:
	utilisation de l'empreinte acoustique pour localiser grossièrement la 
	piste originale dans la piste instrumentale
3a/graphique de la position dans la piste instrumentale en fonction de la
position dans la piste originale.

3b/graphique de la position grossière.

4/conversion .mp3, .m4a, .wav frequences d'échantillonage.

5/génération automatique de liste de pistes à gérer.

6/génération de liste de candidats en fonction de la corrélation de l'empreinte
acoustique et séléction selon les meilleurs maxima locaux.

7/conversion position empreinte acoustique:
	entrée:
		position dans l'empreinte acoustique
		taille de bloc (échantillon)
		saut (échantillon)
	sortie:
		position début (échantillon)
		position fin (exclus, échantillon)

8/soustraction de vecteurs:
	entrée:
		vecteur multicanal 1 (n_echantillons x n_canaux),
		vecteur multicanal 2 (n_echantillons x n_canaux),
		position 1 (échantillons),
		position 2 (échantillons),
		taille maximum du bloc,
		mode de soustraction:
			filtre?
			corrélation vs produit scalaire?
			multicanal sommé?
	sortie:
		vecteur multicanal (n_bloc x n_canaux)
		

9/graphiques (selon la position du morceau):
	taux de réjection
	corrélation.
	coéfficient annulateur.
	rapport de (puissance voix)/(puissance totale) (%).
	
10/sélection de fenètres de reconstruction.

11/tests pour chaques fonctionnalités.
