// http://www.alanzucconi.com/2016/05/04/lcd-shader/

Shader "Custom/LcdShaderLit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _Pixels ("Pixels", Vector) = (10, 10, 0, 0)
        _LCDTex ("LCD (RGB)", 2D) = "white" {}
        _LCDPixels("LCD pixels", Vector) = (3, 3, 0, 0)

        _DistanceOne ("Distance of full effect", Float) = 0.5 // In metres
        _DistanceZero ("Distance of zero effect", Float) = 1 // In metres
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex, _LCDTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _Pixels, _LCDPixels;
        float _DistanceOne, _DistanceZero;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = round(IN.uv_MainTex * _Pixels.xy + 0.5) / _Pixels.xy;
            fixed4 a = tex2D(_MainTex, uv) * _Color;

            float2 uv_lcd = IN.uv_MainTex * _Pixels.xy / _LCDPixels;
            fixed4 d = tex2D(_LCDTex, uv_lcd);

            float dist = distance(_WorldSpaceCameraPos, IN.worldPos);
            float alpha = saturate((dist - _DistanceOne) / (_DistanceZero - _DistanceOne)); 
            
            o.Albedo = lerp(a * d, a, alpha);
            
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
