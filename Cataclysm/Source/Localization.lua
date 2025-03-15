local _, rm = ...
local L = rm.L

L.achievement = BATTLE_PET_SOURCE_6
L.boss = BOSS
L.brightness = OPTIONS_BRIGHTNESS
L.chance = GARRISON_MISSION_CHANCE
L.classes = ITEM_CLASSES_ALLOWED
L.color = COLOR
L.common = ITEM_QUALITY1_DESC
L.congratulations = SPLASH_BOOST_HEADER
L.crafters = GUILD_TRADE_SKILL_CRAFTERS_COLON
L.drop = LOOT
L.dungeon = LFG_TYPE_DUNGEON
L.elite = ELITE
L.enchant = ENSCRIBE
L.epic = ITEM_QUALITY4_DESC
L.faction = FACTION
L.fishing = PROFESSIONS_FISHING
L.fishingNotLearned = SPELL_FAILED_NOT_KNOWN -- "Spell not learned"
L.general = GENERAL
L.item = HELPFRAME_ITEM_TITLE
L.learned = TRADE_SKILLS_LEARNED_TAB
L.level = GUILD_RECRUITMENT_LEVEL
L.minimizeWindow = MINIMIZE
L.minimum = MINIMUM
L.name = NAME
L.object = SPELL_TARGET_TYPE7_DESC:gsub("^%l", string.upper) -- Capitalized "object"
L.price = AUCTION_PRICE
L.quality = QUALITY
L.quest = TRANSMOG_SOURCE_2
L.questCompleted = QUEST_COMPLETE
L.races = ITEM_RACES_ALLOWED
L.rare = ITEM_QUALITY3_DESC
L.rareElite = L.rare.." "..L.elite
L.recipes = TRADESKILL_SERVICE_LEARN
L.resetDefaults = RESET_TO_DEFAULT
L.show = SHOW
L.skill = SKILL
L.sortBy = select(1, strsplit(" ", RAID_FRAME_SORT_LABEL))..HEADER_COLON -- The first word of "Sort By" + ":"
L.sources = SOURCES
L.spell = STAT_CATEGORY_SPELL
L.subtitle = string.format(PETITION_CREATOR, rm.author).."\n"..GAME_VERSION_LABEL.." "..rm.version -- "Created by Breno Ludgero \n Version x.x.x"
L.uiScale = UI_SCALE
L.uncommon = ITEM_QUALITY2_DESC
L.unique = ITEM_UNIQUE
L.unlearned = TRADE_SKILLS_UNLEARNED_TAB..HEADER_COLON
L.unlimited = UNLIMITED
L.unknown = UNKNOWN
L.vendor = TRANSMOG_SOURCE_3
L.zone = ZONE

