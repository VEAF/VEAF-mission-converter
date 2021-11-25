
## Mais de quoi s'agit-il ?

Les missions VEAF sont stockées sous formes de fichiers dans un répertoire `src`, aux côtés d'autres fichiers qui servent à configurer les scripts et les outils.

Pour construire le fichier `.miz` qui pourra être exploité par DCS, il faut le *compiler* en lançant le script `build.cmd`. Ce processus utilise les fichiers stockés dans `src` et les outils VEAF pour générer le fichier `.miz`.

Ensuite, on peut jouer la mission, ou l'éditer (et la sauvegarder) dans l'éditeur de mission de DCS.
**Attention:** une fois la mission sauvegardée dans l'éditeur de DCS, elle est dans un état qui permet de la lancer pour tester, en local, mais pas de la lancer sur un serveur DCS (il faut faire quelques manipulations pour cela).

On peut re-transformer une mission `.miz` qui a été éditée dans l'éditeur de mission de DCS en fichiers dans `src` en utilisant le script `extract.cmd`. Il utilise le premier fichier `.miz` qu'il trouve dans le répertoire de la mission (au même endroit que le script `extract.cmd`) et dont le nom correspond à la mission configurée dans ce répertoire.

### Version graphique

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/build_cycle.jpg)

## Comment compiler une mission ?

### Prérequis

**Ces prérequis sont les mêmes que ceux nécessaires à la transformation d'une mission existante**
Si vous venez de là, [passez directement à la suite](#compiler-une-mission).

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

#### Installation manuelle

Si vous savez ce que vous faites, ou si vous détestez le chocolat (mais qui déteste le chocolat?), vous pouvez installer les outils requis manuellement.

Assurez-vous simplement que tous les outils listés ci-dessus sont fonctionnels avant de passer à la suite.

### Compiler une mission

C'est facile de compiler une mission à partir des sources ; il suffit de lancer le script `build.cmd`. Vous n'avez même pas besoin de le lancer dans une invite de commande `cmd`, il suffit de double-cliquer dessus.

Le processus va prendre tous les fichiers du répertoire `src`, récupérer la dernière version des outils *VEAF Mission Creation Tools* (à partir de GitHub), et compiler tout ça dans une mission prête à l'emploi pour DCS (dans un fichier `.miz`)

Ce fichier aura le même nom que la mission (configuré dans la première ligne du script `build.cmd`), et placé dans le répertoire `build`.

### Editer une version compilée

Une fois la mission compilée, copiez-là du répertoire `build` vers le répertoire de la mission (celui dans lequel se trouvent `extract.cmd` et `build.cmd`). Ensuite, ouvrez-la dans l'éditeur de mission de DCS, et éditez-la (ajouter/supprimer des unités, ajouter des triggers, changer des zones, etc.).

Egalement, vous pouvez éditer les fichiers source de la mission en parallèle (en utilisant un éditeur de texte, je conseille Notepad++ ou Visual Studio Code); en particulier, vous pouvez éditer :

- le fichier de configuration de la mission `src/scripts/missionConfig.lua`, pour définir les paramètres de la mission ; c'est le principal fichier source que vous éditerez.
- le fichier des canaux radio `src/radio/radioSettings.lua`, pour définir les canaux radio qui seront poussés dans les avions.
- les presets pour la météo dans `src/weatherAndTime`

So vous éditez un de ces fichiers, et parce qu'ils sont intégrés *dans* le fichier `.miz` de la mission, vous devrez *recompiler* la mission avant de pouvoir tester vos changements dans le jeu.

Il existe un moyen de tester facilement ces changements : le premier trigger de la mission contient une condition LUA, qui conditionne la méthode de chargement des scripts. Si elle est à `false`, les scripts seront chargés statiquement (i.e. ils seront chargés *à partir de la mission*) ; si elle est à `true`, les scripts seront chargés dynamiquement, et donc à chaque redémarrage de la mission dans DCS (ShiftGauche + R), vous pourrez tester les changements apportés aux fichiers.

![triggers](https://user-images.githubusercontent.com/172286/109670752-bac72180-7b73-11eb-9d20-cadd84bff1a5.jpg)

### Extraire une mission éditée

Une fois qu'une mission a été éditée et sauvée dans l'éditeur de mission de DCS, il faut *extraire* son contenu dans le répertoire `src`, afin de pouvoir le réinjecter plus tard avec le script `build`.

Pour ce faire, il suffit de lancer le script `extract.cmd`. Vous n'avez même pas besoin de le lancer dans une invite de commande `cmd`, il suffit de double-cliquer dessus.

Ce script va prendre n'importe quel fichier dont le nom commence par le nom de la mission (configuré dans la première ligne du script `extract.cmd`), dans le répertoire de la mission (celui dans lequel se trouvent `extract.cmd` et `build.cmd`, pas le répertoire `build`), extraire son contenu, le traiter et le stocker dans `src`.

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

### Paramètres avancés

#### Spécifier l'emplacement de l'exécutable 7zip

Si l'outil 7zip est installé mais n'est pas dans votre PATH, vous pouvez spécifier son emplacement dans la variable d'environnement `SEVENZIP`. C'est une chaine qui doit pointer vers l'exécutable `7za` (par ex: `c:\tools\7zip\bin\7zip.exe`)

#### Spécifier l'emplacement de l'exécutable LUA

De la même manière, vous pouvez spécifier son emplacement dans la variable d'environnement `LUA`. C'est une chaine qui doit pointer vers l'exécutable `lua` (par ex: `c:\tools\lua\bin\lua.exe`)

#### Ne pas marquer de pause

Si vous précisez la valeur "true" dans la variable d'environnement `NOPAUSE`, alors les scripts se déroulera sans marquer de pause.

