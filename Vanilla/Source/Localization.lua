local _, rm = ...
local L = rm.L

if rm.locale == "enUS" then
    L.professionNames = {
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
    return

elseif rm.locale == "esMX" then
    L.professionNames = {
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
    L.recipePrefixes = {"Receta: ", "Diseño: ", "Fórmula: ", "Esquema: ", "Patrón: ", "Manual: "}
    L.strings.backgroundOpacity = "Opacidad del Fondo"
    L.strings.blue = "Azul"
    L.strings.bright = "Brillante"
    L.strings.dark = "Oscuro"
    L.strings.gray = "Gris"
    L.strings.green = "Verde"
    L.strings.orange = "Naranja"
    L.strings.progressBar = "Barra de Progreso"
    L.strings.purple = "Morado"
    L.strings.recipeIconSpacing = "Espaciado de Iconos"
    L.strings.recipesWindow = "Ventana de Recetas"
    L.strings.updateIconDropdown = "Ícono del Botón del Maestro de Recetas"
    L.strings.showLearned = "Mostrar Recetas Aprendidas"
    return

elseif rm.locale == "esES" then
    L.professionNames = {
        [171] = "Alquimia",
        [164] = "Herrería",
        [185] = "Cocina",
        [333] = "Encantamiento",
        [202] = "Ingeniería",
        [129] = "Primeros auxilios",
        [356] = "Pesca",
        [165] = "Peletería",
        [186] = "Minería",
        [197] = "Costura"
    }
    L.recipePrefixes = {"Receta: ", "Diseño: ", "Fórmula: ", "Esquema: ", "Patrón: ", "Manual: "}
    L.strings.backgroundOpacity = "Opacidad del Fondo"
    L.strings.blue = "Azul"
    L.strings.bright = "Brillante"
    L.strings.dark = "Oscuro"
    L.strings.gray = "Gris"
    L.strings.green = "Verde"
    L.strings.orange = "Naranja"
    L.strings.progressBar = "Barra de Progreso"
    L.strings.purple = "Morado"
    L.strings.recipeIconSpacing = "Espaciado de Iconos"
    L.strings.recipesWindow = "Ventana de Recetas"
    L.strings.updateIconDropdown = "Ícono del Botón del Maestro de Recetas"
    L.strings.showLearned = "Mostrar Recetas Aprendidas"
    return

elseif rm.locale == "ptBR" then
    L.professionNames = {
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
    L.strings.backgroundOpacity = "Opacidade do Fundo"
    L.strings.blue = "Azul"
    L.strings.bright = "Claro"
    L.strings.dark = "Escuro"
    L.strings.gray = "Cinza"
    L.strings.green = "Verde"
    L.strings.orange = "Laranja"
    L.strings.progressBar = "Barra de Progresso"
    L.strings.purple = "Roxo"
    L.strings.recipeIconSpacing = "Espaçamento do Ícone"
    L.strings.recipesWindow = "Janela de Receitas"
    L.strings.updateIconDropdown = "Ícone do Botão do Mestre das Receitas"
    L.strings.showLearned = "Mostrar Receitas Aprendidas"        
    L.strings.sortBy = "Ordenar:"
    return

elseif rm.locale == "deDE" then
    L.professionNames = {
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
    L.strings.backgroundOpacity = "Hintergrundopazität"
    L.strings.blue = "Blau"
    L.strings.bright = "Hell"
    L.strings.dark = "Dunkel"
    L.strings.gray = "Grau"
    L.strings.green = "Grün"
    L.strings.orange = "Orange"
    L.strings.progressBar = "Fortschrittsbalken"
    L.strings.purple = "Lila"
    L.strings.recipeIconSpacing = "Symbolabstand"
    L.strings.recipesWindow = "Rezepte Fenster"
    L.strings.updateIconDropdown = "Symbol des Rezeptmeister"
    L.strings.showLearned = "Gelernte Rezepte anzeigen"
    return

elseif rm.locale == "frFR" then
    L.professionNames = {
        [171] = "Alchimie",
        [164] = "Forge",
        [185] = "Cuisine",
        [333] = "Enchantement",
        [202] = "Ingénierie",
        [129] = "Secourisme",       -- Premiers soins ! ! !
        [356] = "Pêche",
        [165] = "Travail du cuir",
        [186] = "Minage",
        [197] = "Couture"
    }
    L.recipePrefixes = {"Recette : ", "Plan : ", "Plans : ", "Formule : ", "Schéma : ", "Patron : ", "Manuel : "}
    L.strings.backgroundOpacity = "Opacité de l'Arrière-plan"
    L.strings.blue = "Bleu"
    L.strings.bright = "Clair"
    L.strings.dark = "Foncé"
    L.strings.gray = "Gris"
    L.strings.green = "Vert"
    L.strings.orange = "Orange"
    L.strings.progressBar = "Barre de Progrès"
    L.strings.purple = "Violet"
    L.strings.recipeIconSpacing = "Espacement des Icônes"
    L.strings.recipesWindow = "Fenêtre des Recettes"
    L.strings.updateIconDropdown = "Icône du Bouton du Maître des Recettes"
    L.strings.showLearned = "Afficher les Recettes Apprises"
    return

elseif rm.locale == "ruRU" then
    L.professionNames = {
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
    L.fonts.bottomTab = "Fonts\\FRIZQT___CYR.TTF"
    L.offsets.headerTextY = 0
    L.offsets.tabTextY = 5.5
    L.strings.backgroundOpacity = "Прозрачность фона"
    L.strings.blue = "Синий"
    L.strings.bright = "Яркий"
    L.strings.dark = "Тёмный"
    L.strings.gray = "Серый"
    L.strings.green = "Зелёный"
    L.strings.orange = "Оранжевый"
    L.strings.progressBar = "Полоса прогресса"
    L.strings.purple = "Фиолетовый"
    L.strings.recipeIconSpacing = "Промежуток между иконками"
    L.strings.recipesWindow = "Окно рецептов"
    L.strings.updateIconDropdown = "Иконка кнопки Мастер Рецептов"
    L.strings.showLearned = "Показывать выученные рецепты"
    L.strings.sortBy = "Сорт:"
    return

elseif rm.locale == "koKR" then
    L.professionNames = {
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
    L.fonts.bottomTab = "Fonts\\2002.TTF"
    L.fontSizes.bottomTab = 11
    L.offsets.headerTextY = 0.4
    L.offsets.tabTextY = 5.5
    L.strings.backgroundOpacity = "배경 불투명도"
    L.strings.blue = "파랑"
    L.strings.bright = "밝은"
    L.strings.dark = "어두운"
    L.strings.gray = "회색"
    L.strings.green = "초록"
    L.strings.orange = "주황"
    L.strings.progressBar = "진행 막대"
    L.strings.purple = "보라"
    L.strings.recipeIconSpacing = "아이콘 간격"
    L.strings.recipesWindow = "레시피 창"
    L.strings.updateIconDropdown = "레시피 마스터 버튼 아이콘"
    L.strings.showLearned = "배웠던 레시피 보기"
    return

elseif rm.locale == "zhTW" then
    L.professionNames = {
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
    L.fonts.bottomTab = "Fonts\\blei00d.TTF"
    L.fontSizes.bottomTab = 12
    L.offsets.headerTextY = 0
    L.strings.backgroundOpacity = "背景不透明度"
    L.strings.blue = "藍色"
    L.strings.bright = "明亮"
    L.strings.dark = "暗色"
    L.strings.gray = "灰色"
    L.strings.green = "綠色"
    L.strings.orange = "橙色"
    L.strings.progressBar = "進度條"
    L.strings.purple = "紫色"
    L.strings.recipeIconSpacing = "圖示間距"
    L.strings.recipesWindow = "食譜視窗"
    L.strings.updateIconDropdown = "食譜大師按鈕圖示"
    L.strings.showLearned = "顯示已學會的食譜"
    L.strings.sortBy = "分類："
    return

elseif rm.locale == "zhCN" then
    L.professionNames = {
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
    L.fonts.bottomTab = "Fonts\\ARKai_T.ttf"
    L.fontSizes.bottomTab = 12
    L.offsets.headerTextY = 0.8
    L.strings.backgroundOpacity = "背景不透明度"
    L.strings.blue = "蓝色"
    L.strings.bright = "明亮"
    L.strings.dark = "深色"
    L.strings.gray = "灰色"
    L.strings.green = "绿色"
    L.strings.orange = "橙色"
    L.strings.progressBar = "进度条"
    L.strings.purple = "紫色"
    L.strings.recipeIconSpacing = "图标间距"
    L.strings.recipesWindow = "食谱窗口"
    L.strings.updateIconDropdown = "食谱大师按钮图标"
    L.strings.showLearned = "显示已学会的食谱"
end