L.uniqueSourceInstructions = {
    [0] = {
        ["deDE"] = "Dieses Rezept ist eine Kreation von Ingenieuren",
        ["enUS"] = "This recipe is crafted by Engineers",
        ["esES"] = "Esta receta es creada por Ingenieros",
        ["esMX"] = "Esta receta es creada por Ingenieros",
        ["frFR"] = "Cette recette est élaborée par des Ingénieurs",
        ["koKR"] = "이 레시피는 엔지니어가 만든 것입니다",
        ["ptBR"] = "Esta receita é criada por Engenheiros",
        ["ruRU"] = "Этот рецепт разработан инженерами",
        ["zhCN"] = "这个配方是工程师的杰作",
        ["znTW"] = "這個配方是工程師的傑作"
    },
    [1] = {
        ["deDE"] = "Dieses Rezept wird von Eliten in Feuerlande fallen gelassen",
        ["enUS"] = "This recipe is dropped by Elites in Firelands",
        ["esES"] = "Esta receta es botída de Élites en Tierras de Fuego",
        ["esMX"] = "Esta receta es botída de Élites en Tierras de Fuego",
        ["frFR"] = "Cette recette est tombée par les Elites dans Terres de Feu",
        ["koKR"] = "이 레시피는 불의 땅의 정예가 드롭합니다",
        ["ptBR"] = "Esta receita é saqueada de Elites em Terras do Fogo",
        ["ruRU"] = "Этот рецепт выпадает из элиты в Огненные Просторы",
        ["zhCN"] = "此配方由火焰之地的精英掉落",
        ["zhTW"] = "此配方由火焰之地的精英掉落"
    },
    [2] = {
        ["deDE"] = "Dieses Rezept wird von Eliten in Drachenseele fallen gelassen",
        ["enUS"] = "This recipe is dropped by Elites in Dragon Soul",
        ["esES"] = "Esta receta es botída de Élites en Alma de Dragón",
        ["esMX"] = "Esta receta es botída de Élites en Alma de Dragón",
        ["frFR"] = "Cette recette est tombée par les Elites dans l’Âme des Dragons",
        ["koKR"] = "이 레시피는 용의 영혼의 엘리트가 드랍합니다",
        ["ptBR"] = "Esta receita é saqueada de Elites em Alma Dragônica",
        ["ruRU"] = "Этот рецепт выпадает из элиты в Душа Дракона",
        ["zhCN"] = "此配方由巨龙之魂的精英掉落",
        ["zhTW"] = "此配方由巨龍之魂的精英掉落"
    },
    [8696] = {
        ["deDE"] = "Er ist in einem Käfig im [Murder Pens] eingesperrt",
        ["enUS"] = "He is locked in a cage located inside Murder Pens",
        ["esES"] = "Está encerrado en una jaula situada dentro de [Murder Pens]",
        ["esMX"] = "Está encerrado en una jaula situada dentro de [Murder Pens]",
        ["frFR"] = "Il est enfermé dans une cage située à [Murder Pens]",
        ["koKR"] = "그는 [Murder Pens] 안에 위치한 철창에 갇혀 있습니다",
        ["ptBR"] = "Ele está preso numa jaula encontrada em [Murder Pens]",
        ["ruRU"] = "Он заперт в клетке, расположенной внутри [Murder Pens]",
        ["zhCN"] = "他被关在位于 [Muder Pens] 内的笼子里",
        ["zhTW"] = "他被關在 [Muder Pens] 內的籠子裡"
        -- Tomon, Wowhead.com
    },
    [8983] = {
        ["deDE"] = "Das Rezept ist eine Schriftrolle auf dem Boden,\n"..
                "die sich im selben Raum wie dieser Gegner befindet",
        ["enUS"] = "The recipe is a scroll on the ground,\n"..
                "found in the same room as this enemy",
        ["esES"] = "La receta es un pergamino en el suelo,\n"..
                "que se encuentra en la misma sala que este enemigo",
        ["esMX"] = "La receta es un pergamino en el suelo,\n"..
                "que se encuentra en la misma sala que este enemigo",
        ["frFR"] = "La recette est un parchemin sur le sol,\n"..
                "trouvé dans la même pièce que cet ennemi",
        ["koKR"] = "레시피는 이 적과 같은 방에서 발견되는 바닥에 있는 두루마리입니다",
        ["ptBR"] = "A receita está em um pergaminho no chão,\n"..
                "encontrado na mesma sala que este inimigo",
        ["ruRU"] = "Рецепт находится в свитке на земле,\n"..
                "найденном в той же комнате, что и этот враг",
        ["zhCN"] = "配方就在地上的卷轴上，在与这个敌人相同的房间里可以找到",
        ["zhTW"] = "配方就在地上的捲軸上，在與這個敵人相同的房間里可以找到"
        -- Palumtra, Wowhead.com
    },
    [9037] = {
        ["deDE"] = "Sprich mit ihm und er wird den folgenden Tribut verlangen:\n"..
                "2 Sternrubin\n"..
                "10 Echtsilberbarren\n"..
                "20 Goldbarren\n"..
                "Leg den Tribut in den Kelch und sprich erneut mit ihm",
        ["enUS"] = "Talk to him and he'll ask for the following tribute:\n"..
                "2 Star Ruby\n"..
                "10 Truesilver Bar\n"..
                "20 Gold Bar\n"..
                "Place the tribute in the chalice and talk to him again",
        ["esES"] = "Habla con él y te pedirá el siguiente tributo:\n"..
                "2 Rubí estrella\n"..
                "10 Lingote de veraplata\n"..
                "20 Lingote de oro\n"..
                "Pon el tributo en el cáliz y vuelve a hablar con él",
        ["esMX"] = "Habla con él y te pedirá el siguiente tributo:\n"..
                "2 Rubí estrella\n"..
                "10 Lingote de veraplata\n"..
                "20 Lingote de oro\n"..
                "Pon el tributo en el cáliz y vuelve a hablar con él",
        ["frFR"] = "Parlez-lui et il vous demandera le tribut suivant:\n"..
                "2 Rubis étoilé\n"..
                "10 Barre de vrai-argent\n"..
                "20 Barre d'or\n"..
                "Mettez le tribut dans le calice et parlez-lui à nouveau",
        ["koKR"] = "그에게 말을 걸면 다음과 같은 공물을 요구할 것입니다:\n"..
                "2 별루비\n"..
                "10 진은 주괴\n"..
                "20 금괴\n"..
                "공물을 성배에 넣고 다시 그에게 말하세요",
        ["ptBR"] = "Fale com ele e ele lhe pedirá o seguinte tributo:\n"..
                "2 Rubi-estrela\n"..
                "10 Barra de Veraprata\n"..
                "20 Barra de Ouro\n"..
                "Coloque o tributo no cálice e fale com ele novamente",
        ["ruRU"] = "Поговорите с ним, и он попросит следующую дань:\n"..
                "2 Звездный рубин\n"..
                "10 Слиток истинного серебра\n"..
                "20 Золотой слиток\n"..
                "Положите дань в чашу и поговорите с ним снова",
        ["zhCN"] = "跟他谈谈，他会要以下贡品：\n"..
                "2 红宝石\n"..
                "10 真银锭\n"..
                "20 金锭\n"..
                "把贡品放进圣杯，再和他谈谈",
        ["zhTW"] = "跟他談談，他會要以下貢品：\n"..
                "2 紅寶石\n"..
                "10 真銀錠\n"..
                "20 金錠\n"..
                "把貢品放進聖杯，再和他談談"
        -- 4238, Wowhead.com
    },
    [10503] = {
        ["deDE"] = "Sie wird ein Buch mit dem Rezept fallen lassen,\n"..
                "nachdem sie besiegt wurde",
        ["enUS"] = "She'll drop a book containing the recipe\n"..
                "after being defeated",
        ["esES"] = "Dejará caer un libro que contiene la receta\n"..
                "después de ser derrotada",
        ["esMX"] = "Dejará caer un libro que contiene la receta\n"..
                "después de ser derrotada",
        ["frFR"] = "Elle laissera tomber un livre contenant la recette\n"..
                "après avoir été vaincue",
        ["koKR"] = "패배 후 레시피가 담긴 책을 떨어뜨린다",
        ["ptBR"] = "Ela deixará cair um livro contendo a receita\n"..
                "depois de ser derrotada",
        ["ruRU"] = "После поражения она уронит книгу с рецептом",
        ["zhCN"] = "她被打败后会掉落一本记载秘方的书",
        ["zhTW"] = "她被打敗後會掉落一本記載秘方的書"
        -- J0057Mith, Wowhead.com
    },
    [14401] = {
        ["deDE"] = "Er kann von einem priester kontrolliert werden, der\n"..
                "dann das Rezept an Spieler in der Nähe weitergeben kann",
        ["enUS"] = "He can be mindcontrolled by a priest,\n"..
                "who can then teach the recipe to nearby players",
        ["esES"] = "Puede ser controlado mentalmente por un sacerdote,\n"..
                "que luego puede enseñar la receta a los jugadores cercanos",
        ["esMX"] = "Puede ser controlado mentalmente por un sacerdote,\n"..
                "que luego puede enseñar la receta a los jugadores cercanos",
        ["frFR"] = "Il peut être contrôlé par un prêtre,\n"..
                "qui peut alors enseigner la recette aux joueurs voisins",
        ["koKR"] = "사제가 마인드컨트롤할 수 있으며,\n"..
                "사제는 주변 플레이어에게 레시피를 가르칠 수 있습니다",
        ["ptBR"] = "Ele pode ter a mente controlada por um sacerdote,\n"..
                "que pode então ensinar a receita aos jogadores próximos",
        ["ruRU"] = "Его сознанием может управлять жрец,\n"..
                "который затем может научить рецепту ближайших игроков",
        ["zhCN"] = "他可以被牧师控制心智，\n"..
                "然后牧师可以将配方传授给附近的玩家",
        ["zhTW"] = "他可以被牧師控制心智，\n"..
                "然後牧師可以將配方傳授給附近的玩家"
        -- Eihrister, Wowhead.com
    },
    [32516] = {
        ["deDE"] = "Nachdem du die Quest 'Der Geschmackstest'\n"..
                "abgeschlossen hast, sprich mit diesem NPC in\n"..
                "Daralans Abwasserkanälen, um das Rezept zu erfahren",
        ["enUS"] = "After completing the quest 'The Taste Test',\n"..
                "talk with this NPC in Daralan's sewers to learn the recipe",
        ["esES"] = "Tras completar la misión 'La prueba de la cata', habla\n"..
                "con este PNJ en las alcantarillas de Daralan\n"..
                "para aprender la receta",
        ["esMX"] = "Tras completar la misión 'La prueba de la cata', habla\n"..
                "con este PNJ en las alcantarillas de Daralan\n"..
                "para aprender la receta",
        ["frFR"] = "Après avoir terminé la quête 'Le test de dégustation',\n"..
                "parlez à ce PNJ dans les égouts de Daralan\n"..
                "pour apprendre la recette",
        ["koKR"] = "'시음회' 퀘스트를 완료한 후,\n"..
                "다랄란의 하수구에 있는 이 NPC와 대화하여 레시피를 배우세요",
        ["ptBR"] = "Após completar a missão 'A prova dos três',\n"..
                "fale com este NPC nos esgotos de Daralan\n"..
                "para aprender a receita",
        ["ruRU"] = "Выполнив квест 'Дегустация', поговорите с этим NPC\n"..
                "в канализации Даралана, чтобы узнать рецепт",
        ["zhCN"] = "完成 '品酒'任务后，\n"..
                "在达拉然的下水道中与这名 NPC 交谈，学习配方",
        ["zhTW"] = "完成 '品酒'任務後，\n"..
                "在達拉然的下水道中與這名 NPC 交談，學習配方"
        -- 734296, Wowhead.com
    },
    [53214] = {
        ["deDE"] = "Dieser Händler wird freigeschaltet, nachdem ihr die Quest\n"..
                "[Additional Armaments] in der Zone Geschmolzene Front\n"..
                "abgeschlossen habt. Das Rezept wird für 240 Gold verkauft",
        ["enUS"] = "This vendor is unlocked after completing the quest\n"..
                "'Additional Armaments' in the Molten Front zone.\n"..
                "The recipe is sold for 240 gold",
        ["esES"] = "Este vendedor se desbloquea tras completar la misión\n"..
                "[Additional Armaments] en la zona Frente de Magma.\n"..
                "La receta se vende por 240 de oro",
        ["esMX"] = "Este vendedor se desbloquea tras completar la misión\n"..
                "[Additional Armaments] en la zona Frente de Magma.\n"..
                "La receta se vende por 240 de oro",
        ["frFR"] = "Ce vendeur est débloqué après avoir terminé la quête\n"..
                "[Additional Armaments] dans la zone Front du Magma.\n"..
                "La recette est vendue pour 240 pièces d'or",
        ["koKR"] = "이 상인은 녹아내린 전초지 지역에서 [Additional Armaments]\n"..
                "퀘스트를 완료하면 잠금 해제됩니다. 레시피는 240골드에 판매됩니다",
        ["ptBR"] = "Este vendedor é desbloqueado após completar a missão\n"..
                "[Additional Armaments] na zona Front Ígneo.\n"..
                "A receita é vendida por 240 ouro",
        ["ruRU"] = "Этот торговец открывается после выполнения квеста\n"..
                "[Additional Armaments] в зоне Огненная передовая.\n"..
                "Рецепт продается за 240 золотых",
        ["zhCN"] = "在熔火前线區域完成任務[Additional Armaments]後，可以解鎖此販賣商。\n"..
                "配方的售價為 240 金幣",
        ["zhTW"] = "在熔火前线区域完成任务[Additional Armaments]后，可以解锁此贩卖商。\n"..
                "配方的售价为 240 金币"
        -- Ease, Wowhead.com
    },
    [53881] = {
        ["deDE"] = "Dieser Händler wird freigeschaltet, nachdem ihr die Quest\n"..
                "[Filling the Moonwell] in der Zone Geschmolzene Front\n"..
                "abgeschlossen habt. Das Rezept wird für 240 Gold verkauft",
        ["enUS"] = "This vendor is unlocked after completing the quest\n"..
                "'Filling the Moonwell' in the Molten Front zone.\n"..
                "The recipe is sold for 240 gold",
        ["esES"] = "Este vendedor se desbloquea tras completar la misión\n"..
                "[Filling the Moonwell] en la zona Frente de Magma.\n"..
                "La receta se vende por 240 de oro",
        ["esMX"] = "Este vendedor se desbloquea tras completar la misión\n"..
                "[Filling the Moonwell] en la zona Frente de Magma.\n"..
                "La receta se vende por 240 de oro",
        ["frFR"] = "Ce vendeur est débloqué après avoir terminé la quête\n"..
                "[Filling the Moonwell] dans la zone Front du Magma.\n"..
                "La recette est vendue pour 240 pièces d'or",
        ["koKR"] = "이 상인은 녹아내린 전초지 지역에서 [Filling the Moonwell]\n"..
                "퀘스트를 완료하면 잠금 해제됩니다. 레시피는 240골드에 판매됩니다",
        ["ptBR"] = "Este vendedor é desbloqueado após completar a missão\n"..
                "[Filling the Moonwell] na zona Front Ígneo.\n"..
                "A receita é vendida por 240 ouro",
        ["ruRU"] = "Этот торговец открывается после выполнения квеста\n"..
                "[Filling the Moonwell] в зоне Огненная передовая.\n"..
                "Рецепт продается за 240 золотых",
        ["zhCN"] = "在熔火前线區域完成任務[Filling the Moonwell]後，可以解鎖此販賣商。\n"..
                "配方的售價為 240 金幣",
        ["zhTW"] = "在熔火前线区域完成任务[Filling the Moonwell]后，可以解锁此贩卖商。\n"..
                "配方的售价为 240 金币"
        -- Ease, Wowhead.com
    }
}

