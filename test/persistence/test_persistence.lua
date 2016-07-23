function test_new_persistence()
    local persistence = Persistence("build/test/persistence")
    assert_not_nil(persistence)
end

function test_save()
    local persistence = Persistence("persistence")
    
    persistence.data["title"] = "my title"
    persistence.data["table"] = {}
    persistence.data["table"]["row"] = "one"
    persistence.data["table"]["column"] = 5
    table.insert(persistence.data, {true, false, true})

    persistence:save()

    assert_true(love.filesystem.exists(persistence.filename))

    persistence:load()

    
end