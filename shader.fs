extern vec2 screen;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 c = Texel(texture, texture_coords); 
    return vec4(c.r*(screen_coords.x / screen.x), c.g*(screen_coords.y / screen.y), c.b, c.a); 
}