if rm.locale == "enUS" then
    L.professions = {
        [171] = "Alchemy",
        [164] = "Blacksmithing",
        [185] = "Cooking",
        [333] = "Enchanting",
        [202] = "Engineering",
        [129] = "First Aid",
        [356] = "Fishing",
        [773] = "Inscription",
        [755] = "Jewelcrafting",
        [165] = "Leatherworking",
        [186] = "Mining",
        [197] = "Tailoring"
    }
    L.recipePrefixes = {"Recipe: ", "Plans: ", "Formula: ", "Schematic: ", "Pattern: ", "Manual: ", "Design: ", "Technique: "}
    L.backgroundOpacity = "Background Opacity"
    L.canLearn = "Learnable"
    L.blue = "Blue"
    L.bright = "Bright"
    L.dark = "Dark"
    L.difficult = "Difficult"
    L.difficulty = "Difficulty"
    L.easy = "Easy"
    L.fair = "Fair"
    L.gray = "Gray"
    L.green = "Green"
    L.orange = "Orange"
    L.progressBar = "Progress Bar"
    L.purple = "Purple"
    L.recipeIconSpacing = "Icon Spacing"
    L.recipesWindow = "Recipes Window"
    L.recipeTooltip = "Recipe Tooltip"
    L.showAltsTooltipInfo = "Show Characters' Status"
    L.showDifficultyTooltipInfo = "Show Difficulty Levels"
    L.showLearnedRecipes = "Show Learned Recipes"
    L.showRecipesInfo = "Show Recipe Details"
    L.showSourcesTooltipInfo = "Show Sources"
    L.stock = "Stock"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Restore Window Icon"
    L.pickpocket = "Pickpocket"
    L.trainer = "Trainer"
    return

