
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

Voir [cette page](https://veaf.github.io/documentation/environment/index.fr.html) - [also in english](https://veaf.github.io/documentation/environment/) - pour les instructions aidant à installer tous les outils prérequis.

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

### Chargement dynamique des scripts
Comme mentionné précédemment, le framework de mission permet une transition facile entre les scripts de mission statiques et dynamiques. Le chargement statique doit toujours être utilisé pour la version finale de votre mission, tandis que le mode dynamique offre un moyen rapide et facile de tester et d'ajuster les scripts pendant le processus de développement.

#### Construction en mode dynamique
Bien qu'il soit possible de modifier manuellement le prédicat du déclencheur `MISSION START (choose - static or dynamic)`, comme expliqué précédemment, une autre méthode consiste à avoir un `build.cmd` personnalisé qui construira la mission en mode dynamique. La boucle d'extraction/construction reste la même, avec la possibilité supplémentaire de construire en mode dynamique ou statique selon la commande de construction utilisée.

Pour ce faire, créez un fichier de commande dans le dossier de mission, à côté de `build.cmd`. Vous pouvez le nommer par exemple `build-dynamic.cmd`.
```
set DYNAMIC_LOAD_SCRIPTS=true
set MISSION_FILE_SUFFIX1=dynamic
call build.cmd
```
- `DYNAMIC_LOAD_SCRIPTS` indiquera à la commande de construire la mission en mode dynamique.
- `MISSION_FILE_SUFFIX1` est optionnel mais recommandé pour pouvoir identifier les missions dynamiques par leur nom.

#### Chargeur de configuration dynamique
Dans le dossier `src/scripts`, vous trouverez le fichier suivant : `veafDynamicConfig.lua`. C'est le seul script que le déclencheur `MISSION START (choose - static or dynamic)` exécutera en mode dynamique.

Par défaut, ce script ne chargera et n'exécutera que le script `missionConfig.lua`. Mais si la logique de votre mission le nécessite, vous pouvez le modifier pour charger plus de scripts. Ces scripts supplémentaires peuvent être chargés avant `missionConfig.lua` (pour les dépendances générales qui seront nécessaires aux scripts suivants) ou après (pour la logique de mission qui aura besoin des scripts veaf chargés par `missionConfig.lua`).

Tous les scripts lua supplémentaires devront être présents dans le dossier `src/scripts`.
Notez que pour avoir ces scripts chargés également en mode statique, vous devrez modifier le `MISSION START (mission config - static)` et ajouter une action pour chaque fichier à charger, dans le bon ordre.

Pour le chargement dynamique, seule la table `scriptsToLoad` devra être modifiée dans `veafDynamicConfig.lua`.

Exemple :
```
local scriptsToLoad =
{
    -- charger AVANT missionConfig.lua
    "Moose.lua",
    "FgTools.lua",
    "FgWeather.lua",    
    "FgCsg2.lua",
    -- missionConfig.lua
    "missionConfig.lua",
    -- charger APRÈS missionConfig.lua
    "FgMission.lua"
}
```

### Paramètres avancés

#### Spécifier l'emplacement de l'exécutable 7zip

Si l'outil 7zip est installé mais n'est pas dans votre PATH, vous pouvez spécifier son emplacement dans la variable d'environnement `SEVENZIP`. C'est une chaine qui doit pointer vers l'exécutable `7za` (par ex: `c:\tools\7zip\bin\7zip.exe`)

#### Spécifier l'emplacement de l'exécutable LUA

De la même manière, vous pouvez spécifier son emplacement dans la variable d'environnement `LUA`. C'est une chaine qui doit pointer vers l'exécutable `lua` (par ex: `c:\tools\lua\bin\lua.exe`)

#### Ne pas marquer de pause

Si vous précisez la valeur "true" dans la variable d'environnement `NOPAUSE`, alors les scripts se déroulera sans marquer de pause.

#### Contruction en mode dynamique
Pour constuire la mission en mode dynamique, positionnez `DYNAMIC_LOAD_SCRIPTS=true`