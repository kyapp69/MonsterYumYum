﻿Shader "Custom/GuySkin" 
{

	Properties
	{
		[PerRendererData] _MainTex ( "Sprite Texture", 2D ) = "white" {}
		_ColorMask ( "Color Mask", 2D ) = "white" {}
		_SkinColor ("SkinColor", Color) = ( 1, 1, 1, 1 )
		_TeethColor ( "TeethColor", Color ) = ( 1, 1, 1, 1 )
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _SkinColor;
			fixed4 _TeethColor;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _ColorMask;

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed4 mask = tex2D( _ColorMask, IN.texcoord );
				fixed4 c = tex2D(_MainTex, IN.texcoord) * IN.color * lerp( _TeethColor, _SkinColor, mask.a );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
}
