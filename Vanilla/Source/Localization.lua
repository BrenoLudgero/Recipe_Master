local _, rm = ...
local L = rm.L

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
L.epic = ITEM_QUALITY4_DESC
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
        ["enUS"] = '"How to Craft Phase 3 Epic Items"\n'..
                'www.wowhead.com/classic',
    },
    [2] = {
        ["enUS"] = '"How to Get Void-Touched Armaments"\n'..
                'www.wowhead.com/classic',
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
    [11340] = {
        ["deDE"] = "Das Rezept wird von einer großen Steintafel gelehrt,\n"..
                "die in der Wand hinter dem Kohlenbecken und in der\n"..
                "Nähe dieses Gegners am [Edge of Madness] gefunden wurde",
        ["enUS"] = "The recipe is taught from a large stone tablet\n"..
                "found in the wall behind the brazier and\n"..
                "near this enemy in the Edge of Madness",
        ["esES"] = "La receta es enseñada por una gran tablilla de piedra\n"..
                "que se encuentra en la pared detrás del brasero y\n"..
                "cerca de este enemigo en el [Edge of Madness]",
        ["esMX"] = "La receta es enseñada por una gran tablilla de piedra\n"..
                "que se encuentra en la pared detrás del brasero y\n"..
                "cerca de este enemigo en el [Edge of Madness]",
        ["frFR"] = "La recette est enseignée sur une grande tablette\n"..
                "de pierre trouvée dans le mur derrière le brasero\n"..
                "et près de cet ennemi dans l'[Edge of Madness]",
        ["koKR"] = "레시피는 [Edge of Madness]에서 화로 뒤쪽 벽과 이 적\n"..
                "근처에서 발견되는 커다란 석판에서 배울 수 있습니다",
        ["ptBR"] = "A receita é ensinada por uma grande tábua de pedra\n"..
                "encontrada na parede atrás do braseiro e\n"..
                "perto deste inimigo na [Edge of Madness]",
        ["ruRU"] = "Рецепт можно узнать из большой каменной таблички,\n"..
                "найденной в стене за мангалом и рядом с\n"..
                "этим врагом в [Edge of Madness]",
        ["zhCN"] = "配方是从一块大石碑上传授的，这块石碑位于\n"..
                "[Edge of Madness] 中火炉后面的墙壁上和这个敌人附近",
        ["zhTW"] = "配方是從一塊大石碑上傳授的，這塊石碑位於\n"..
                "[Edge of Madness] 中火爐後面的牆壁上和這個敵人附近"
        -- Ashiran, Wowhead.com
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
    [16365] = {
        ["deDE"] = "Er ist in einem Käfig im Militärviertel eingesperrt",
        ["enUS"] = "He is locked in a cage located inside The Millitary Quarter",
        ["esES"] = "Está encerrado en una jaula ubicada en el Arrabal Militar",
        ["esMX"] = "Está encerrado en una jaula ubicada en el Arrabal Militar",
        ["frFR"] = "Il est enfermé dans une cage située dans le Quartier Militaire",
        ["koKR"] = "그는 밀리터리 쿼터 안에 위치한 철창에 갇혀 있습니다",
        ["ptBR"] = "Ele está preso em uma jaula localizada no Bairro Militar",
        ["ruRU"] = "Он заперт в клетке, расположенной в Военный Квартал",
        ["zhCN"] = "他被关在军事区的笼子里",
        ["zhTW"] = "他被關在軍事區的籠子裡"
        -- Tomon, Wowhead.com
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
        [165] = "Leatherworking",
        [186] = "Mining",
        [197] = "Tailoring"
    }
    L.recipePrefixes = {"Recipe: ", "Plans: ", "Formula: ", "Schematic: ", "Pattern: ", "Manual: "}
    L.backgroundOpacity = "Background Opacity"
    L.blue = "Blue"
    L.bright = "Bright"
    L.canLearn = "Learnable"
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
    L.showAltsTooltipInfo = "Show characters' status"
    L.showDifficultyTooltipInfo = "Show difficulty levels"
    L.showLearnedRecipes = "Show Learned Recipes"
    L.showRecipesInfo = "Show Recipe Details"
    L.showSourcesTooltipInfo = "Show sources"
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
        [165] = "Peletería",
        [186] = "Minería",
        [197] = "Sastrería"
    }
    if rm.locale == "esES" then
        L.professions[197] = "Costura"
    end
    L.recipePrefixes = {"Receta: ", "Diseño: ", "Fórmula: ", "Esquema: ", "Patrón: ", "Manual: "}
    L.backgroundOpacity = "Opacidad del fondo"
    L.blue = "Azul"
    L.bright = "Brillante"
    L.canLearn = "Puede aprender"
    L.chance = "Probabilidad"
    L.dark = "Oscuro"
    L.difficult = "Difícil"
    L.difficulty = "Dificultad"
    L.easy = "Fácil"
    L.fair = "Justo"
    L.gray = "Gris"
    L.green = "Verde"
    L.item = "Objeto"
    L.orange = "Naranja"
    L.progressBar = "Barra de progreso"
    L.purple = "Morado"
    L.recipeIconSpacing = "Espaciado de iconos"
    L.recipesWindow = "Ventana de recetas"
    L.recipeTooltip = "Descripción de la receta"
    L.showAltsTooltipInfo = "Mostrar el estado de personajes"
    L.showDifficultyTooltipInfo = "Mostrar niveles de dificultad"
    L.showLearnedRecipes = "Mostrar recetas aprendidas"
    L.showRecipesInfo = "Mostrar detalles de la receta"
    L.showSourcesTooltipInfo = "Mostrar fuentes"
    L.stock = "Reserva"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Ícono de restauración de la ventana"
    L.pickpocket = "Robar"
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
        [165] = "Couraria",
        [186] = "Mineração",
        [197] = "Alfaiataria"
    }
    L.recipePrefixes = {"Receita: ", "Instruções: ", "Fórmula: ", "Diagrama: ", "Molde: ", "Manual: "}
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
    L.showAltsTooltipInfo = "Mostrar o estado dos personagens"
    L.showDifficultyTooltipInfo = "Mostrar níveis de dificuldade"
    L.showLearnedRecipes = "Mostrar Receitas Aprendidas"
    L.showRecipesInfo = "Mostrar Detalhes da Receita"
    L.showSourcesTooltipInfo = "Mostrar fontes"
    L.stock = "Estoque"
    L.sortBy = "Ordenar:"
    L.trivial = "Trivial"
    L.updateIconDropdown = "Ícone do Botão de Restaurar Janela"
    L.pickpocket = "Bater carteira"
    L.trainer = "Instrutor"
    return

