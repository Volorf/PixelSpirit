Shader "Pixel Spirit/Death"
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
                bool fac = step(0.5, (i.uv.y + i.uv.x) * 0.5);
                fixed4 col = fac ? _ForegroundColor : _BackgroundColor;
                return col;
            }
            ENDCG
        }
    }
}
