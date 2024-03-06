local locale = GetLocale()

if locale == "enUS" then
    professionNames = {
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
    recipePrefixes = {"Recipe: ", "Plans: ", "Formula: ", "Schematic: ", "Pattern: ", "Manual: "}
    return

elseif locale == "esMX" then
    professionNames = {
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
    recipePrefixes = {"Receta: ", "Diseño: ", "Fórmula: ", "Esquema: ", "Patrón: ", "Manual: "}
    strings.backgroundOpacity = "Opacidad del Fondo"
    strings.blue = "Azul"
    strings.bright = "Brillante"
    strings.dark = "Oscuro"
    strings.gray = "Gris"
    strings.green = "Verde"
    strings.orange = "Naranja"
    strings.progressBar = "Barra de Progreso"
    strings.purple = "Morado"
    strings.recipeIconSpacing = "Espaciado de Iconos"
    strings.recipesWindow = "Ventana de Recetas"
    strings.updateIconDropdown = "Ícono del Botón del Maestro de Recetas"
    strings.showLearned = "Mostrar Recetas Aprendidas"
    return

elseif locale == "esES" then
    professionNames = {
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
        [197] = "Costura"
    }
    recipePrefixes = {"Receta: ", "Diseño: ", "Fórmula: ", "Esquema: ", "Patrón: ", "Manual: "}
    strings.backgroundOpacity = "Opacidad del Fondo"
    strings.blue = "Azul"
    strings.bright = "Brillante"
    strings.dark = "Oscuro"
    strings.gray = "Gris"
    strings.green = "Verde"
    strings.orange = "Naranja"
    strings.progressBar = "Barra de Progreso"
    strings.purple = "Morado"
    strings.recipeIconSpacing = "Espaciado de Iconos"
    strings.recipesWindow = "Ventana de Recetas"
    strings.updateIconDropdown = "Ícono del Botón del Maestro de Recetas"
    strings.showLearned = "Mostrar Recetas Aprendidas"
    return

elseif locale == "ptBR" then
    professionNames = {
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
    recipePrefixes = {"Receita: ", "Instruções: ", "Fórmula: ", "Diagrama: ", "Molde: ", "Manual: "}
    strings.backgroundOpacity = "Opacidade do Fundo"
    strings.blue = "Azul"
    strings.bright = "Claro"
    strings.dark = "Escuro"
    strings.gray = "Cinza"
    strings.green = "Verde"
    strings.orange = "Laranja"
    strings.progressBar = "Barra de Progresso"
    strings.purple = "Roxo"
    strings.recipeIconSpacing = "Espaçamento do Ícone"
    strings.recipesWindow = "Janela de Receitas"
    strings.updateIconDropdown = "Ícone do Botão do Mestre das Receitas"
    strings.showLearned = "Mostrar Receitas Aprendidas"        
    strings.sortBy = "Ordenar:"
    return

elseif locale == "deDE" then
    professionNames = {
        [171] = "Alchimie",
        [164] = "Schmiedekunst",
        [185] = "Kochkunst",
        [333] = "Verzauberkunst",
        [202] = "Ingenieurskunst",
        [129] = "Erste Hilfe",
        [356] = "Angeln",
        [773] = "Inschriftenkunde",
        [755] = "Juwelierskunst",
        [165] = "Lederverarbeitung",
        [186] = "Bergbau",
        [197] = "Schneiderei"
    }
    recipePrefixes = {"Rezept: ", "Pläne: ", "Formel: ", "Bauplan: ", "Muster: ", "Handbuch: "}
    strings.backgroundOpacity = "Hintergrundopazität"
    strings.blue = "Blau"
    strings.bright = "Hell"
    strings.dark = "Dunkel"
    strings.gray = "Grau"
    strings.green = "Grün"
    strings.orange = "Orange"
    strings.progressBar = "Fortschrittsbalken"
    strings.purple = "Lila"
    strings.recipeIconSpacing = "Symbolabstand"
    strings.recipesWindow = "Rezepte Fenster"
    strings.updateIconDropdown = "Symbol des Rezeptmeister"
    strings.showLearned = "Gelernte Rezepte anzeigen"
    return

elseif locale == "frFR" then
    professionNames = {
        [171] = "Alchimie",
        [164] = "Forge",
        [185] = "Cuisine",
        [333] = "Enchantement",
        [202] = "Ingénierie",
        [129] = "Secourisme",       -- Premiers soins ! ! !
        [356] = "Pêche",
        [773] = "Calligraphie",
        [755] = "Joaillerie",
        [165] = "Travail du cuir",
        [186] = "Minage",
        [197] = "Couture"
    }
    recipePrefixes = {"Recette : ", "Plan : ", "Plans : ", "Formule : ", "Schéma : ", "Patron : ", "Manuel : "}
    strings.backgroundOpacity = "Opacité de l'Arrière-plan"
    strings.blue = "Bleu"
    strings.bright = "Clair"
    strings.dark = "Foncé"
    strings.gray = "Gris"
    strings.green = "Vert"
    strings.orange = "Orange"
    strings.progressBar = "Barre de Progrès"
    strings.purple = "Violet"
    strings.recipeIconSpacing = "Espacement des Icônes"
    strings.recipesWindow = "Fenêtre des Recettes"
    strings.updateIconDropdown = "Icône du Bouton du Maître des Recettes"
    strings.showLearned = "Afficher les Recettes Apprises"
    return

--elseif locale == "itIT" then
    --professionNames = {}
    --recipePrefixes = {}
    --return

elseif locale == "ruRU" then
    professionNames = {
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
    recipePrefixes = {"Рецепт: ", "Чертеж: ", "Формула ", "Формула: ", "Схема: ", "Выкройка: ", "Учебник: "}
    fonts.bottomTab = "Fonts\\FRIZQT___CYR.TTF"
    offsets.headerTextY = 0
    offsets.tabTextY = 5.5
    strings.backgroundOpacity = "Прозрачность фона"
    strings.blue = "Синий"
    strings.bright = "Яркий"
    strings.dark = "Тёмный"
    strings.gray = "Серый"
    strings.green = "Зелёный"
    strings.orange = "Оранжевый"
    strings.progressBar = "Полоса прогресса"
    strings.purple = "Фиолетовый"
    strings.recipeIconSpacing = "Промежуток между иконками"
    strings.recipesWindow = "Окно рецептов"
    strings.updateIconDropdown = "Иконка кнопки Мастер Рецептов"
    strings.showLearned = "Показывать выученные рецепты"
    strings.sortBy = "Сорт:"
    return

elseif locale == "koKR" then
    professionNames = {
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
    recipePrefixes = {"조리법: ", "도면: ", "주문식: ", "설계도: ", "도안: ", "처방전: "}
    fonts.bottomTab = "Fonts\\2002.TTF"
    fontSizes.bottomTab = 11
    offsets.headerTextY = 0.4
    offsets.tabTextY = 5.5
    strings.backgroundOpacity = "배경 불투명도"
    strings.blue = "파랑"
    strings.bright = "밝은"
    strings.dark = "어두운"
    strings.gray = "회색"
    strings.green = "초록"
    strings.orange = "주황"
    strings.progressBar = "진행 막대"
    strings.purple = "보라"
    strings.recipeIconSpacing = "아이콘 간격"
    strings.recipesWindow = "레시피 창"
    strings.updateIconDropdown = "레시피 마스터 버튼 아이콘"
    strings.showLearned = "배웠던 레시피 보기"
    return

elseif locale == "zhTW" then
    professionNames = {
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
    recipePrefixes = {"食譜：", "設計圖：", "公式：", "結構圖：", "結構圖 : ", "圖樣：", "圖樣 : ", "說明書：", "手冊：", "配方："}
    fonts.bottomTab = "Fonts\\blei00d.TTF"
    fontSizes.bottomTab = 12
    offsets.headerTextY = 0
    strings.backgroundOpacity = "背景不透明度"
    strings.blue = "藍色"
    strings.bright = "明亮"
    strings.dark = "暗色"
    strings.gray = "灰色"
    strings.green = "綠色"
    strings.orange = "橙色"
    strings.progressBar = "進度條"
    strings.purple = "紫色"
    strings.recipeIconSpacing = "圖示間距"
    strings.recipesWindow = "食譜視窗"
    strings.updateIconDropdown = "食譜大師按鈕圖示"
    strings.showLearned = "顯示已學會的食譜"
    strings.sortBy = "分類："
    return

elseif locale == "zhCN" then
    professionNames = {
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
    recipePrefixes = {"食谱：", "配方：", "设计图：", "公式：", "结构图：", "图样：", "手册："}
    fonts.bottomTab = "Fonts\\ARKai_T.ttf"
    fontSizes.bottomTab = 12
    offsets.headerTextY = 0.8
    strings.backgroundOpacity = "背景不透明度"
    strings.blue = "蓝色"
    strings.bright = "明亮"
    strings.dark = "深色"
    strings.gray = "灰色"
    strings.green = "绿色"
    strings.orange = "橙色"
    strings.progressBar = "进度条"
    strings.purple = "紫色"
    strings.recipeIconSpacing = "图标间距"
    strings.recipesWindow = "食谱窗口"
    strings.updateIconDropdown = "食谱大师按钮图标"
    strings.showLearned = "显示已学会的食谱"
end
