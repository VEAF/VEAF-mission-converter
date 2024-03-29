
## Mais à quoi ça rime ?

Cet ensemble d'outils (ce répertoire, les scripts `.cmd` qu'il contient et les programmes associés dans les outils VEAF Mission Creation Tools) peut être utilisé pour transformer une mission DCS existante (dans le format standard `.miz`) en un atelier complètement fonctionnel, avec lequel vous serez capable d'éditer, de construire et de déployer une mission DCS qui exploite les outils VEAF Mission Creation Tools.

Pour résumer :

`my-nice-mission.miz` -> (ce répertoire) -> dossier `my-nice-mission` -> `my-nice-mission-VEAF.miz`

Ce document vous aidera à :
- installer les outils et programmes requis
- utiliser cet ensemble d'outils pour transformer votre mission DCS existante en un répertoire atelier VEAF
- utiliser votre nouveau répertoire atelier VEAF pour éditer et déployer votre nouvelle mission

S'il vous plaît, commencez par lire ce document dans son ensemble, sans rien faire d'autre, avant de le relire en effectuant chaque étape.

Aussi, ne vous arrêtez pas avant la fin. Sinon, votre répertoire atelier VEAF serait dans un état intermédiaire, ce qui ne fonctionnera pas.

## Comment transformer une mission existante ?

### Prérequis
Vous aurez besoin de quelques outils installés sur votre PC pour que ces scripts fonctionnent.

