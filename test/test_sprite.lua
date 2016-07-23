function test_new_sprite()
    local sprite = Sprite(0, 0, 10, 10)
    assert_not_nil(sprite)
end

function test_sprite_move_down()
    local sprite = Sprite(0, 0, 10, 10)
    
    sprite:move("down", 10)

    asert_equal(sprite.x, 10)
end