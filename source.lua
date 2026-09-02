local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local HeliosLib = {}
HeliosLib.__index = HeliosLib

-- main theme colors for now
local COLORS = {
	Background = Color3.fromRGB(18, 18, 18),
	ElementBG = Color3.fromRGB(29, 29, 29),
	HoverBG = Color3.fromRGB(35, 35, 35),
	ClickBG = Color3.fromRGB(20, 20, 20),
	Accent = Color3.fromRGB(141, 185, 212),
	AccentDark = Color3.fromRGB(45, 45, 45),
	Text = Color3.fromRGB(255, 255, 255),
	Stroke = Color3.fromRGB(255, 255, 255)
}

function HeliosLib.new(windowTitle, AccentColor)
	local self = setmetatable({}, HeliosLib)
	
	if AccentColor then
		COLORS.Accent = AccentColor
	end
	
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "uihelios"
	self.ScreenGui.ResetOnSpawn = true
	self.ScreenGui.IgnoreGuiInset = false
	self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	self.main = Instance.new("Frame")
	self.main.Name = "main"
	self.main.ZIndex = 2
	self.main.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.main.AnchorPoint = Vector2.new(0.5, 0.5)
	self.main.Size = UDim2.new(0, 431, 0, 332)
	self.main.BackgroundColor3 = COLORS.Background
	self.main.BackgroundTransparency = 0.1
	self.main.BorderSizePixel = 0
	self.main.Parent = self.ScreenGui
	
	local mainShadow = Instance.new("UIShadow")

	mainShadow.BlurRadius = UDim.new(0, 25) 
	mainShadow.Color = Color3.fromRGB(0, 0, 0)
	mainShadow.Spread = UDim2.new(0, 10, 0, 10) 
	mainShadow.Transparency = 0.5
	mainShadow.ZIndex = -1
	mainShadow.Parent = self.main

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = self.main

	-- Topbar
	self.topbar = Instance.new("Frame")
	self.topbar.Name = "topbar"
	self.topbar.ZIndex = 8
	self.topbar.Position = UDim2.new(0.5, 0, 0.0615181103, 0)
	self.topbar.AnchorPoint = Vector2.new(0.5, 0.5)
	self.topbar.Size = UDim2.new(1, 0, 0.00903615635, 39)
	self.topbar.BackgroundColor3 = COLORS.ElementBG
	self.topbar.BorderSizePixel = 0
	self.topbar.Parent = self.main

	local topbarCorner = Instance.new("UICorner")
	topbarCorner.CornerRadius = UDim.new(0, 8)
	topbarCorner.Parent = self.topbar

	local fix = Instance.new("Frame")
	fix.Name = "fix"
	fix.ZIndex = 4
	fix.Position = UDim2.new(0.5, 0, 0.916666567, 0)
	fix.AnchorPoint = Vector2.new(0.5, 0.5)
	fix.Size = UDim2.new(0, 431, 0, 7)
	fix.BackgroundColor3 = COLORS.ElementBG
	fix.BorderSizePixel = 0
	fix.Parent = self.topbar

	local line = Instance.new("Frame")
	line.Name = "line"
	line.ZIndex = 40
	line.Position = UDim2.new(0.5, 0, 1.02400005, 0)
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Size = UDim2.new(0, 431, 0, 1)
	line.BackgroundColor3 = COLORS.Text
	line.BackgroundTransparency = 0.85
	line.BorderSizePixel = 0
	line.Parent = self.topbar

	-- title text
	self.title = Instance.new("TextLabel")
	self.title.Name = "title"
	self.title.ZIndex = 41
	self.title.Position = UDim2.new(0.292343378, 0, 0.523809493, 0)
	self.title.AnchorPoint = Vector2.new(0.5, 0.5)
	self.title.Size = UDim2.new(0, 253, 0, 42)
	self.title.BackgroundTransparency = 1
	self.title.Text = windowTitle or "Helios"
	self.title.TextSize = 14
	self.title.Font = Enum.Font.Roboto
	self.title.TextColor3 = COLORS.Text
	self.title.TextXAlignment = Enum.TextXAlignment.Left
	self.title.Parent = self.topbar

	local titlePadding = Instance.new("UIPadding")
	titlePadding.PaddingLeft = UDim.new(0.06, 0)
	titlePadding.Parent = self.title

	-- topbar controls (close/minimize)
	local exit = Instance.new("ImageButton")
	exit.Name = "exit"
	exit.ZIndex = 40
	exit.Position = UDim2.new(0.930394411, 0, 0.309523791, 0)
	exit.Size = UDim2.new(0, 18, 0, 18)
	exit.BackgroundTransparency = 1
	exit.Image = "rbxassetid://95805109458092"
	exit.Parent = self.topbar
	exit.MouseButton1Click:Connect(function()
		self.ScreenGui:Destroy()
	end)

	local minimize = Instance.new("ImageButton")
	minimize.Name = "minimize"
	minimize.ZIndex = 40
	minimize.Position = UDim2.new(0.860788882, 0, 0.309523791, 0)
	minimize.Size = UDim2.new(0, 18, 0, 18)
	minimize.BackgroundTransparency = 1
	minimize.Image = "rbxassetid://121427052571384"
	minimize.Parent = self.topbar
	
	local minimized = false
	local minimizeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	minimize.MouseButton1Click:Connect(function()
		minimized = not minimized

		if minimized then
			self.sidebar.Visible = false
			self.holder.Visible = false

			TweenService:Create(self.main, minimizeInfo, {Size = UDim2.new(0, 431, 0, 42)}):Play()
		else
			local expandTween = TweenService:Create(self.main, minimizeInfo, {Size = UDim2.new(0, 431, 0, 332)})
			expandTween:Play()
			expandTween.Completed:Wait()
			if not minimized then
				self.sidebar.Visible = true
				self.holder.Visible = true
			end
		end
	end)

	-- sidebar
	self.sidebar = Instance.new("Frame")
	self.sidebar.Name = "sidebar"
	self.sidebar.ZIndex = 8
	self.sidebar.Position = UDim2.new(0.136890948, 0, 0.563891649, 0)
	self.sidebar.AnchorPoint = Vector2.new(0.5, 0.5)
	self.sidebar.Size = UDim2.new(0.273781896, 0, 0.754746974, 39)
	self.sidebar.BackgroundColor3 = COLORS.ElementBG
	self.sidebar.BorderSizePixel = 0
	self.sidebar.Parent = self.main

	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 8)
	sidebarCorner.Parent = self.sidebar

	local fix_2 = Instance.new("Frame")
	fix_2.Name = "fix"
	fix_2.ZIndex = 4
	fix_2.Position = UDim2.new(0.5, 0, 0.016, 0)
	fix_2.AnchorPoint = Vector2.new(0.5, 0.5)
	fix_2.Size = UDim2.new(0, 118, 0, 10)
	fix_2.BackgroundColor3 = COLORS.ElementBG
	fix_2.BorderSizePixel = 0
	fix_2.Parent = self.sidebar

	local fix2 = Instance.new("Frame")
	fix2.Name = "fix2"
	fix2.ZIndex = 4
	fix2.Position = UDim2.new(0.949152529, 0, 0.500180423, 0)
	fix2.AnchorPoint = Vector2.new(0.5, 0.5)
	fix2.Size = UDim2.new(0, 12, 0, 290)
	fix2.BackgroundColor3 = COLORS.ElementBG
	fix2.BorderSizePixel = 0
	fix2.Parent = self.sidebar

	local line_2 = Instance.new("Frame")
	line_2.Name = "line"
	line_2.ZIndex = 35
	line_2.Position = UDim2.new(1, 0, 0.5, 0)
	line_2.AnchorPoint = Vector2.new(0.5, 0.5)
	line_2.Size = UDim2.new(0, 1, 0, 290)
	line_2.BackgroundColor3 = COLORS.Text
	line_2.BackgroundTransparency = 0.95
	line_2.BorderSizePixel = 0
	line_2.Parent = self.sidebar

	-- tab holder
	self.tabholder = Instance.new("Frame")
	self.tabholder.Name = "tabholder"
	self.tabholder.ZIndex = 30
	self.tabholder.Position = UDim2.new(0.502118647, 0, 0.506904304, 0)
	self.tabholder.AnchorPoint = Vector2.new(0.5, 0.5)
	self.tabholder.Size = UDim2.new(1.00399983, 0, 0.85151124, 39)
	self.tabholder.BackgroundTransparency = 1
	self.tabholder.Parent = self.sidebar

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0.015, 0)
	tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabListLayout.Parent = self.tabholder

	-- main content holderr
	self.holder = Instance.new("Frame")
	self.holder.Name = "holder"
	self.holder.ZIndex = 10
	self.holder.Position = UDim2.new(0.295823663, 0, 0.156798944, 0)
	self.holder.Size = UDim2.new(0, 294, 0, 279)
	self.holder.BackgroundTransparency = 1
	self.holder.Parent = self.main

	-- dragging window 
	local dragging, dragInput, dragStart, startPos
	self.topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.main.Position
		end
	end)
	self.topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	self.tabs = {}
	self.activeTab = nil
	return self
