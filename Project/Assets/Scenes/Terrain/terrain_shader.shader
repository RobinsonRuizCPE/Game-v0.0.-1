Shader "Custom/terrain_shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _grassText ("Albedo (RGB)", 2D) = "white" {}
		_snowText("Albedo (RGB)", 2D) = "white" {}
		_rockText("Albedo (RGB)", 2D) = "white" {}
		_mudText("Albedo (RGB)", 2D) = "white" {}

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_maxAltitude("maxAltitude", Range(0,1000)) = 300.0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows vertex:vert

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 4.0

			sampler2D _grassText;
			sampler2D _snowText;
			sampler2D _rockText;
			sampler2D _mudText;

        struct Input
        {
            float2 uv_grassText;
			float2 uv_snowText;
			float2 uv_rockText;
			float2 uv_mudText;
			float3 worldPos;
			float3 vertexNormal; // This will hold the vertex normal
        };

        half _Glossiness;
        half _Metallic;
		half _maxAltitude;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertexNormal = abs(v.normal);
		}

		fixed3 interpolate_textures(Input IN) {
			//!\ Order is important
			
			// Standard grass. Plus c'est plat, plus c'est herbe
			fixed3 color_rgb = lerp(tex2D(_grassText, IN.uv_grassText), tex2D(_snowText, IN.uv_snowText), clamp((10*IN.worldPos.y / _maxAltitude)-8, 0.0, 1.0) );
					
			// River bed = standard grass + mud. Plus c'est plas plus c'est boueux
			if (IN.worldPos.y < 1) {
				return lerp(color_rgb, tex2D(_mudText, IN.uv_mudText), IN.vertexNormal.y);
			}

			if(IN.vertexNormal.y < 0.8)
				return lerp(color_rgb, tex2D(_rockText, IN.uv_rockText), clamp(2 - 3*IN.vertexNormal.y, 0.0, 1.0));

			return color_rgb;

		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {		
			fixed3 c = interpolate_textures(IN);
            // Albedo comes from a texture tinted by color
            
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 0.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
