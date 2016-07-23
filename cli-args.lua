return {
    ["help"] = {
        aliases = "h",
        params = 0,
        action = function()
            print("Help")
        end
    },
    ["test"] = {
        aliases = "t",
        params = 1,
        action = function(inp)
            print(tostring(inp))
        end
    }
}