elseif rm.locale == "esMX" or rm.locale == "esES" then
    L.professions = {
        [171] = "Alquimia",
        [164] = "Herrería",
        [185] = "Cocina",
        [333] = "Encantamiento",
        [202] = "Ingeniería",
        [129] = "Primeros auxilios",
        [356] = "Pesca",
        [773] = "Inscripción",
        [755] = "Joyería",
        [165] = "Peletería",
        [186] = "Minería",
        [197] = "Sastrería"
    }
    L.recipePrefixes = {"Receta: ", "Diseño: ", "Fórmula: ", "Esquema: ", "Patrón: ", "Manual: ", "Boceto: ", "Técnica: "}
    L.backgroundOpacity = "Opacidad del Fondo"
    L.blue = "Azul"
    L.bright = "Brillante"
    L.canLearn = "Puede Aprender"
    L.chance = "Prob."
    L.dark = "Oscura"
    L.difficult = "Difícil"
    L.difficulty = "Dificultad"
    L.easy = "Fácil"
    L.fair = "Justo"
    L.gray = "Gris"
    L.green = "Verde"
    L.item = "Ítem"
    L.orange = "Naranja"
    L.progressBar = "Barra de Progreso"
    L.purple = "Morado"
    L.recipeIconSpacing = "Espaciado de Iconos"
    L.recipesWindow = "Ventana de Recetas"
    L.recipeTooltip = "Descripción de la Receta"
    L.showAltsTooltipInfo = "Mostrar el Estado de Personajes"
    L.showDifficultyTooltipInfo = "Mostrar Niveles de Dificultad"
    L.showLearnedRecipes = "Mostrar Recetas Aprendidas"
    L.showRecipesInfo = "Mostrar Detalles de la Receta"
    L.showSourcesTooltipInfo = "Mostrar Fuentes"
    L.stock = "Reserva"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Icono de Restauración de la Ventana"
    L.pickpocket = "Robo"
    L.trainer = "Instructor"
    return

