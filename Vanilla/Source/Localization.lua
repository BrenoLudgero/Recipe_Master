local _, rm = ...
local L = rm.L
local F = rm.F

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
    L.backgroundOpacity = "Background Opacity"
    L.blue = "Blue"
    L.bright = "Bright"
    L.dark = "Dark"
    L.gray = "Gray"
    L.green = "Green"
    L.orange = "Orange"
    L.progressBar = "Progress Bar"
    L.purple = "Purple"
    L.recipeIconSpacing = "Icon Spacing"
    L.recipesWindow = "Recipes Window"
    L.showLearned = "Show Learned Recipes"
    L.updateIconDropdown = "Recipe Master's Button Icon"
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
    L.backgroundOpacity = "Opacidad del Fondo"
    L.blue = "Azul"
    L.bright = "Brillante"
    L.dark = "Oscuro"
    L.gray = "Gris"
    L.green = "Verde"
    L.orange = "Naranja"
    L.progressBar = "Barra de Progreso"
    L.purple = "Morado"
    L.recipeIconSpacing = "Espaciado de Iconos"
    L.recipesWindow = "Ventana de Recetas"
    L.updateIconDropdown = "Ícono del Botón del Maestro de Recetas"
    L.showLearned = "Mostrar Recetas Aprendidas"
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
    L.backgroundOpacity = "Opacidad del Fondo"
    L.blue = "Azul"
    L.bright = "Brillante"
    L.dark = "Oscuro"
    L.gray = "Gris"
    L.green = "Verde"
    L.orange = "Naranja"
    L.progressBar = "Barra de Progreso"
    L.purple = "Morado"
    L.recipeIconSpacing = "Espaciado de Iconos"
    L.recipesWindow = "Ventana de Recetas"
    L.updateIconDropdown = "Ícono del Botón del Maestro de Recetas"
    L.showLearned = "Mostrar Recetas Aprendidas"
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
    L.backgroundOpacity = "Opacidade do Fundo"
    L.blue = "Azul"
    L.bright = "Claro"
    L.dark = "Escuro"
    L.gray = "Cinza"
    L.green = "Verde"
    L.orange = "Laranja"
    L.progressBar = "Barra de Progresso"
    L.purple = "Roxo"
    L.recipeIconSpacing = "Espaçamento do Ícone"
    L.recipesWindow = "Janela de Receitas"
    L.updateIconDropdown = "Ícone do Botão do Mestre das Receitas"
    L.showLearned = "Mostrar Receitas Aprendidas"        
    L.sortBy = "Ordenar:"
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
    L.backgroundOpacity = "Hintergrundopazität"
    L.blue = "Blau"
    L.bright = "Hell"
    L.dark = "Dunkel"
    L.gray = "Grau"
    L.green = "Grün"
    L.orange = "Orange"
    L.progressBar = "Fortschrittsbalken"
    L.purple = "Lila"
    L.recipeIconSpacing = "Symbolabstand"
    L.recipesWindow = "Rezepte Fenster"
    L.updateIconDropdown = "Symbol des Rezeptmeister"
    L.showLearned = "Gelernte Rezepte anzeigen"
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
    L.backgroundOpacity = "Opacité de l'Arrière-plan"
    L.blue = "Bleu"
    L.bright = "Clair"
    L.dark = "Foncé"
    L.gray = "Gris"
    L.green = "Vert"
    L.orange = "Orange"
    L.progressBar = "Barre de Progrès"
    L.purple = "Violet"
    L.recipeIconSpacing = "Espacement des Icônes"
    L.recipesWindow = "Fenêtre des Recettes"
    L.updateIconDropdown = "Icône du Bouton du Maître des Recettes"
    L.showLearned = "Afficher les Recettes Apprises"
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
    L.backgroundOpacity = "Прозрачность фона"
    L.blue = "Синий"
    L.bright = "Яркий"
    L.dark = "Тёмный"
    L.gray = "Серый"
    L.green = "Зелёный"
    L.orange = "Оранжевый"
    L.progressBar = "Полоса прогресса"
    L.purple = "Фиолетовый"
    L.recipeIconSpacing = "Промежуток между иконками"
    L.recipesWindow = "Окно рецептов"
    L.updateIconDropdown = "Иконка кнопки Мастер Рецептов"
    L.showLearned = "Показывать выученные рецепты"
    L.sortBy = "Сорт:"
    F.fonts.bottomTab = "Fonts\\FRIZQT___CYR.TTF"
    F.offsets.headerTextY = 0
    F.offsets.tabTextY = 5.5
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
    L.backgroundOpacity = "배경 불투명도"
    L.blue = "파랑"
    L.bright = "밝은"
    L.dark = "어두운"
    L.gray = "회색"
    L.green = "초록"
    L.orange = "주황"
    L.progressBar = "진행 막대"
    L.purple = "보라"
    L.recipeIconSpacing = "아이콘 간격"
    L.recipesWindow = "레시피 창"
    L.updateIconDropdown = "레시피 마스터 버튼 아이콘"
    L.showLearned = "배웠던 레시피 보기"
    F.fonts.bottomTab = "Fonts\\2002.TTF"
    F.fontSizes.bottomTab = 11
    F.offsets.headerTextY = 0.4
    F.offsets.tabTextY = 5.5
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
    L.backgroundOpacity = "背景不透明度"
    L.blue = "藍色"
    L.bright = "明亮"
    L.dark = "暗色"
    L.gray = "灰色"
    L.green = "綠色"
    L.orange = "橙色"
    L.progressBar = "進度條"
    L.purple = "紫色"
    L.recipeIconSpacing = "圖示間距"
    L.recipesWindow = "食譜視窗"
    L.updateIconDropdown = "食譜大師按鈕圖示"
    L.showLearned = "顯示已學會的食譜"
    L.sortBy = "分類："
    F.fonts.bottomTab = "Fonts\\blei00d.TTF"
    F.fontSizes.bottomTab = 12
    F.offsets.headerTextY = 0
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
    L.backgroundOpacity = "背景不透明度"
    L.blue = "蓝色"
    L.bright = "明亮"
    L.dark = "深色"
    L.gray = "灰色"
    L.green = "绿色"
    L.orange = "橙色"
    L.progressBar = "进度条"
    L.purple = "紫色"
    L.recipeIconSpacing = "图标间距"
    L.recipesWindow = "食谱窗口"
    L.updateIconDropdown = "食谱大师按钮图标"
    L.showLearned = "显示已学会的食谱"
    F.fonts.bottomTab = "Fonts\\ARKai_T.ttf"
    F.fontSizes.bottomTab = 12
    F.offsets.headerTextY = 0.8
end
