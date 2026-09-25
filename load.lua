-- SaveInstance by SantxDEV
-- github.com/SantxDEV/saveinstance

-- Força Archivable=true em toda a hierarquia do jogo
local function forceArchivable()
    print("[SI] Desbloqueando instâncias do jogo...")
    local n = 0
    for _, v in game:GetDescendants() do
        if not v.Archivable then
            pcall(function()
                v.Archivable = true
                n += 1
            end)
        end
    end
    print(string.format("[SI] %d instâncias desbloqueadas na hierarquia.", n))
end

-- Força Archivable=true em instâncias nil (sem parent, escondidas)
local function forceArchivableNil()
    local fn = getnilinstances
    if not fn then return end
    local n = 0
    for _, v in fn() do
        pcall(function()
            v.Archivable = true
            n += 1
        end)
    end
    print(string.format("[SI] %d instâncias nil desbloqueadas.", n))
end

-- Força Archivable=true em TUDO que o executor enxerga (getinstances)
local function forceArchivableAll()
    local fn = getinstances
    if not fn then return end
    local n = 0
    for _, v in fn() do
        if typeof(v) == "Instance" and not v.Archivable then
            pcall(function()
                v.Archivable = true
                n += 1
            end)
        end
    end
    if n > 0 then
        print(string.format("[SI] %d instâncias extras desbloqueadas (getinstances).", n))
    end
end

forceArchivable()
forceArchivableNil()
forceArchivableAll()

print("[SI] Iniciando salvamento completo...")

local synsaveinstance = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/SantxDEV/saveinstance/main/saveinstance.luau", true),
    "saveinstance"
)()

synsaveinstance({
    Decompile           = true,
    ShowStatus          = true,
    mode                = "full",
    SaveNotCreatable    = true,
    IgnoreNotArchivable = false,
    NilInstances        = true,
    IgnoreList          = { "CoreGui", "CorePackages" },
})