- LUA : il vous faudra un interpreter LUA, dans votre PATH, prêt à être appelé avec la commande `lua`
- 7zip : il vous faudra 7zip, ou un autre outil de compression ZIP, dans votre PATH, prêt à être appelé avec la commande `7zip`
- Powershell : vous aurez besoin de Powershell, et il faudra le configurer pour qu'il soit autorisé à exécuter des scripts (lire [cet article en anglais](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1)) ; dit simplement, vous devez lancer cette commande dans une fenêtre Powershell (en mode administrateur) : `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine`
- nodeJS : il vous faudra NodeJS,pour faire tourner les programmes javascript des outils de création de mission VEAF ; voir [ici (en anglais)](https://nodejs.org/en/)
- yarn : il vous faudra le gestionnaire de modules Yarn, pour récupérer automatiquement les outils de création de mission VEAF ; voir [ici (en anglais)](https://yarnpkg.com/)

**ATTENTION** : il ne faut pas faire à la fois *l'installation manuelle* et *l'installation par Chocolatey* !

#### Installation avec Chocolatey

Ces outils nécessaires peuvent être installés facilement en utilisant *Chocolatey* (voir [ici (en anglais)](https://chocolatey.org/)).

**ATTENTION** : il ne faut surtout pas installer deux fois les outils, avec *l'installation manuelle* et *l'installation par Chocolatey* ! C'est **l'un ou l'autre** !

Pour installer Chocolatey, lancez cette commande dans une fenêtre Powershell (en mode administrateur) : `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

Une fois que *Chocolatey* est installé, vous pouvez installer les outils à l'aide de ces simples commandes dans une fenêtre *cmd* (en mode administrateur) :

- LUA : `choco install -y lua`
- 7zip : `choco install -y 7zip.commandline`
- nodejs : `choco install -y nodejs` ; puis fermez et réouvrez la fenêtre *cmd* (en mode administrateur)
- yarn : `npm install -g yarn`

Vous aurez quand même besoin de configurer Powershell pour qu'il soit autorisé à exécuter des scripts (lire [cet article en anglais](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1)) ; dit simplement, vous devez lancer cette commande dans une fenêtre Powershell (en mode administrateur) : `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine`

**ATTENTION** : si vous voyez une erreur bizarre qui parle de "illegal characters", comme dans le screenshot ci-dessous, vous avez sans doute oublié de lancer la commande d'élevation Powershell (juste au dessus).
![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/unknown.jpg)

#### Installation manuelle

Si vous savez ce que vous faites, ou si vous détestez le chocolat (mais qui déteste le chocolat?), vous pouvez installer les outils requis manuellement.

Assurez-vous simplement que tous les outils listés ci-dessus sont fonctionnels avant de passer à la suite.

### Créer un répertoire de travail et installer les fichiers

Créez un répertoire quelque part sur votre disque dur, et nommez le d'après le nom de votre mission. Ce sera votre répertoire de travail.

Par exemple, j'utilise `D:\dev\_VEAF\VEAF-OpenTraining-Caucasus` pour la misson Opentraining Caucasus.

**ATTENTION** : pas d'espace ni de caractère spécial dans ce nom de répertoire ! Par exemple, pas de `Program files` ni de `VEAF Missions` (mais `VEAF_missions` est correct).

Téléchargez l'archive de ce repository sur GitHub et dépaquetez tous les fichiers dans votre répertoire de travail. 

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/download_repository.jpg)

Ça doit donner ça :

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/working_folder.jpg)

### Choisir une mission comme point de départ

Vous devez démarrer le processus avec un fichier de mission DCS qui servira de base à votre mission intégrant les scripts VEAF.

Nous vous fournissons des canevas vierges pour le Caucase (`empty-caucasus.miz`), la Syrie (`empty-syria.miz`) et le Golfe Persique (`empty-persiangulf.miz`).

Copiez la mission de votre choix dans la racine de ce répertoire, et renommez-la `template.miz`.

Si vous choisissez une mission qui contient déjà des scripts et/ou des triggers, ce n'est pas un problème tant que rien n'entre en conflit avec les scripts VEAF et leurs librairies.

Dans le doute, contactez-moi (Zip) sur [le Discord de la VEAF](https://www.veaf.org/discord)


Si vous souhaitez réinjecter les scripts et les triggers VEAF dans une mission qui en contient déjà (d'une précédente version, peut-être pour rafraichir tout l'ensemble), il vous suffit de supprimer les triggers VEAF (ils devraient être colorés) et de sauvegarder la mission (dans l'éditeur de mission de DCS) avant de l'utiliser comme point de départ.

Si vous ne faites pas ça, votre mission ne sera pas fonctionnelle, il y aura trop de triggers et elle ne se chargera pas correctement.

### Lancer le script init.cmd

Ouvrez votre répertoire de travail dans l'explorateur Windows (le gestionnaire de fichiers) et double-cliquez sur le fichier `init.cmd`.

Il va vous demander le nom de votre mission. C'est le nom de la mission que vous voulez construire (pas d'espace, pas de soulignés - tiret du 8) ; par exemple `VEAF-test-mission`.

Le nom de la mission sera le nom de votre projet. Il devrait être le même que le nom de votre répertoire de travail (pas obligatoire, mais chaudement recommandé).

Il ne doit pas comporter d'espace, ni de soulignés (tiret du 8), et ne doit pas se terminer par `.miz` (ce n'est pas le nom d'un fichier de mission DCS !).

#### Exemple

Mettons que je veuille initialiser une nouvelle mission que j'appellerai "La super mission de Zip - Caucase"

Je commence par remplacer les espaces par des tirets, et retirer les soulignés (aucun ici) : "La-super-mission-de-Zip-Caucase". J'extrais une copie toute neuve de ce repository GitHub dans un nouveau répertoire que j'appelle  `La-super-mission-de-Zip-Caucase` (ce que j'appelle "le répertoire de la mission").

Comme je veux créer une mission dans le Caucase, et que je n'ai pas de mission à prendre comme base, je vais renommer `empty-caucasus.miz` en `template.miz` dans le répertoire de la mission.

Puis j'ouvre l'explorateur de fichiers Windows, et je double-clique sur `init.cmd`.

Quand il me demande `What's the name of your mission (no space, no underscore, no accents) ?` je tape le nom de ma mission `La-super-mission-de-Zip-Caucase`.

Ce script va prendre `template.miz` (qui est en fait `empty-caucasus.miz`, que j'ai renommé) comme base, et préparer le répertoire de la mission avec tout ce qu'il faut pour être en mesure de compiler la mission (créer le fichier `.miz`).

### Editer la mission dans DCS et lancer le premier extract

Le script va tourner, et vous pourrez vérifier les messages pour vous assurer que tout se passe bien.

A la toute fin, il se mettra en pause et vous rappellera que vous devez ouvrir le fichier de mission qu'il vient de créer dans l'éditeur de mission de DCS, vous assurer qu'il y a au moins une unité au sol dans chaque camp (bleu **et** rouge), ajouter un slot Game Master et le sauvegarder.

### Editer et sauver la mission dans DCS pour la première fois

Faisons donc ça. Commencez par ouvrir la mission qui vient d'être créée dans l'éditeur de mission de DCS.

Puis, dans la barre d'outil principale de l'éditeur :

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/dcs_toolbar.jpg)

Cliquer sur le bouton "game slots" (1), ajouter au moins un Game Master à la coalition bleue.

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/add_game_master.jpg)

Cliquer sur le bouton "ajouter une unité au sol" (2), ajouter au moins une unité dans chaque camp (bleu **et** rouge).

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/add_unit.jpg)

Sauvegarder la mission (3)

#### Extraire les fichiers de la mission pour les stocker en sécurité

La mission est prête désormais, sous la forme d'un fichier de mission DCS (avec une extension `.miz`).

Nous devons lancer le script `extract.cmd` afin de stocker en sécurité le contenu de ce fichier de mission dans le répertoire `src` de notre répertoire de travail.

Pour faire ceci, il suffit de double-cliquer sur le fichier `extract.cmd` dans l'explorateur de Windows, et d'attendre qu'il termine son travail.

A la fin de l'exécution, le script se mettra en pause pour que vous puissiez vérifier que tout s'est bien passé et finalement fermer la fenêtre.

**Note:** le script peut (et va) afficher des erreurs, dont certaines sont normales (voire attendues); il ne faut pas s'en inquiéter :

- Erreur de headers, due au fait que DCS sauvegarde les fichiers `.miz` dans un format `zip` particulier

```
WARNINGS:
Headers Error
```

- Erreur de nettoyage d'un fichier qui n'existe pas

```
deleting veafTransportMission.lua
deleting veafUnits.lua
The system cannot find the file specified.
The system cannot find the file specified.
The system cannot find the file specified.
The system cannot find the file specified.
```

### Prochaine étape

Maintenant que vous avez un répertoire de travail avec tout ce qu'il faut pour construire et gérer une mission VEAF, vous devriez lire [ce document](readme-build.fr.md) qui explique le cycle compilation -> édition -> extraction.

### Paramètres avancés

Vous pouvez aussi lancer les scripts avec des paramètres, dans une invite de commande.

Dans une invite de commande *cmd*, tapez simplement `init.cmd` suivi du nom de la mission que vous voulez construire (pas d'espace, pas de soulignés - tiret du 8).

Par exemple : `init.cmd VEAF-test-mission`.

#### Choisir un autre fichier de mission comme modèle

Par défaut, le script recherche un fichier `template.miz` et l'utilise comme base pour la nouvelle mission.

Il est possible de spécifier un autre fichier comme modèle ; par exemple `init.cmd La-super-mission-de-Zip-Caucase empty-caucasus.miz`

#### Choisir le niveau de log dans l'injecteur de trigger

En précisant une valeur dans la variable d'environnement `LUA_SCRIPTS_DEBUG_PARAMETER`, il est possible de régler le niveau de retour (log) du script LUA chargé d'injecter les triggers.

Les valeurs possibles sont :

- `-debug` : niveau de débogage, informations supplémentaires
- `-trace` : niveau de traçage, on écrit tout

C'est utile pour essayer de comprendre quand quelque chose ne fonctionne pas.

#### Spécifier l'emplacement de l'exécutable 7zip

Si l'outil 7zip est installé mais n'est pas dans votre PATH, vous pouvez spécifier son emplacement dans la variable d'environnement `SEVENZIP`. C'est une chaine qui doit pointer vers l'exécutable `7za` (par ex: `c:\tools\7zip\bin\7zip.exe`)

#### Spécifier l'emplacement de l'exécutable LUA

De la même manière, vous pouvez spécifier son emplacement dans la variable d'environnement `LUA`. C'est une chaine qui doit pointer vers l'exécutable `lua` (par ex: `c:\tools\lua\bin\lua.exe`)

#### Ne pas marquer de pause

Si vous précisez la valeur "true" dans la variable d'environnement `NOPAUSE`, alors les scripts se déroulera sans marquer de pause.

## Comment transformer une mission existante - version graphique

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/initialize.jpg)

## Comment compiler une mission

Voir [ce document](readme-build.fr.md).