elseif rm.locale == "ptBR" then
    L.professions = {
        [171] = "Alquimia",
        [164] = "Ferraria",
        [185] = "Culinária",
        [333] = "Encantamento",
        [202] = "Engenharia",
        [129] = "Primeiros Socorros",
        [356] = "Pesca",
        [773] = "Escrivania",
        [755] = "Joalheria",
        [165] = "Couraria",
        [186] = "Mineração",
        [197] = "Alfaiataria"
    }
    L.recipePrefixes = {"Receita: ", "Instruções: ", "Fórmula: ", "Diagrama: ", "Molde: ", "Manual: ", "Desenho: ", "Técnica: "}
    L.backgroundOpacity = "Opacidade do Fundo"
    L.blue = "Azul"
    L.bright = "Clara"
    L.canLearn = "Pode Aprender"
    L.dark = "Escura"
    L.difficult = "Difícil"
    L.difficulty = "Dificuldade"
    L.easy = "Fácil"
    L.fair = "Justo"
    L.gray = "Cinza"
    L.green = "Verde"
    L.orange = "Laranja"
    L.progressBar = "Barra de Progresso"
    L.purple = "Roxo"
    L.recipeIconSpacing = "Espaçamento do Ícone"
    L.recipesWindow = "Janela de Receitas"
    L.recipeTooltip = "Dica da Receita"
    L.showAltsTooltipInfo = "Mostrar o Estado dos Personagens"
    L.showDifficultyTooltipInfo = "Mostrar Níveis de Dificuldade"
    L.showLearnedRecipes = "Mostrar Receitas Aprendidas"
    L.showRecipesInfo = "Mostrar Detalhes da Receita"
    L.showSourcesTooltipInfo = "Mostrar Fontes"
    L.stock = "Estoque"
    L.sortBy = "Ordenar:"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Ícone do Botão de Restaurar Janela"
    L.pickpocket = "Bater carteira"
    L.trainer = "Instrutor"
    return

