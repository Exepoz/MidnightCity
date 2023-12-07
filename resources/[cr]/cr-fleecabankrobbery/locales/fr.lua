CRFleecaLocales = {
    ['FleecaTitle'] = "Bracage de banque", -- Titre des Notification (okokNotify)
    ['doclabel'] = "Code de la porte :", -- Ce qui est écrit sur le document imprimé
    ['stickynotelabel'] = "Code du Coffre Fort :", -- Ce qui est écrit sur le papier jaune

    ['debug_loadingbanks'] = 'Chargement des banques...', -- Lorsque la configuration des banques charge.
    ['debug_targetsloaded'] = 'Cibles de sélections chargées (Target)', -- Lorsque les cibles sont chargées
    --['debug_startlockpick'] = 'Crochetage... (Project Sloth UI : %s)', -- Lorsque le jouer crochette la porte (%s -> vrai/faux si le serveur utilise PS-UI)
    ['debug_unlockdoor'] = "Porte Débarrée (%s)", -- Lorsqu'une porte se débarre. (%s -> Nom de la porte)
    ['debug_startinghack'] = 'Hack Commancé (%s)', -- Lorsque le joueur commance le hack (%s -> Nom du Hack Configuré)
    ['debug_hackconfigerror'] = 'Érreur dans la configuration du Hack, veuillez aviser l\'équipe de dévelopment.', -- Losqu'il y a une érreur dans la configuration du hack
    ['debug_printingcodes'] = "Succès du Hack, Impréssion du document & Activation de la cible de l'imprimante", -- Lorsque le joueur complète le hack avec succès
    ['debug_generatingloot'] = 'Génération du Butin (%s)', -- Lorsque les script génère le butin (%s -> Nom de la banque)
    ['debug_generatingtable'] = "Table : %s", -- Type de butin sur la table (%s -> or/argent)
    ['debug_generatingtray'] = "Tray #%s | Type : %s", -- Info sur les Tray (premier %s -> # du Tray, second %s -> or/argent)
    ['debug_generatingwall'] = "Mur #%s | Boites : %s", -- Deposit Boxes Info (premier %s -> # du Mur #, second %s -> Nombre de boite/loot rolls)
    ['debug_trayspawnerror'] = "Erreur dans la génération des cibles. Objet %s n'existe pas.", -- Debug si la généraitond de cible de fonctionne pas. (%s --> Entity #)
    ['debug_createtraytarget'] = "Creation de la cible sur object #%s. Position : %s", -- Lorsqu'une cible est créée.
    ['debug_cooldownerror'] = "Érreur lors de la remise a 0", -- Lorsqu'il y a une érreur dans la configuration du 'cooldown'
    ['debug_resetbanks'] = 'Remise a 0 des Banques...', -- Lorsque les banques sont 'reset'
    ['debug_BankActive'] = "Banque Active pour 10 minutes : %s", -- Lorsque quelqun débute la banque
    ['debug_BankInactive'] = "Banque Maintenant Inactive, Début de la remise a 0.", -- lorsque la banque devient innactive.

    ['EnterTellerOffice'] = "Vous êtes entré par effraction dans le guichet des caissiers...", -- Lorsque le joueur crochette avec succès la porte du guichet
    ["MissingItem"] = "Il vous manque quelque chose...", -- Lorsqu'il manque un objet au joueur
    ["MissingSpecificItem"] = "Il vous faut un % pour faire ca...", -- Lorsqu'il manque un object specifique au joueur
    ["LockpickFailed"] = "Vous n'avez pas réussi a crochetter la porte.", -- Lorsque le joueur ne parvient pas a ouvrir la porte du guichet
    ["USBInserted"] = "Vous insérez la clé usb dans l'ordinateur.", -- Lorsqu'un joueur commance le hack
    ["CodesFound"] = "Vous avez trouvez des codes de sécurité!", -- Lorsque le minijeu du hack commance
    ["SecurityBypass"] = "Vous avez contourné le système de sécurité!", -- Lorsque le joueur termine le hack avec succès
    ["SecurityBypassFailed"] = "Vous n'avez pas réussi a contourné le système de sécurité.", -- Lorsque le joueur ne réussi pas le hack.
    ["CodesPrinted"] = "Code de Sécurité imprimé, prenez le dans l'imprimante!", -- Lorsque les code de la porte s'imprime
    ['SafeTick'] = "Vous entendez un petit bruit.", -- Lorsque le petit coffre "tick"
    ['SafeCrackFailed'] = "Mauvaise Combinaison!", -- Losque le joueur ne parvient pas a ouvrir le petit coffre
    ["ReadingCard"] = "Lecture de la carte de sécurité", -- Lorsque le joueur utilise la carte pour ouvrir le coffre-fort
    ["HumanInputRequired"] = "Code de Sécurité du Coffre-Fort Requis", -- Lorsque le joueur doit entrer le code du coffre-fort
    ["OpenningVaultDoor"] = "Ouverture du Coffre-Fort dans %s minute(s).", -- Lorsque le joueur ouvre le coffre-fort (%s -> temps restant en minutes)
    ["VaultHalfTime"] = "Le Coffre-Fort s'ouvrira dans %s minutes", -- Lorsque l'ouverture du coffre-fort est a mi-temps (%s -> Temps en minutes))
    ["VaultDoorOpenned"] = "Ouverture du Coffre-Fort", -- Lorsque la porte du coffre-fort s'ouvre
    ["GrabbedLootMoney"] = "Vous trouvez %s$!", -- Lorsque le joueur trouve de l'argent (%s -> Montant)
    ["GrabbedLootItem"] = "Vous trouvez %s %ss !", -- Lorsque le joueur trouve quelquechose (premier %s -> Nombre d'objets recu, second %s -> Nom de l'objet)
    ["DrillBroke"] = "La perceuse a cassé!", -- lorsque la perceuse brise
    ["DepositBoxEmpty"] = "Cette boite est vide!", -- Lorsqu'une boite est vide
    ["EmptyWall"] = "Toutes les boites sur ce mur sont vides!", -- Lorsqu'il n'y a plus de boite disponible sur un mur
    ["BoxLockBroke"] = "Merde! Vous avez bloqué la serrure de cette boite!", -- Lorsque le joueur brise la serrure d'une boite
    ["CooldownMessage"] = "Vous ne pouvez pas faire ça pour le moment, revenez plus tard", -- Lorsque la banque est en cooldown
    ["NotEnoughCops"] = "Il n'y a pas assez de policiers en ville...", -- Lorsqu'il manque des policiers
    ['SecurityNeedsDisabling'] = "Tu ne peux pas faire ceci maintenant.", -- Si quelqun essaie de braquer le coffre lorsque la banque est innactive
    ['SawBladeBroke'] = "La lame de la scie a surchauffé et s\'est cassée!",

    ['progbar_lockpicking'] = 'Crochettage...', -- Lorsque le joueur crochette la porte
    ['progbar_lookingforcodes'] = 'Recherche D\'information...', -- Lorsque le joueur cherche dans l'ordinateur
    ['progbar_printingcodes'] = 'Impréssion...', -- Lorsque le joueur imprime le code
    ['progbar_insertingusb'] = 'Branchement de la clé USB', -- lorsque le joueur inserre la clé usb
    ['progbar_grabbing'] = 'Collecte..', -- Lorsque le joueur prend quelque chose
    ['progbar_swipingcard'] = 'Balayage de la carte...', -- Lorsque le joueur glisse la carte de sécurité
    ['progbar_readingdetails'] = 'Lecture...', -- Lorsque la carte ce fait lire.

    ['target_TellerDoors'] = "Crochet", -- Lockpicking Target
    ['target_TellerComputers'] = "Hack le Système", -- Hack Target
    ['target_Printers'] = "Prendre Document", -- Printer Target
    ['target_PreVaultDoors'] = "Entrer Le Code", -- PreVault Door Target
    ['target_AttemptSafe'] = "Essayer La Combination", -- Crack Safe Target
    ['target_LootSafe'] = "Vider le Coffre", -- Loot Safe Target
    ['target_VaultCards'] = "Glisser la carte", -- Slide Card Target
    ['target_DepositBoxes'] = "Percer Les Boites", -- Drill Target
    ['target_GrabLoot'] = "Prendre le Butin", -- Grab Loot Target
    ['target_BreakBoxes'] = "Scier les boites", -- Saw Target

    ['SawUI_Saw'] = "Scier", -- M1 "Saw" Action
    ['SawUI_Heat'] = "Température", -- Blade Heat

    ['DrillingUI_Drill'] = "Percer", -- M1 "Drill" action
    ['DrillingUI_Stop'] = "Arrêter", -- G "Stop" action
    ['DrillingUI_Progress'] = "Progrès", -- Progres
    ['DrillingUI_Depth'] = "Profondeur", -- Temperature de la lame
    ['DrillingUI_Hold'] = "Tenir la position!", -- Lorsque le joueur a la bonne profondeur et peut recevoir du loot bonus
    ['DrillingUI_TooDeep'] = "Trop profond", -- Lorsque le joueur est trop profond et abime la lame


    ['logs_robberystarted'] = '%s a commcer le braquage de la banque a %s', -- Succès du Hack (premier %s -> Nom du Joueur, second %s -> Nom de la banque)
    ['logs_vaultoppened'] = "%s a ouvert la porte du Coffre-Fort", -- Lorsque le Coffre-Fort s'ouvre (%s -> Nom du Joueur)
    ['logs_safelooted'] = "Petit Coffre", -- Titre lors de la prise de butin dans le petit coffre
    ['logs_loottitle'] = "Butin Recu", -- Titre lors de la prise du butin
    ['logs_player'] = "Joueur :", -- Joueur
    ['logs_found'] = "Butin :", -- Butin
    ['logs_qty'] = "Quantité :", -- Quantité
}