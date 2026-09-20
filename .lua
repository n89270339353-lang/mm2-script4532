-- КОРНЕВОЙ ЭЛЕМЕНТ И НАСТРОЙКИ СТИЛЯ
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KitiMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Цветовая палитра (Modern Dark)
local Theme = {
    Background = Color3.fromRGB(18, 19, 23),
    Sidebar = Color3.fromRGB(24, 25, 30),
    Card = Color3.fromRGB(28, 30, 37),
    Accent = Color3.fromRGB(45, 105, 225), -- Синий цвет выделения
    TextMain = Color3.fromRGB(240, 240, 245),
    TextMuted = Color3.fromRGB(140, 145, 160),
    ToggleOn = Color3.fromRGB(75, 140, 255),
    ToggleOff = Color3.fromRGB(50, 52, 65)
}

-- Утилита для скругления углов
local function ApplyCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
end

-- ГЛАВНЫЙ ФРЕЙМ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Перетаскивание мышкой
ApplyCorner(MainFrame, 10)
MainFrame.Parent = ScreenGui

-- БОКОВАЯ ПАНЕЛЬ (SIDEBAR)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
ApplyCorner(Sidebar, 10)
Sidebar.Parent = MainFrame

-- Заголовок меню (KITI)
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(1, 0, 0, 50)
LogoLabel.Position = UDim2.new(0, 15, 0, 10)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "KITI"
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 22
LogoLabel.TextColor3 = Theme.TextMain
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.Parent = Sidebar

-- Сканнер вкладок
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -10, 1, -110)
TabContainer.Position = UDim2.new(0, 5, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 4)
UIList.Parent = TabContainer

-- Информация о пользователе внизу сайдбара
local UserFrame = Instance.new("Frame")
UserFrame.Size = UDim2.new(1, -20, 0, 40)
UserFrame.Position = UDim2.new(0, 10, 1, -50)
UserFrame.BackgroundTransparency = 1
UserFrame.Parent = Sidebar

local UserName = Instance.new("TextLabel")
UserName.Size = UDim2.new(1, 0, 0, 20)
UserName.Text = "ayaka"
UserName.Font = Enum.Font.GothamBold
UserName.TextSize = 14
UserName.TextColor3 = Theme.TextMain
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.BackgroundTransparency = 1
UserName.Parent = UserFrame

local UserSub = Instance.new("TextLabel")
UserSub.Size = UDim2.new(1, 0, 0, 15)
UserSub.Position = UDim2.new(0, 0, 0, 18)
UserSub.Text = "Never"
UserSub.Font = Enum.Font.Gotham
UserSub.TextSize = 11
UserSub.TextColor3 = Theme.TextMuted
UserSub.TextXAlignment = Enum.TextXAlignment.Left
UserSub.BackgroundTransparency = 1
UserSub.Parent = UserFrame


-- КОНТЕНТНАЯ ЧАСТЬ (СТРАНИЦЫ)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -190, 1, -50)
ContentFrame.Position = UDim2.new(0, 185, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Верхняя панель управления конфигурациями
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -190, 0, 40)
TopBar.Position = UDim2.new(0, 185, 0, 5)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local ConfigLabel = Instance.new("TextLabel")
ConfigLabel.Size = UDim2.new(0, 100, 1, 0)
ConfigLabel.Position = UDim2.new(0, 10, 0, 0)
ConfigLabel.Text = "💾 Default"
ConfigLabel.Font = Enum.Font.GothamMedium
ConfigLabel.TextSize = 14
ConfigLabel.TextColor3 = Theme.TextMuted
ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
ConfigLabel.BackgroundTransparency = 1
ConfigLabel.Parent = TopBar


-- ЛОГИКА ВКЛАДОК И СТРАНИЦ
local Tabs = {}
local Pages = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.BackgroundColor3 = Theme.Sidebar
    TabButton.BorderSizePixel = 0
    TabButton.Text = "     " .. name
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 13
    TabButton.TextColor3 = Theme.TextMuted
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    ApplyCorner(TabButton, 6)
    TabButton.Parent = TabContainer

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Card
    Page.Parent = ContentFrame

    local PageGrid = Instance.new("UIGridLayout")
    PageGrid.CellSize = UDim2.new(0.5, -8, 0, 195)
    PageGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    PageGrid.SortOrder = Enum.SortOrder.LayoutOrder
    PageGrid.Parent = Page

    Tabs[name] = TabButton
    Pages[name] = Page

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            TweenService:Create(Tabs[CurrentTab], TweenInfo.new(0.2), {BackgroundColor3 = Theme.Sidebar, TextColor3 = Theme.TextMuted}):Play()
            Pages[CurrentTab].Visible = false
        end
        CurrentTab = name
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextMain}):Play()
        Page.Visible = true
    end)

    return Page
end


-- ФУНКЦИОНАЛЬНЫЕ ЭЛЕМЕНТЫ ДЛЯ СЕКЦИЙ (КАРТОЧЕК)
local function CreateSection(page, title)
    local Section = Instance.new("Frame")
    Section.BackgroundColor3 = Theme.Card
    Section.BorderSizePixel = 0
    ApplyCorner(Section, 8)
    Section.Parent = page

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 28)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Text = title:upper()
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 11
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Section

    local ElementContainer = Instance.new("Frame")
    ElementContainer.Size = UDim2.new(1, -20, 1, -35)
    ElementContainer.Position = UDim2.new(0, 10, 0, 33)
    ElementContainer.BackgroundTransparency = 1
    ElementContainer.Parent = Section

    local ElementList = Instance.new("UIListLayout")
    ElementList.Padding = UDim.new(0, 6)
    ElementList.Parent = ElementContainer

    return ElementContainer
end

-- 1. Переключатель (Toggle)
local function AddToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 26)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextColor3 = Theme.TextMain
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 34, 0, 18)
    Button.Position = UDim2.new(1, -34, 0.5, -9)
    Button.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    Button.Text = ""
    ApplyCorner(Button, 9)
    Button.Parent = ToggleFrame

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Indicator.BackgroundColor3 = Theme.TextMain
    ApplyCorner(Indicator, 7)
    Indicator.Parent = Button

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and Theme.ToggleOn or Theme.ToggleOff
        
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.15), {Position = targetPos}):Play()
        
        callback(state)
    end)
end

-- 2. Кнопка действия (Button)
local function AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 28)
    Button.BackgroundColor3 = Color3.fromRGB(35, 38, 47)
    Button.Text = text
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 12
    Button.TextColor3 = Theme.TextMain
    ApplyCorner(Button, 6)
    Button.Parent = parent

    Button.MouseButton1Click:Connect(callback)
end

-- 3. Ввод числовых параметров (TextBox)
local function AddTextBox(parent, text, default, callback)
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, 0, 0, 26)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextColor3 = Theme.TextMain
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = BoxFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 50, 0, 20)
    Input.Position = UDim2.new(1, -50, 0.5, -10)
    Input.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