elseif rm.locale == "deDE" then
    L.professions = {
        [171] = "Alchemie",
        [164] = "Schmiedekunst",
        [185] = "Kochkunst",
        [333] = "Verzauberkunst",
        [202] = "Ingenieurskunst",
        [129] = "Erste Hilfe",
        [356] = "Angeln",
        [773] = "Inschriftenkunde",
        [755] = "Juwelenschleifen",
        [165] = "Lederverarbeitung",
        [186] = "Bergbau",
        [197] = "Schneiderei"
    }
    L.recipePrefixes = {"Rezept: ", "Pläne: ", "Formel: ", "Bauplan: ", "Muster: ", "Handbuch: ", "Vorlage: ", "Technik: "}
    L.backgroundOpacity = "Hintergrundopazität"
    L.blue = "Blau"
    L.bright = "Hell"
    L.canLearn = "Kann Lernen"
    L.dark = "Dunkel"
    L.difficult = "Schwierig"
    L.difficulty = "Schwierigkeit"
    L.easy = "Einfach"
    L.fair = "Fair"
    L.gray = "Grau"
    L.green = "Grün"
    L.item = "Artikel"
    L.orange = "Orange"
    L.progressBar = "Fortschrittsbalken"
    L.purple = "Lila"
    L.recipeIconSpacing = "Symbolabstand"
    L.recipesWindow = "Rezepte Fenster"
    L.recipeTooltip = "Bulle de la Recette"
    L.showAltsTooltipInfo = "Status der Charaktere Anzeigen"
    L.showDifficultyTooltipInfo = "Schwierigkeitsgrade Anzeigen"
    L.showLearnedRecipes = "Gelernte Rezepte Anzeigen"
    L.showRecipesInfo = "Rezeptdetails Anzeigen"
    L.showSourcesTooltipInfo = "Quellen Anzeigen"
    L.stock = "Lager"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Symbol für Fenster Wiederherstellen"
    L.pickpocket = "Taschendieb"
    L.trainer = "Lehrer"
    return

