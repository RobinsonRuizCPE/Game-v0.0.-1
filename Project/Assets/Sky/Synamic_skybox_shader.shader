Shader "Unlit/Synamic_skybox_shader"
{
    Properties
    {
        _UpDay ("_UpDay", 2D) = "white" {}
        _DownDay("_DownDay", 2D) = "white" {}
		_LeftDay("_LeftDay", 2D) = "white" {}
		_RightDay("_RightDay", 2D) = "white" {}
		_FrontDay("_FrontDay", 2D) = "white" {}
		_BackDay("_BackDay", 2D) = "white" {}

		_UpNight("_UpNight", 2D) = "white" {}
		_DownNight("_DownNight", 2D) = "white" {}
		_LeftNight("_LeftNight", 2D) = "white" {}
		_RightNight("_RightNight", 2D) = "white" {}
		_FrontNight("_FrontNight", 2D) = "white" {}
		_BackNight("_BackNight", 2D) = "white" {}


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma geometry geom
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v3f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
            };
			sampler2D _UpDay;
			sampler2D _DownDay;
			sampler2D _LeftDay;
			sampler2D _RightDay;
			sampler2D _FrontDay;
			sampler2D _BackDay;

			sampler2D _UpNight;
			sampler2D _DownNight;
			sampler2D _LeftNight;
			sampler2D _RightNight;
			sampler2D _FrontNight;
			sampler2D _BackNight;

            float4 _MainTex_ST;

            v2f vert (appdata_full f)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(f.vertex);
                o.uv = TRANSFORM_TEX(f.texcoord, _MainTex);
				o.normal = f.normal;
                return o;
            }

			[maxvertexcount(4)]
			void geom(point v2g p[1], inout TriangleStream<g2f> tristream)
			{
				g2f o = (g2f)0;
				o.vertex = float4(0.1, 0.1, 0, 0);
				tristream.Append(o);
				o.vertex = float4(0.1, 0.9, 0, 0);
				tristream.Append(o);
				o.vertex = float4(0.9, 0.9, 0, 0);
				tristream.Append(o);
			}

            fixed4 frag (v3f i) : SV_Target
            {
				fixed4 col = tex2D(_UpDay, i.uv);
				// Up
			if (i.normal.y < 0.9) {
				col = lerp(tex2D(_UpDay, i.uv), tex2D(_UpNight, i.uv), abs(_SinTime.w));
			}
                // sample the texture
                return col;
            }
            ENDCG
        }
    }
}
