Shader "Pixel Spirit/TheStone"
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

            float fill(float x, float size)
            {
                return 1.0 - step(size, x);
            }

            float rectSDF(float2 st, float2 s)
            {
                st = st - 0.5;
                return max(abs(st.x/s.x), abs(st.y/s.y));
            }

            float crossSDF(float2 st, float s)
            {
                float2 size = float2(0.25, s);
                return min(rectSDF(st, size.xy), rectSDF(st, size.yx));
            }

            float flip (float v, float pct)
            {
                return lerp(v, 1-v, pct);
            }

            float vesicaSDF(float2 st, float w)
            {
                float2 offset = float2(w * 0.5, 0.0);
                return max (circleSDF(st - offset), circleSDF(st + offset));
            }

            float triSDF(float2 st)
            {
                st = (st * 2.0 - 1.0) * 2;
                return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
            }

            float rhombSDF(float2 st)
            {
                return max(triSDF(st), triSDF(float2(st.x, 1 - st.y)));
            }

            float2 rotate(float2 st, float a)
            {
                float2x2 mat = float2x2(cos(a), -sin(a), sin(a), cos(a));
                st = mul(mat, (st - 0.5));
                return st + 0.5;
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
                i.uv.xy = rotate(i.uv.xy, radians(45.0));
                float fac = fill( rectSDF(i.uv.xy, float2(1.0, 1.0)), 0.2);
                fac *= 1.0 - stroke(i.uv.x, 0.5, 0.03);
                fac *= 1.0 - stroke(i.uv.y, 0.5, 0.03);
                    
                fac = clamp(fac, 0, 1);
                
                fixed4 col = lerp(_BackgroundColor, _ForegroundColor, fac);
                return col;
            }
            
            ENDCG
        }
    }
}
