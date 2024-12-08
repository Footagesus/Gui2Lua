local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

WindUI:SetTheme("Dark")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Gui = {
    version = "1.0.1",
    Properties = {
        -- ImageLabel
        "ImageRectOffset", "SliceCenter", "SliceScale", "TileSize",
        "ImageTransparency", "ImageRectSize", 
        "Image", "ImageColor3", "ScaleType", 
        
        -- GUI Objects
        "BorderColor3", "BorderTransparency", 
        "BorderMode", "BorderSizePixel",
        "Name", "Active", "Visible", "ClipsDescendants", 
        "Rotation", "ZIndex", "LayoutOrder",
        "Size", "Position", "AutomaticSize", "AnchorPoint",
        "BackgroundTransparency", "Transparency", 
        "BackgroundColor3", 
        "SizeConstraint", "Interactable",
        "SelectionOrder", "SelectionImageObject",
        
        -- CanvasGroup
        "GroupTransparency", "GroupColor3", 
        
        -- TextLabel, TextButton, TextBox
        "Text", "TextColor3", "TextSize", "TextXAlignment", 
        "TextYAlignment", "FontFace", "TextWrapped", "RichText",
        "AutoButtonColor", "LineHeight", "TextTruncate", "TextFit",
        "TextTransparency", "PlaceholderText", "PlaceholderColor3",
        "TextDirection", "ClearTextOnFocus",
        
        
        -- UIPadding
        "PaddingTop", "PaddingLeft", "PaddingRight", "PaddingBottom",
        
        -- ScrollingFrame
        "CanvasPosition", "CanvasSize", "ElasticBehavior", 
        "HorizontalScrollBarInset", "VerticalScrollBarInset",
        "VerticalScrollBarPosition",
        "BottomImage", "TopImage", "MidImage",
        "ScrollBarImageColor3", "ScrollBarImageTransparency",
        "ScrollBarThickness", "ScrollingDirection", "ScrollingEnabled",
        
        -- UICorner
        "CornerRadius", 
        
        -- UIScale
        "Scale", 
        
        -- UIStroke, UIGradient
        "Thickness", "ApplyStrokeMode", "Color",
        
        -- UIListLayout
        "SortOrder", "VerticalAlignment", "HorizontalAlignment", 
        "FillDirection", "Padding",
        
        -- ScreenGui
        "ZIndexBehavior", "IgnoreGuiInset",
        
        -- All elements omg
        "Parent",
    },
    
    Serializers = {
        ColorSequence = function(colorSequence)
            local keypoints = colorSequence.Keypoints
            local serializedKeypoints = {}
            for _, keypoint in ipairs(keypoints) do
                table.insert(serializedKeypoints, string.format("ColorSequenceKeypoint.new(%s, Color3.fromRGB(%d, %d, %d))",
                    keypoint.Time,
                    math.floor(keypoint.Value.R * 255),
                    math.floor(keypoint.Value.G * 255),
                    math.floor(keypoint.Value.B * 255)
                ))
            end
            return string.format("ColorSequence.new({%s})", table.concat(serializedKeypoints, ", "))
        end,
        
        NumberSequence = function(numberSequence)
            local keypoints = numberSequence.Keypoints
            local serializedKeypoints = {}
            for _, keypoint in ipairs(keypoints) do
                table.insert(serializedKeypoints, string.format("NumberSequenceKeypoint.new(%s, %s, %s)",
                    keypoint.Time,
                    keypoint.Value,
                    keypoint.Envelope
                ))
            end
            return string.format("NumberSequence.new({%s})", table.concat(serializedKeypoints, ", "))
        end,
        Color3 = function(color)
            return string.format("Color3.fromRGB(%d, %d, %d)", 
                math.floor(color.R * 255), 
                math.floor(color.G * 255), 
                math.floor(color.B * 255))
        end,
        UDim2 = function(udim)
            return string.format("UDim2.new(%s, %s, %s, %s)", 
                udim.X.Scale, udim.X.Offset, 
                udim.Y.Scale, udim.Y.Offset)
        end,
        UDim = function(udim)
            return string.format("UDim.new(%s, %s)", 
                udim.Scale, udim.Offset)
        end,
        Rect = function(rect)
            return string.format("Rect.new(%s, %s, %s, %s)", 
                rect.Min.X, rect.Min.Y, rect.Max.X, rect.Max.Y)
        end,
        Vector2 = function(vector)
            return string.format("Vector2.new(%s, %s)", vector.X, vector.Y)
        end,
        Enum = function(enum)
            return tostring(enum)
        end,
        EnumItem = function(enumItem) 
            return tostring(enumItem)
        end,
        Font = function(fontFace)
            return string.format("Font.new(%q, Enum.FontWeight.%s, Enum.FontStyle.%s)", fontFace.Family, fontFace.Weight.Name, fontFace.Style.Name)
        end,
        number = function(value)
            return tostring(value)
        end,
        boolean = function(value)
            return tostring(value)
        end,
        string = function(value)
            return string.format("%q", value)
        end,
    },
    Counters = {}
}


