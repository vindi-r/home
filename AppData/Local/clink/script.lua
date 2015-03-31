function expand_tilda(text, first, last)
    if not text:find("^~$") then
        return false
    end

    clink.add_match(clink.get_env('USERPROFILE'))
    return true
end

clink.register_match_generator(expand_tilda, 10)

