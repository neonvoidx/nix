// A steady eldritch-green ring with one cyan highlight orbiting clockwise.
// Perimeter distance keeps the highlight's length and speed stable on wide windows.
vec4 border(vec2 uv) {
    vec4 native = umbriel_sample(uv);
    float ring = native.a;
    if (ring <= 0.0) {
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

    float head = mod(umbriel_time * 140.0, perimeter);
    float separation = abs(along - head);
    float distanceToHead = min(separation, perimeter - separation);
    float cyan = exp(-0.5 * pow(distanceToHead / 48.0, 2.0));

    vec3 green = vec3(0.216, 0.957, 0.600); // #37F499
    vec3 blue = vec3(0.200, 0.902, 0.949); // #33E6F2
    vec3 color = mix(green * 0.72, blue, cyan);
    return vec4(color * ring, ring);
}
