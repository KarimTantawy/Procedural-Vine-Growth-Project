Shader "Unlit/DrawCircle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SingleFrag("Paint Single Pixel", float) = 1.0
        _Position("Position", Vector) = (0.0, 0.0, 0.0)
        _Color("Color", Color) = (1.0, 0.0, 0.0, 0.0)
        _Size("Brush Size", float) = 0.005
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Position;
            fixed4 _Color;
            float _Size;
            float _SingleFrag;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
        
                float draw = step(distance(i.uv, _Position.xy), _Size);

                fixed4 drawCol = _Color * draw;
                
                if(drawCol.a == 0.0 )
                    drawCol = col;

                return drawCol;
            }
            ENDCG
        }
    }
}
