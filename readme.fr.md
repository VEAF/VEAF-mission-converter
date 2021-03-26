
## Comment transformer une mission existante ?

### Prérequis

#### Installation manuelle

Vous aurez besoin de quelques outils installés sur votre PC pour que ces scripts fonctionnent.

- LUA : il vous faudra un interpreter LUA, dans votre PATH, prêt à être appelé avec la commande `lua`
- 7zip : il vous faudra 7zip, ou un autre outil de compression ZIP, dans votre PATH, prêt à être appelé avec la commande `7zip`
- Powershell : vous aurez besoin de Powershell, et il faudra le configurer pour qu'il soit autorisé à exécuter des scripts (lire [cet article en anglais](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1)) ; dit simplement, vous devez lancer cette commande dans une fenêtre Powershell (en mode administrateur) : `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine`
- npm : il vous faudra le gestionnaire de modules de NodeJS, NPM, pour récupérer automatiquement les outils de création de mission VEAF ; voir [ici (en anglais)](https://www.npmjs.com/get-npm)

#### Installation avec Chocolatey

Ces outils nécessaires peuvent être installés facilement en utilisant *Chocolatey* (voir [ici (en anglais)](https://chocolatey.org/)).

**ATTENTION** : il ne faut surtout pas installer deux fois les outils, avec *l'installation manuelle* et *l'installation par Chocolatey* ! C'est **l'un ou l'autre** !

Pour installer Chocolatey, lancez cette commande dans une fenêtre Powershell (en mode administrateur) : `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

Une fois que *Chocolatey* est installé, vous pouvez installer les outils à l'aide de ces simples commandes dans une fenêtre *cmd* (en mode administrateur) :

- LUA : `choco install -y lua`
- 7zip : `choco install -y 7zip.commandline`
- npm : `choco install -y nodejs`

### Choisir une mission comme point de départ

Vous devez démarrer le processus avec un fichier de mission DCS qui servira de base à votre mission intégrant les scripts VEAF.

Nous vous fournissons des canevas vierges pour le Caucase (`empty-caucasus.miz`), la Syrie (`empty-syria.miz`) et le Golfe Persique (`empty-persiangulf.miz`).

Copiez la mission de votre choix dans la racine de ce répertoire, et renommez-la `template.miz`.

### Lancer le script init.cmd

Dans une invite de commande *cmd*, tapez simplement `init.cmd` suivi du nom de la mission que vous voulez construire (pas d'espace, pas de soulignés - tiret du 8).

Le nom de la mission sera le nom de votre projet. Il devrait être le même que le nom de ce répertoire (pas obligatoire, mais chaudement recommandé).

Il ne doit pas comporter d'espace, ni de soulignés (tiret du 8), et ne doit pas se terminer par `.miz` (ce n'est pas le nom d'un fichier de mission !).

#### Exemple

Mettons que je veuille initialiser une nouvelle mission que j'appellerai "La super mission de Zip - Caucase"

Je commence par remplacer les espaces par des tirets, et retirer les soulignés (aucun ici) : "La-super-mission-de-Zip-Caucase". Je fais une copie toute neuve de ce répertoire `VEAF-mission-directory-template` et je le renomme `La-super-mission-de-Zip-Caucase` (ce que j'appelle "le répertoire de la mission").

Comme je veux créer une mission dans le Caucase, et que je n'ai pas de mission à prendre comme base, je vais renommer `empty-caucasus.miz` en `template.miz` dans le répertoire de la mission.

Puis je vais lancer une invite de commande (`cmd`) et utiliser `cd` pour aller dans mon répertoire de mission, puis lancer `init.cmd La-super-mission-de-Zip-Caucase`

Ce script va prendre `template.miz` (qui est en fait `empty-caucasus.miz`, que j'ai renommé) comme base, et préparer le répertoire de la mission avec tout ce qu'il faut pour être en mesure de compiler la mission (créer le fichier `.miz`).

### Paramètres avancés

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

![schema](https://user-images.githubusercontent.com/172286/109006666-9a96ee80-76ab-11eb-871c-a77a1ffa4fd9.jpg)

## Comment compiler une mission

Voir [ce document](readme-build.fr.md).