end

function HeliosLib:CreateTab(tabName, iconId)
	local tab = {}
	tab.name = tabName

	-- tab button
	tab.button = Instance.new("TextButton")
	tab.button.Name = tabName
	tab.button.ZIndex = 33
	tab.button.Size = UDim2.new(0, 109, 0, 29)
	tab.button.BackgroundColor3 = COLORS.Text
	tab.button.BackgroundTransparency = 1
	tab.button.Text = tabName
	tab.button.TextSize = 12
	tab.button.Font = Enum.Font.Roboto
	tab.button.TextColor3 = COLORS.Text
	tab.button.TextXAlignment = Enum.TextXAlignment.Left
	tab.button.Parent = self.tabholder
	tab.button.AutoButtonColor = false

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 4)
	tabCorner.Parent = tab.button

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingLeft = UDim.new(0.3, 0)
	tabPadding.Parent = tab.button

	tab.icon = Instance.new("ImageLabel")
	tab.icon.Name = "icon"
	tab.icon.ZIndex = 35
	tab.icon.Position = UDim2.new(-0.338552177, 0, 0.17, 0)
	tab.icon.Size = UDim2.new(0, 18, 0, 18)
	tab.icon.BackgroundTransparency = 1
	tab.icon.Image = iconId or "rbxassetid://95677656832974"
	tab.icon.Parent = tab.button

	-- container
	tab.container = Instance.new("ScrollingFrame")
	tab.container.Name = tabName .. "_container"
	tab.container.ZIndex = 10
	tab.container.Size = UDim2.new(1, 0, 1, 0)
	tab.container.BackgroundTransparency = 1
	tab.container.BorderSizePixel = 0
	tab.container.Visible = false
	tab.container.CanvasSize = UDim2.new(0, 0, 0, 0)
	tab.container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tab.container.ScrollBarThickness = 2
	tab.container.ScrollBarImageColor3 = COLORS.Text
	tab.container.ScrollBarImageTransparency = 0.8
	tab.container.Parent = self.holder

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingLeft = UDim.new(0, 6)
	contentPadding.PaddingTop = UDim.new(0, 2)
	contentPadding.Parent = tab.container

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 7)
	contentLayout.Parent = tab.container

	-- tab switching (will be making smooth later)
	local function selectTab()	
		if self.activeTab == tab then return end

		for _, t in pairs(self.tabs) do
			TweenService:Create(t.button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			t.container.Visible = false
		end
		TweenService:Create(tab.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
		tab.container.Visible = true
		tab.container.Position = UDim2.new(0, 15, 0, 0)
		TweenService:Create(tab.container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

		self.activeTab = tab
	end

	tab.button.MouseButton1Click:Connect(selectTab)

	if #self.tabs == 0 then
		selectTab()
	end

	table.insert(self.tabs, tab)

	local elementCount = 0
	
	-- hover tweening 
	local function ApplyButtonEffects(button)
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.HoverBG}):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.ElementBG}):Play()
		end)
		button.MouseButton1Down:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.ClickBG}):Play()
		end)
		button.MouseButton1Up:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.HoverBG}):Play()
		end)
	end

	function tab:CreateButton(buttonText, callback)
		elementCount = elementCount + 1
		local button = Instance.new("TextButton")
		button.Name = "Button"
		button.ZIndex = 44
		button.LayoutOrder = elementCount
		button.Size = UDim2.new(1, -12, 0, 30)
		button.BackgroundColor3 = COLORS.ElementBG
		button.AutoButtonColor = false
		button.Text = buttonText
		button.TextSize = 12
		button.Font = Enum.Font.Roboto
		button.TextColor3 = COLORS.Text
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = tab.container

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0.04, 0)
		padding.Parent = button

		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = COLORS.Stroke
		stroke.Thickness = 0.8
		stroke.Transparency = 0.9
		stroke.Parent = button
		
		ApplyButtonEffects(button)

		local icon = Instance.new("ImageLabel")
		icon.Name = "buttonicon"
		icon.ZIndex = 45
		icon.Position = UDim2.new(0.938, 0, 0.5, 0)
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Size = UDim2.new(0, 18, 0, 18)
		icon.BackgroundTransparency = 1
		icon.Image = "rbxassetid://103395270924957"
		icon.ImageTransparency = 0.9
		icon.Parent = button

		button.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
	end

	function tab:CreateSection(sectionText)
		elementCount = elementCount + 1
		local section = Instance.new("TextLabel")
		section.Name = "Section"
		section.ZIndex = 45
		section.LayoutOrder = elementCount
		section.Size = UDim2.new(1, -12, 0, 18)
		section.BackgroundTransparency = 1
		section.Text = sectionText
		section.TextSize = 11
		section.Font = Enum.Font.Roboto
		section.TextColor3 = COLORS.Text
		section.TextTransparency = 0.4
		section.TextXAlignment = Enum.TextXAlignment.Left
		section.Parent = tab.container
		
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0.01, 0)
		padding.Parent = section
	end

	function tab:CreateToggle(toggleText, defaultState, callback)
		elementCount = elementCount + 1
		local toggleState = defaultState or false

		local toggleBtn = Instance.new("TextButton")
		toggleBtn.Name = "Toggle"
		toggleBtn.ZIndex = 44
		toggleBtn.LayoutOrder = elementCount
		toggleBtn.Size = UDim2.new(1, -12, 0, 30)
		toggleBtn.BackgroundColor3 = COLORS.ElementBG
		toggleBtn.AutoButtonColor = false
		toggleBtn.Text = toggleText
		toggleBtn.TextSize = 12
		toggleBtn.Font = Enum.Font.Roboto
		toggleBtn.TextColor3 = COLORS.Text
		toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
		toggleBtn.Parent = tab.container

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = toggleBtn

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0.04, 0)
		padding.Parent = toggleBtn

		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = COLORS.Stroke
		stroke.Thickness = 0.8
		stroke.Transparency = 0.9
		stroke.Parent = toggleBtn
		
		ApplyButtonEffects(toggleBtn)

		local toggleIcon = Instance.new("Frame")
		toggleIcon.Name = "ToggleICON"
		toggleIcon.ZIndex = 45
		toggleIcon.Position = UDim2.new(0.895, 0, 0.5, 0)
		toggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		toggleIcon.Size = UDim2.new(0, 41, 0, 21)
		toggleIcon.BackgroundColor3 = toggleState and COLORS.Accent or COLORS.AccentDark
		toggleIcon.BorderSizePixel = 0
		toggleIcon.Parent = toggleBtn

		local iconCorner = Instance.new("UICorner")
		iconCorner.CornerRadius = UDim.new(0, 64)
		iconCorner.Parent = toggleIcon

		local toggleBall = Instance.new("Frame")
		toggleBall.Name = "Toggleball"
		toggleBall.ZIndex = 46
		toggleBall.Position = toggleState and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.26, 0, 0.5, 0)
		toggleBall.AnchorPoint = Vector2.new(0.5, 0.5)
		toggleBall.Size = UDim2.new(0, 16, 0, 16)
		toggleBall.BackgroundColor3 = COLORS.Text
		toggleBall.BorderSizePixel = 0
		toggleBall.Parent = toggleIcon

		local ballCorner = Instance.new("UICorner")
		ballCorner.CornerRadius = UDim.new(0, 64)
		ballCorner.Parent = toggleBall

		local function updateToggle()
			local targetColor = toggleState and COLORS.Accent or COLORS.AccentDark
			local targetPos = toggleState and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.26, 0, 0.5, 0)

			TweenService:Create(toggleIcon, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
			TweenService:Create(toggleBall, TweenInfo.new(0.2), {Position = targetPos}):Play()

			if callback then callback(toggleState) end
		end

		toggleBtn.MouseButton1Click:Connect(function()
			toggleState = not toggleState
			updateToggle()
		end)
	end
	
	function tab:CreateSlider(sliderText, min, max, default, callback)
		elementCount = elementCount + 1
		local sliderValue = default or min
		
		local sliderBtn = Instance.new("TextButton")
		sliderBtn.Name = "Slider"
		sliderBtn.ZIndex = 44
		sliderBtn.LayoutOrder = elementCount
		sliderBtn.Size = UDim2.new(1, -12, 0, 45)
		sliderBtn.BackgroundColor3 = COLORS.ElementBG
		sliderBtn.AutoButtonColor = false
		sliderBtn.Text = ""
		sliderBtn.Parent = tab.container
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = sliderBtn
		
		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = COLORS.Stroke
		stroke.Thickness = 0.8
		stroke.Transparency = 0.9
		stroke.Parent = sliderBtn
		
		local label = Instance.new("TextLabel")
		label.ZIndex = 45
		label.Size = UDim2.new(0.5, 0, 0.5, 0)
		label.Position = UDim2.new(0.04, 0, 0.08, 0)
		label.BackgroundTransparency = 1
		label.Text = sliderText
		label.TextSize = 12
		label.Font = Enum.Font.Roboto
		label.TextColor3 = COLORS.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = sliderBtn
		
		local valLabel = Instance.new("TextLabel")
		valLabel.ZIndex = 45
		valLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
		valLabel.Position = UDim2.new(0.46, 0, 0, 0)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(sliderValue)
		valLabel.TextSize = 12
		valLabel.Font = Enum.Font.Roboto
		valLabel.TextColor3 = COLORS.Text
		valLabel.TextXAlignment = Enum.TextXAlignment.Right
		valLabel.Parent = sliderBtn
		
		local trackBG = Instance.new("Frame")
		trackBG.ZIndex = 45
		trackBG.Size = UDim2.new(0.92, 0, 0, 6)
		trackBG.Position = UDim2.new(0.04, 0, 0.65, 0)
		trackBG.BackgroundColor3 = COLORS.AccentDark
		trackBG.BorderSizePixel = 0
		trackBG.Parent = sliderBtn
		
		local trackCorner = Instance.new("UICorner")
		trackCorner.CornerRadius = UDim.new(1, 0)
		trackCorner.Parent = trackBG
		
		local trackFill = Instance.new("Frame")
		trackFill.ZIndex = 46
		trackFill.Size = UDim2.new(math.clamp((sliderValue - min) / (max - min), 0, 1), 0, 1, 0)
		trackFill.BackgroundColor3 = COLORS.Accent
		trackFill.BorderSizePixel = 0
		trackFill.Parent = trackBG
		
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(1, 0)
		fillCorner.Parent = trackFill
		
		local dragging = false
		
		local function updateSlider(input)
			local percentage = math.clamp((input.Position.X - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
			local rawValue = min + ((max - min) * percentage)
			sliderValue = math.floor(rawValue)
			
			TweenService:Create(trackFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
			valLabel.Text = tostring(sliderValue)
			
			if callback then callback(sliderValue) end
		end
		
		sliderBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				updateSlider(input)
			end
		end)
		
		sliderBtn.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				updateSlider(input)
			end
		end)
	end
	
	function tab:CreateDropdown(dropdownText, options, default, callback)
		elementCount = elementCount + 1
		local selected = default or options[1]
		local open = false
		
		local dropdownFrame = Instance.new("Frame")
		dropdownFrame.Name = "Dropdown"
		dropdownFrame.ZIndex = 44
		dropdownFrame.LayoutOrder = elementCount
		dropdownFrame.Size = UDim2.new(1, -12, 0, 30)
		dropdownFrame.BackgroundTransparency = 1
		dropdownFrame.Parent = tab.container
		
		local mainBtn = Instance.new("TextButton")
		mainBtn.ZIndex = 45
		mainBtn.Size = UDim2.new(1, 0, 0, 30)
		mainBtn.BackgroundColor3 = COLORS.ElementBG
		mainBtn.AutoButtonColor = false
		mainBtn.Text = dropdownText .. " : " .. tostring(selected)
		mainBtn.TextSize = 12
		mainBtn.Font = Enum.Font.Roboto
		mainBtn.TextColor3 = COLORS.Text
		mainBtn.TextXAlignment = Enum.TextXAlignment.Left
		mainBtn.Parent = dropdownFrame
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = mainBtn
		
		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = COLORS.Stroke
		stroke.Thickness = 0.8
		stroke.Transparency = 0.9
		stroke.Parent = mainBtn
		
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0.04, 0)
		padding.Parent = mainBtn
		
		ApplyButtonEffects(mainBtn)
		
		local arrow = Instance.new("TextLabel")
		arrow.ZIndex = 46
		arrow.Size = UDim2.new(0, 20, 0, 20)
		arrow.Position = UDim2.new(0.9, 0, 0.15, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "+"
		arrow.TextSize = 16
		arrow.Font = Enum.Font.Roboto
		arrow.TextColor3 = COLORS.Text
		arrow.Parent = mainBtn
		
		local listFrame = Instance.new("Frame")
		listFrame.ZIndex = 44
		listFrame.Size = UDim2.new(1, 0, 0, 0)
		listFrame.Position = UDim2.new(0, 0, 0, 34)
		listFrame.BackgroundColor3 = COLORS.ElementBG
		listFrame.ClipsDescendants = true
		listFrame.Visible = false
		listFrame.Parent = dropdownFrame
		
		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0, 8)
		listCorner.Parent = listFrame
		
		local listStroke = Instance.new("UIStroke")
		listStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		listStroke.Color = COLORS.Stroke
		listStroke.Thickness = 0.8
		listStroke.Transparency = 0.9
		listStroke.Parent = listFrame
		
		local listLayout = Instance.new("UIListLayout")
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = listFrame
		
		local function toggleDropdown()
			open = not open
			arrow.Text = open and "-" or "+"
			listFrame.Visible = open
			
			local targetHeight = open and (#options * 25) or 0
			dropdownFrame.Size = UDim2.new(1, -12, 0, open and (34 + targetHeight) or 30)
			listFrame.Size = UDim2.new(1, 0, 0, targetHeight)
		end
		
		mainBtn.MouseButton1Click:Connect(toggleDropdown)
		
		for i, opt in pairs(options) do
			local optBtn = Instance.new("TextButton")
			optBtn.ZIndex = 46
			optBtn.Size = UDim2.new(1, 0, 0, 25)
			optBtn.BackgroundColor3 = COLORS.ElementBG
			optBtn.AutoButtonColor = false
			optBtn.Text = tostring(opt)
			optBtn.TextSize = 12
			optBtn.Font = Enum.Font.Roboto
			optBtn.TextColor3 = COLORS.Text
			optBtn.Parent = listFrame
			
			local optCorner = Instance.new("UICorner")
			optCorner.CornerRadius = UDim.new(0, 8)
			optCorner.Parent = optBtn
			
			optBtn.MouseEnter:Connect(function()
				TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.HoverBG}):Play()
			end)
			optBtn.MouseLeave:Connect(function()
				TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.ElementBG}):Play()
			end)
			
			optBtn.MouseButton1Click:Connect(function()
				selected = opt
				mainBtn.Text = dropdownText .. " : " .. tostring(selected)
				toggleDropdown()
				if callback then callback(selected) end
			end)
		end
	end

	return tab
end

return HeliosLib