elseif rm.locale == "deDE" then
    L.professions = {
        [171] = "Alchimie",
        [164] = "Schmiedekunst",
        [185] = "Kochkunst",
        [333] = "Verzauberkunst",
        [202] = "Ingenieurskunst",
        [129] = "Erste Hilfe",
        [356] = "Angeln",
        [165] = "Lederverarbeitung",
        [186] = "Bergbau",
        [197] = "Schneiderei"
    }
    L.recipePrefixes = {"Rezept: ", "Pläne: ", "Formel: ", "Bauplan: ", "Muster: ", "Handbuch: "}
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
    L.recipeTooltip = "Rezept-Tooltip"
    L.showAltsTooltipInfo = "Status der Charaktere anzeigen"
    L.showDifficultyTooltipInfo = "Schwierigkeitsgrade anzeigen"
    L.showLearnedRecipes = "Gelernte Rezepte Anzeigen"
    L.showRecipesInfo = "Rezeptdetails Anzeigen"
    L.showSourcesTooltipInfo = "Quellen anzeigen"
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
        [165] = "Travail du cuir",
        [186] = "Minage",
        [197] = "Couture"
    }
    L.recipePrefixes = {"Recette : ", "Plan : ", "Plans : ", "Formule : ", "Schéma : ", "Patron : ", "Manuel : "}
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
    L.recipeTooltip = "Bulle de la Recette"
    L.showAltsTooltipInfo = "Afficher l'état des personnages"
    L.showDifficultyTooltipInfo = "Afficher les niveaux de difficulté"
    L.showLearnedRecipes = "Afficher les Recettes Apprises"
    L.showRecipesInfo = "Afficher les Détails de la Recette"
    L.showSourcesTooltipInfo = "Afficher les sources"
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
        [165] = "Кожевничество",
        [186] = "Горное дело",
        [197] = "Портняжное дело"
    }
    L.recipePrefixes = {"Рецепт: ", "Чертеж: ", "Формула ", "Формула: ", "Схема: ", "Выкройка: ", "Учебник: "}
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
    L.recipeIconSpacing = "Промежуток между иконками"
    L.recipesWindow = "Окно Рецептов"
    L.recipeTooltip = "Подсказка к Рецепту"
    L.showAltsTooltipInfo = "Показать состояние персонажей"
    L.showDifficultyTooltipInfo = "Показать уровни сложности"
    L.showLearnedRecipes = "Показывать выученные рецепты"
    L.showRecipesInfo = "Показать Подробности Рецепта"
    L.showSourcesTooltipInfo = "Показать источники"
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
        [165] = "가죽 세공",
        [186] = "채광",
        [197] = "재봉술"
    }
    L.recipePrefixes = {"조리법: ", "도면: ", "주문식: ", "설계도: ", "도안: ", "처방전: "}
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
        [165] = "製皮",
        [186] = "採礦",
        [197] = "裁縫"
    }
    L.recipePrefixes = {"食譜：", "設計圖：", "公式：", "結構圖：", "結構圖 : ", "圖樣：", "圖樣 : ", "說明書：", "手冊：", "配方："}
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
        [165] = "制皮",
        [186] = "采矿",
        [197] = "裁缝"
    }
    L.recipePrefixes = {"食谱：", "配方：", "设计图：", "公式：", "结构图：", "图样：", "手册："}
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