elseif rm.locale == "frFR" then
    L.professions = {
        [171] = "Alchimie",
        [164] = "Forge",
        [185] = "Cuisine",
        [333] = "Enchantement",
        [202] = "Ingénierie",
        [129] = "Secourisme",
        [356] = "Pêche",
        [773] = "Calligraphie",
        [755] = "Joaillerie",
        [165] = "Travail du cuir",
        [186] = "Minage",
        [197] = "Couture"
    }
    L.recipePrefixes = {"Recette : ", "Plan : ", "Plans : ", "Formule : ", "Schéma : ", "Patron : ", "Manuel : ", "Dessin : ", "Technique : "}
    L.backgroundOpacity = "Opacité de l'Arrière-plan"
    L.blue = "Bleu"
    L.bright = "Clair"
    L.canLearn = "Peut Apprendre"
    L.chance = "Chance"
    L.dark = "Foncé"
    L.difficult = "Difficile"
    L.difficulty = "Difficulté"
    L.easy = "Facile"
    L.fair = "Juste"
    L.gray = "Gris"
    L.green = "Vert"
    L.object = "Chose"
    L.orange = "Orange"
    L.progressBar = "Barre de Progrès"
    L.purple = "Violet"
    L.recipeIconSpacing = "Espacement des Icônes"
    L.recipesWindow = "Fenêtre des Recettes"
    L.recipeTooltip = "Rezept-Tooltip"
    L.showAltsTooltipInfo = "Afficher l'État des Personnages"
    L.showDifficultyTooltipInfo = "Afficher les Niveaux de Difficulté"
    L.showLearnedRecipes = "Afficher les Recettes Apprises"
    L.showRecipesInfo = "Afficher les Détails de la Recette"
    L.showSourcesTooltipInfo = "Afficher les Sources"
    L.stock = "Réserve"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Icône de Restauration de la Fenêtre"
    L.pickpocket = "Vol à la tire"
    L.trainer = "Maître"
    return

elseif rm.locale == "ruRU" then
    L.professions = {
        [171] = "Алхимия",
        [164] = "Кузнечное дело",
        [185] = "Кулинария",
        [333] = "Наложение чар",
        [202] = "Инженерное дело",
        [129] = "Первая помощь",
        [356] = "Рыбная ловля",
        [773] = "Начертание",
        [755] = "Ювелирное дело",
        [165] = "Кожевничество",
        [186] = "Горное дело",
        [197] = "Портняжное дело"
    }
    L.recipePrefixes = {"Рецепт: ", "Чертеж: ", "Формула ", "Формула: ", "Схема: ", "Выкройка: ", "Учебник: ", "Эскиз: ", "Техника: "}
    L.backgroundOpacity = "Прозрачность фона"
    L.blue = "Синий"
    L.bright = "Яркий"
    L.canLearn = "Может Учиться"
    L.chance = "Шанс"
    L.dark = "Тёмный"
    L.difficult = "Трудный"
    L.difficulty = "Трудность"
    L.easy = "Легко"
    L.fair = "Ярмарка"
    L.fishing = "Рыбалка"
    L.gray = "Серый"
    L.green = "Зелёный"
    L.orange = "Оранжевый"
    L.progressBar = "Полоса Прогресса"
    L.purple = "Фиолетовый"
    L.recipeIconSpacing = "Промежуток Между Иконками"
    L.recipesWindow = "Окно Рецептов"
    L.recipeTooltip = "Подсказка к Рецепту"
    L.showAltsTooltipInfo = "Показать Состояние Персонажей"
    L.showDifficultyTooltipInfo = "Показать Уровни Сложности"
    L.showLearnedRecipes = "Показывать Выученные Рецепты"
    L.showRecipesInfo = "Показать Подробности Рецепта"
    L.showSourcesTooltipInfo = "Показать Источники"
    L.sortBy = "Сорт:"
    L.stock = "Склад"
    L.trivial = "Тривиальный"
    L.updateIconDropdown = "Значок окна Восстановления"
    L.pickpocket = "Карманник"
    L.trainer = "Учитель"
    return

