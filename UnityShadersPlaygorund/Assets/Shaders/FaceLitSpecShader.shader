Shader "Custom/FaceLitSpecShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_AmbientStrength("Ambient", Range(0.0, 1.0)) = 0.1
		_Specular("Specular", Range(0.0, 1.0)) = 0.5
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
			float _AmbientStrength, _Specular;

			struct VertexData
			{
				float4 position : POSITION;
				float3 normal : NORMAL;
			};

			struct Interpolators
			{
				float4 position : SV_POSITION;
				nointerpolation float3 color : COLOR;
			};

			Interpolators vert(VertexData v)
			{
				Interpolators ret;
				ret.position = UnityObjectToClipPos(v.position);

				float3 worldPos = mul(unity_ObjectToWorld, v.position);
				float normal = normalize(UnityObjectToWorldNormal(v.normal));
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;

				float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);
				float3 reflectDir = reflect(-lightDir, normal);

				float3 ambient = _AmbientStrength * lightColor;
				
				float diff = DotClamped(lightDir, normal);
				float3 diffuse = diff * lightColor;

				float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
				float3 specular = _Specular * spec * lightColor;

				ret.color = (ambient + diffuse + specular) * _Color.rgb;

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