function Gui:GenerateName(objectType)
    Gui.Counters[objectType] = (Gui.Counters[objectType] or 0) + 1
    return string.format("%s_%d", objectType, Gui.Counters[objectType])
end

function Gui:SerializeObject(object, parentVar)
    local output = ""
    local name = Gui:GenerateName(object.ClassName)
    
    output = output .. string.format("local %s = Instance.new(%q)\n", name, object.ClassName)
    output = output .. string.format("%s.Parent = %s\n", name, parentVar or "game.CoreGui")
    
    for _, property in next, Gui.Properties do
        local success, value = pcall(function() return object[property] end)
        if success and value ~= nil then
            local serializer = Gui.Serializers[typeof(value)]
            if serializer then
                output = output .. string.format("%s.%s = %s\n", name, property, serializer(value))
            end
        end
    end
    
    for _, child in ipairs(object:GetChildren()) do
        output = output .. Gui:SerializeObject(child, name)
    end
    
    return output
end

function Gui:Save(object, filename)
    local luaCode = Gui:SerializeObject(object)
    writefile(filename, luaCode)
end

--return Gui



function UI()
    local ButtonColor = Color3.new(1,1,1)
    if game.CoreGui:FindFirstChild("Gui2Lua") then
        game.CoreGui:FindFirstChild("Gui2Lua"):Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "Gui2Lua"
    
    
    local Size = UDim2.new(0,300,0,420)
    
    
    local CanvasGroup = Instance.new("CanvasGroup", ScreenGui)
    CanvasGroup.Size = Size
    CanvasGroup.Position = UDim2.new(0.5,0,0.5,0)
    CanvasGroup.Active = UDim2.new(0.5,0,0.5,0)
    CanvasGroup.AnchorPoint = Vector2.new(0.5,0.5)
    CanvasGroup.BackgroundColor3 = Color3.fromHex("#161616")
    CanvasGroup.BackgroundTransparency = .15

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        CanvasGroup.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
    end
    CanvasGroup.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = CanvasGroup.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    CanvasGroup.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    local UICorner = Instance.new("UICorner", CanvasGroup)
    UICorner.CornerRadius = UDim.new(0,12)
    
    local UIPadding = Instance.new("UIPadding", CanvasGroup)
    UIPadding.PaddingTop = UDim.new(0,14)
    UIPadding.PaddingLeft = UDim.new(0,14)
    UIPadding.PaddingRight = UDim.new(0,14)
    UIPadding.PaddingBottom = UDim.new(0,14)
    
    local UIListLayout = Instance.new("UIListLayout", CanvasGroup)
    UIListLayout.FillDirection = "Vertical"
    UIListLayout.SortOrder = "LayoutOrder"
    UIListLayout.Padding = UDim.new(0,16)
    
    local TextLabel = Instance.new("TextLabel", CanvasGroup)
    TextLabel.Size = UDim2.new(1,0,0,0)
    TextLabel.TextXAlignment = "Left"
    TextLabel.AutomaticSize = "Y"
    TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.new(1,1,1)
    TextLabel.Text = "Gui2Lua"
    TextLabel.TextSize = 22
    TextLabel.TextWrapped = true
    TextLabel.LayoutOrder = 1
    
    local ImageButton = Instance.new("ImageButton", TextLabel)
    ImageButton.Size = UDim2.new(0,TextLabel.AbsoluteSize.Y,0,TextLabel.AbsoluteSize.Y)
    ImageButton.Position = UDim2.new(1,0,0,0)
    ImageButton.AnchorPoint= Vector2.new(1,0)
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = "rbxassetid://10747384394"
    
    local Closed = false
    
    ImageButton.MouseButton1Click:Connect(function()
        if not Closed then
            TweenService:Create(CanvasGroup, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(
                    0,
                    TextLabel.TextBounds.X + UIPadding.PaddingLeft.Offset*3 + TextLabel.TextBounds.Y,
                    0,
                    TextLabel.TextBounds.Y + UIPadding.PaddingTop.Offset*2
                )
            }):Play()
            TweenService:Create(ImageButton, TweenInfo.new(.25), {Rotation = 45}):Play()
        else
            TweenService:Create(CanvasGroup, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = Size
            }):Play()
            
            TweenService:Create(ImageButton, TweenInfo.new(.25), {Rotation = 0}):Play()
        end
        Closed = not Closed
    end)
    
    local TextBoxCanvas = Instance.new("Frame", CanvasGroup)
    TextBoxCanvas.Size = UDim2.new(1,0,0,0)
    TextBoxCanvas.AutomaticSize = "Y"
    TextBoxCanvas.BackgroundColor3 = Color3.new(1,1,1)
    TextBoxCanvas.BackgroundTransparency = .95
    TextBoxCanvas.LayoutOrder = 2
    
    local UIPadding = Instance.new("UIPadding", TextBoxCanvas)
    UIPadding.PaddingTop = UDim.new(0,9)
    UIPadding.PaddingLeft = UDim.new(0,12)
    UIPadding.PaddingRight = UDim.new(0,12)
    UIPadding.PaddingBottom = UDim.new(0,9)
    
    local UIStroke = Instance.new("UIStroke", TextBoxCanvas)
    UIStroke.Thickness = .6
    UIStroke.Color = Color3.new(1,1,1)
    UIStroke.Transparency = .8
    
    Instance.new("UICorner", TextBoxCanvas).CornerRadius = UDim.new(0,8)
    
    local TextBox = Instance.new("TextBox", TextBoxCanvas)
    TextBox.Size = UDim2.new(1,0,0,0)
    TextBox.AutomaticSize = "Y"
    TextBox.TextWrapped = true
    TextBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(1,1,1)
    TextBox.PlaceholderText = "Enter path to ScreenGui..."
    TextBox.TextXAlignment = "Left"
    TextBox.TextSize = 18
    TextBox.BackgroundTransparency = 1
    TextBox.ClearTextOnFocus = false
    
    local TextButton = Instance.new("TextButton", CanvasGroup)
    TextButton.Size = UDim2.new(1,0,0,35)
    TextButton.Text = "Convert"
    TextButton.AutoButtonColor = false
    TextButton.TextColor3 = Color3.new(0,0,0)
    TextButton.BackgroundColor3 = ButtonColor
    TextButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    TextButton.TextSize = 18
    TextButton.LayoutOrder = 3
    
    TextButton.MouseEnter:Connect(function()
        TweenService:Create(TextButton, TweenInfo.new(.1), {
            BackgroundColor3 = Color3.new(
                ButtonColor.R-.4,
                ButtonColor.G-.4,
                ButtonColor.B-.4
            )
            
        }):Play()
    end)
    TextButton.MouseLeave:Connect(function()
        TweenService:Create(TextButton, TweenInfo.new(.1), {
            BackgroundColor3 = ButtonColor
        }):Play()
    end)
    
    TextButton.MouseButton1Click:Connect(function()
        local text = TextBox.Text
        if text == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a valid path.",
                Duration = 5
            })
            return
        end
        
        local success, screenGui = pcall(function()
            return loadstring("return " .. text)()
        end)
        
        if success and screenGui and screenGui:IsA("ScreenGui") then
            local filename = string.format("Gui2Lua/%s.lua", screenGui.Name)
            Gui:Save(screenGui, filename)
            WindUI:Notify({
                Title = "Successfully",
                Content = "Saved to file: " .. filename,
                Duration = 5
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Invalid ScreenGui path or conversion error.",
                Duration = 10
            })
        end
    end)
    
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0,8)
    
    CanvasGroup.Size = UDim2.new(0,300,0,UIListLayout.AbsoluteContentSize.Y+14+14)
    Size = UDim2.new(0,300,0,UIListLayout.AbsoluteContentSize.Y+14+14)
    
end

UI()