// Adapted from shaders/animations/wobbly-move.glsl
// Elastic sheet deformation for animated moves and resizes.
// No pointer/velocity uniforms are available: this follows the event timeline.
const float WOBBLE_STRENGTH = 1.0;

vec4 animation(vec2 uv) {
    float p = clamp(umbriel_linear_progress, 0.0, 1.0);
    if (p <= 0.0 || p >= 1.0) return umbriel_sample(uv);
    // Smooth onset and a damped tail, both exactly zero at the endpoints.
    float envelope = sin(3.14159265 * p) * (1.0 - p) * 1.55;
    float swing = sin(15.70796327 * p);
    float counter = sin(15.70796327 * p - 1.15);
    float strength = clamp(WOBBLE_STRENGTH, 0.0, 1.5);
    float amplitude = envelope * strength;
    vec2 q = uv - 0.5;
    // Inset reserves room for the bending silhouette within the captured quad.
    vec2 inset = vec2(1.0) - amplitude * vec2(0.13, 0.12);
    q /= inset;
    float direction = umbriel_direction < 0.0 ? -1.0 : 1.0;
    q.x -= direction * amplitude * (0.035 * swing * cos(q.y * 5.2)
        + 0.022 * counter * sin(q.y * 6.0));
    q.y -= amplitude * (0.028 * counter * cos(q.x * 5.0)
        + 0.014 * swing * sin(q.x * 6.0));
    return umbriel_sample(q + 0.5);
}
