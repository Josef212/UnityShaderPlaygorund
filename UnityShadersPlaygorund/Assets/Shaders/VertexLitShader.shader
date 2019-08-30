Shader "Custom/VertexLitShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}
		SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityPBSLighting.cginc"

			fixed4 _Color;

			struct VertexData
			{
				float4 position : POSITION;
				float3 normal : NORMAL;
			};

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float3 color : COLOR;
			};

			Interpolators vert(VertexData v)
			{
				Interpolators ret;
				ret.position = UnityObjectToClipPos(v.position);

				float3 worldPos = mul(unity_ObjectToWorld, v.position);
				float normal = normalize(UnityObjectToWorldNormal(v.normal));
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);

				float3 lightColor = _LightColor0.rgb;
				float3 albedo = _Color.rgb;

				float3 diffuse = albedo * lightColor * DotClamped(lightDir, normal);
				ret.color = diffuse;

				return ret;
			}

			float4 frag(Interpolators i) : SV_TARGET
			{
				return float4(i.color, 1.0);
			}

		ENDCG
		}
	}
		FallBack "Diffuse"
}
