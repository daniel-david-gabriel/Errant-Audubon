function test_new_dust()
    local dust = Dust(0, 0, 10, 10)
    assert_not_nil(dust)
end

function test_assert_false()
    assert_true(false)
end