elseif rm.locale == "koKR" then
    L.professions = {
        [171] = "연금술",
        [164] = "대장기술",
        [185] = "요리",
        [333] = "마법부여",
        [202] = "기계공학",
        [129] = "응급치료",
        [356] = "낚시",
        [773] = "주문각인",
        [755] = "보석세공",
        [165] = "가죽 세공",
        [186] = "채광",
        [197] = "재봉술"
    }
    L.recipePrefixes = {"조리법: ", "도면: ", "주문식: ", "설계도: ", "도안: ", "처방전: ", "디자인: ", "기법: "}
    L.backgroundOpacity = "배경 불투명도"
    L.blue = "파랑"
    L.bright = "밝은"
    L.canLearn = "학습 가능"
    L.dark = "어두운"
    L.difficult = "어려운"
    L.difficulty = "어려움"
    L.easy = "쉬운"
    L.fair = "온당한"
    L.gray = "회색"
    L.green = "초록"
    L.orange = "주황"
    L.progressBar = "진행 막대"
    L.purple = "보라"
    L.recipeIconSpacing = "아이콘 간격"
    L.recipesWindow = "레시피 창"
    L.recipeTooltip = "레시피 툴팁"
    L.showAltsTooltipInfo = "캐릭터 상태 표시"
    L.showDifficultyTooltipInfo = "난이도 표시하기"
    L.showLearnedRecipes = "배웠던 레시피 보기"
    L.showRecipesInfo = "레시피 세부 정보 표시"
    L.showSourcesTooltipInfo = "소스 표시"
    L.stock = "재고"
    L.trivial = "사소한"
    L.updateIconDropdown = "복원 창 아이콘"
    L.pickpocket = "훔치기"
    L.trainer = "트레이너"
    return

elseif rm.locale == "zhTW" then
    L.professions = {
        [171] = "鍊金術",
        [164] = "鍛造",
        [185] = "烹飪",
        [333] = "附魔",
        [202] = "工程學",
        [129] = "急救",
        [356] = "釣魚",
        [773] = "銘文學",
        [755] = "珠寶設計",
        [165] = "製皮",
        [186] = "採礦",
        [197] = "裁縫"
    }
    L.recipePrefixes = {"食譜：", "設計圖：", "公式：", "結構圖：", "結構圖 : ", "圖樣：", "圖樣 : ", "說明書：", "手冊：", "配方：", "技藝:", "設計圖:"}
    L.backgroundOpacity = "背景不透明度"
    L.blue = "藍色"
    L.bright = "明亮"
    L.canLearn = "可以學習"
    L.dark = "暗色"
    L.difficult = "難"
    L.difficulty = "困難"
    L.easy = "簡單"
    L.fair = "合理的"
    L.gray = "灰色"
    L.green = "綠色"
    L.orange = "橙色"
    L.progressBar = "進度條"
    L.purple = "紫色"
    L.recipeIconSpacing = "圖示間距"
    L.recipesWindow = "食譜視窗"
    L.recipeTooltip = "食譜工具提示"
    L.showAltsTooltipInfo = "顯示角色狀態"
    L.showDifficultyTooltipInfo = "顯示難度等級"
    L.showLearnedRecipes = "顯示已學會的食譜"
    L.showRecipesInfo = "顯示食譜詳細信息"
    L.showSourcesTooltipInfo = "顯示來源"
    L.sortBy = "分類："
    L.stock = "存貨"
    L.trivial = "瑣碎"
    L.updateIconDropdown = "恢復視窗圖示"
    L.pickpocket = "搜索"
    L.trainer = "訓練師"
    return

elseif rm.locale == "zhCN" then
    L.professions = {
        [171] = "炼金术",
        [164] = "锻造",
        [185] = "烹饪",
        [333] = "附魔",
        [202] = "工程学",
        [129] = "急救",
        [356] = "钓鱼",
        [773] = "铭文",
        [755] = "珠宝加工",
        [165] = "制皮",
        [186] = "采矿",
        [197] = "裁缝"
    }
    L.recipePrefixes = {"食谱：", "配方：", "设计图：", "公式：", "结构图：", "图样：", "手册：", "图鉴：", "工艺图："}
    L.backgroundOpacity = "背景不透明度"
    L.blue = "蓝色"
    L.bright = "明亮"
    L.canLearn = "可以学习"
    L.dark = "深色"
    L.difficult = "難"
    L.difficulty = "困难"
    L.easy = "简单"
    L.fair = "合理的"
    L.gray = "灰色"
    L.green = "绿色"
    L.orange = "橙色"
    L.progressBar = "进度条"
    L.purple = "紫色"
    L.recipeIconSpacing = "图标间距"
    L.recipesWindow = "食谱窗口"
    L.recipeTooltip = "食谱工具提示"
    L.showAltsTooltipInfo = "显示角色状态"
    L.showDifficultyTooltipInfo = "显示难度级别"
    L.showLearnedRecipes = "显示已学会的食谱"
    L.showRecipesInfo = "显示食谱详细信息"
    L.showSourcesTooltipInfo = "显示来源"
    L.stock = "存货"
    L.trivial = "琐碎"
    L.updateIconDropdown = "恢复窗口图标"
    L.pickpocket = "搜索"
    L.trainer = "训练师"
end
