-- SaveInstance by SantxDEV
-- github.com/SantxDEV/saveinstance

-- Percorre o mapa inteiro pra forçar carregamento antes de salvar
local function streamingWarmup()
    if not workspace.StreamingEnabled then return end

    local player = game:GetService("Players").LocalPlayer
    if not player then return end

    print("[SaveInstance] StreamingEnabled detectado — carregando mapa completo...")

    -- Bounds das parts já carregadas
    local minX, minZ =  math.huge,  math.huge
    local maxX, maxZ = -math.huge, -math.huge
    local baseY = 100

    for _, v in workspace:GetDescendants() do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            local p = v.Position
            if p.X < minX then minX = p.X end
            if p.Z < minZ then minZ = p.Z end
            if p.X > maxX then maxX = p.X end
            if p.Z > maxZ then maxZ = p.Z end
            if p.Y > baseY then baseY = p.Y end
        end
    end

    if minX == math.huge then
        minX, minZ, maxX, maxZ = -800, -800, 800, 800
    end

    local pad  = 300
    local step = math.max(workspace.StreamingMinRadius or 64, 80)
    minX -= pad; minZ -= pad
    maxX += pad; maxZ += pad

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local y    = baseY + 80

    -- Monta grid de posições
    local positions = {}
    local x = minX
    while x <= maxX do
        local z = minZ
        while z <= maxZ do
            positions[#positions + 1] = Vector3.new(x, y, z)
            z += step
        end
        x += step
    end

    local total = #positions
    print(string.format("[SaveInstance] %d posições para carregar...", total))

    for i, pos in positions do
        -- Teleporta o personagem (força streaming local)
        if hrp then
            pcall(function() hrp.CFrame = CFrame.new(pos) end)
        end
        -- Pede ao servidor para priorizar essa área
        pcall(function()
            player:RequestStreamAroundAsync(pos, 5)
        end)
        if i % 10 == 0 or i == total then
            print(string.format("[SaveInstance] %d/%d (%.0f%%)", i, total, i / total * 100))
        end
    end

    task.wait(3)
    print("[SaveInstance] Mapa carregado! Iniciando salvamento...")
end

streamingWarmup()

local synsaveinstance = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/SantxDEV/saveinstance/main/saveinstance.luau", true),
    "saveinstance"
)()

synsaveinstance({
    Decompile       = true,
    ShowStatus      = true,
    SaveNotCreatable = true,
})
