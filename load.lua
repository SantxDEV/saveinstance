-- SaveInstance by SantxDEV
-- github.com/SantxDEV/saveinstance

-- Força Archivable = true em TUDO antes de salvar
-- (remove proteção anti-cópia de jogos que setam Archivable=false nos parts)
local function forceArchivable()
    print("[SaveInstance] Removendo proteções Archivable...")
    local count = 0
    for _, v in game:GetDescendants() do
        if not v.Archivable then
            pcall(function()
                v.Archivable = true
                count += 1
            end)
        end
    end
    print(string.format("[SaveInstance] %d instâncias desbloqueadas.", count))
end

forceArchivable()

local synsaveinstance = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/SantxDEV/saveinstance/main/saveinstance.luau", true),
    "saveinstance"
)()

synsaveinstance({
    Decompile        = true,
    ShowStatus       = true,
    SaveNotCreatable = true,
    IgnoreNotArchivable = false,
    mode             = "full",
})
