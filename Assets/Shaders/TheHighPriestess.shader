Shader "Pixel Spirit/TheHighPriestess"
{
    Properties
    {
        _ForegroundColor ("Foreground Color", Color) = (1, 1, 1, 1)
        _BackgroundColor ("Background Color", Color) = (0.1, 0.1, 0.1, 1)
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

            #include "UnityCG.cginc"

            float4 _ForegroundColor;
            float4 _BackgroundColor;

            float stroke(float x, float s, float w)
            {
                float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
                return clamp(d, 0.0, 1.0);
            }

            float circleSDF(float2 st)
            {
                return length(st - 0.5) * 2;
            }
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                
                float fac = stroke(circleSDF(i.uv.xy), 0.5, 0.1);
                
                fixed4 col = lerp(_BackgroundColor, _ForegroundColor, fac);
                return col;
            }
            ENDCG
        }
    }
}
