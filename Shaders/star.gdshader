// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,diffuse_burley,specular_schlick_ggx, shadows_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float Glow_Power : hint_range(0,10) = 3;
uniform float Lightness_Difference : hint_range(0,10) = 3;
uniform vec4 Sun_Color : source_color;

uniform sampler2D voronoi_noise;
uniform sampler2D emission_noise;
varying vec3 vertex_pos;
uniform float waveSpeed : hint_range(0,1) = 0.1;
uniform float fresnel : hint_range(0,2) = 1.0;

uniform float scale : hint_range(0,2) = 0.01;
uniform float blendSharpness : hint_range(0,2) = 0.0;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	vertex_pos = VERTEX;
}

// TRIPLANAR FUNCTION
vec4 triplanar_texture(vec3 position, vec3 normal, vec2 offset, sampler2D noise) {
	vec4 colX = texture(noise, position.xy * scale + offset);
	vec4 colY = texture(noise, position.xz * scale + offset);
	vec4 colZ = texture(noise, position.zy * scale + offset);
	
	vec3 blendWeight = abs(normal);
	blendWeight = vec3(pow(blendWeight.x, blendSharpness), pow(blendWeight.y, blendSharpness), pow(blendWeight.z, blendSharpness));
	blendWeight /= (blendWeight.x + blendWeight.y + blendWeight.z);
	
	return colX * blendWeight.x + colY * blendWeight.y + colZ * blendWeight.z;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	//ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	
	
	// Fresnel
	float fresnel_out = pow(fresnel - clamp(dot(NORMAL, VIEW), 0.0, fresnel), fresnel);

	vec2 waveOffsetA = vec2(TIME * waveSpeed, TIME * waveSpeed * 0.8);
	vec2 waveOffsetB = vec2(TIME * waveSpeed * - 0.8, TIME * waveSpeed * -0.3);
	vec2 result_offset = waveOffsetA + waveOffsetB;

	vec3 cloud_tex = triplanar_texture(vertex_pos, NORMAL, result_offset, voronoi_noise).rgb;
	vec3 cloud_tex_with_light = cloud_tex * vec3(Lightness_Difference);
	vec3 cloud_tex_with_light_with_color = cloud_tex_with_light * Sun_Color.rgb;
	vec3 cloud_tex_with_light_with_color_with_glow = vec3(Glow_Power) * cloud_tex_with_light_with_color;

	vec3 noise_tex = triplanar_texture(vertex_pos, NORMAL, result_offset, emission_noise).rgb;
	vec3 result = cloud_tex_with_light_with_color_with_glow * noise_tex;

	EMISSION = vec3(fresnel_out) * result;
}
