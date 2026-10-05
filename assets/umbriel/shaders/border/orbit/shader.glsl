// A steady border with one palette-colored highlight orbiting clockwise.
// Perimeter distance keeps the highlight's length and speed stable on wide windows.
vec4 border(vec2 uv) {
    vec4 native = umbriel_sample(uv);
    float ring = native.a;
    float borderDistance = umbriel_border_distance(uv);
    if (borderDistance < 0.0) {
        return native;
    }

    vec2 p = uv * umbriel_size;
    float width = umbriel_size.x;
    float height = umbriel_size.y;
    float perimeter = 2.0 * (width + height);
    float top = p.y;
    float right = width - p.x;
    float bottom = height - p.y;
    float left = p.x;

    // Measure clockwise from the top-left corner of the effect rectangle.
    float along;
    if (top <= right && top <= bottom && top <= left) {
        along = p.x;
    } else if (right <= bottom && right <= left) {
        along = width + p.y;
    } else if (bottom <= left) {
        along = width + height + (width - p.x);
    } else {
        along = 2.0 * width + height + (height - p.y);
    }

    // umbriel_time already includes the preset's speed multiplier.
    float head = mod(umbriel_time * 100.0, perimeter);
    float separation = abs(along - head);
    float distanceToHead = min(separation, perimeter - separation);
    float orbitIntensity = exp(-0.5 * pow(distanceToHead / 48.0, 2.0));

    // Umbriel's first two palette stops are accent_primary and accent_secondary.
    vec3 borderColor = umbriel_palette_at(0.0).rgb;
    vec3 orbitColor = umbriel_palette_at(0.25).rgb;
    vec3 highlight = min(orbitColor * 1.25, vec3(1.0));
    vec3 color = mix(borderColor * 0.72, highlight, orbitIntensity);

    // Widen the orbit beyond the native ring, then fade it into a softer halo.
    float band = orbitIntensity * (1.0 - ring) * 0.95
        * (1.0 - smoothstep(5.0, 8.0, borderDistance));
    float halo = orbitIntensity * (1.0 - ring) * 0.75 * exp(-borderDistance / 5.0);
    float orbitAlpha = max(band, halo);

    // The preset's padding enlarges the draw area and moves the client hole.
    // Derive the fade reach from that inset so effect.toml controls it.
    float inset = min(umbriel_border_hole.x * umbriel_size.x,
        umbriel_border_hole.y * umbriel_size.y);
    float fadeEnd = max(3.1, inset * 0.5 - 1.0);
    float borderHalo = (1.0 - ring) * (1.0 - orbitIntensity) * 0.18
        * (1.0 - smoothstep(3.0, fadeEnd, borderDistance));
    float outerAlpha = max(orbitAlpha, borderHalo);
    vec3 outerColor = mix(borderColor, highlight, orbitIntensity);
    return vec4(color * ring + outerColor * outerAlpha, ring + outerAlpha);
}
