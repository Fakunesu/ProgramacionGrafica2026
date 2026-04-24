// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_TimeScale("Time Scale", Float) = 1
		_Spacing("Spacing", Float) = 30
		_LineStrenght("Line Strenght", Float) = -0.3
		_SINMULT("SIN MULT", Float) = 1
		_Smoothness("Smoothness", Float) = 0.9
		_Metallic("Metallic", Float) = 0.2
		_SINADD("SIN ADD", Float) = 1
		_Opacity("Opacity", Float) = 0.3
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _TimeScale;
		uniform float _Spacing;
		uniform float _SINADD;
		uniform float _SINMULT;
		uniform float _LineStrenght;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color20 = IsGammaSpace() ? float4(0.05174385,0.0506853,0.1603774,0) : float4(0.004094651,0.003997874,0.02207366,0);
			o.Albedo = color20.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV11 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode11 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV11, 5.0 ) );
			float4 color13 = IsGammaSpace() ? float4(0.1523941,0,0.2358491,0) : float4(0.02016069,0,0.04539381,0);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			o.Emission = ( ( pow( fresnelNode11 , 1.0 ) * color13 ) + ( color13 * pow( ( ( sin( ( ( ase_vertex3Pos.y + ( _Time.y * _TimeScale ) ) * _Spacing ) ) + _SINADD ) * _SINMULT ) , _LineStrenght ) ) ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
252;73;1250;610;4288.563;-27.96558;2.34627;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-2801.185,864.3;Inherit;False;386.2024;243.2544;Velocidad de animacion del efecto;3;19;2;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-2668.925,610.0189;Inherit;False;539.2294;237.3474;Posicion del vertice para distribui el patron sobre el objeto en el eje Y;2;4;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-2751.185,915.3001;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2732.797,991.5544;Inherit;False;Property;_TimeScale;Time Scale;0;0;Create;True;0;0;0;False;0;False;1;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2095.42,653.6005;Inherit;False;393.998;279.5922;Ajusta la separacion entre las lineas del patron;2;6;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-2576.983,914.3;Inherit;False;2;2;0;FLOAT;3;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;4;-2639.108,658.9272;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2045.417,818.1929;Inherit;False;Property;_Spacing;Spacing;1;0;Create;True;0;0;0;False;0;False;30;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-2332.847,707.2748;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1863.419,703.6006;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;33;-1410.005,652.6666;Inherit;False;556.8133;310.5039;Convierte la onda en valores positivos desplazando el rango ;4;9;10;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1650.8,652.7667;Inherit;False;200;161;Onda repetida crea lineas;1;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1374.005,827.1708;Inherit;False;Property;_SINADD;SIN ADD;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-1600.8,702.7669;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;34;-823.5814,655.4661;Inherit;False;390.791;274.8615;Endurece contraste para lineas mas definidas;2;12;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1197.898,827.1706;Inherit;False;Property;_SINMULT;SIN MULT;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-1393.161,97.37605;Inherit;False;459.0056;257;Calcula y ajusta brillo en bordes del objeto;2;11;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1211.698,702.6669;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-773.5814,814.3276;Inherit;False;Property;_LineStrenght;Line Strenght;2;0;Create;True;0;0;0;False;0;False;-0.3;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1015.192,703.0669;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-916.1896,350.9923;Inherit;False;638.5956;262;Aplica el color al patron de las ondas y al efecto del borde;2;13;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;11;-1343.161,147.3761;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-1111.156,147.3761;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-609.7904,705.4661;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-866.1896,400.9923;Inherit;False;Constant;_GlowColor;GlowColor;0;0;Create;True;0;0;0;False;0;False;0.1523941,0,0.2358491,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1;-542.3156,96.74817;Inherit;False;212;185;Edge Glow;1;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-439.594,407.2162;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-492.3157,146.7482;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-228.6105,-49.21317;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.05174385,0.0506853,0.1603774,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-145.7394,146.4439;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-162.863,454.103;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-149.5626,370.2029;Inherit;False;Property;_Metallic;Metallic;5;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-144.9133,538.1948;Inherit;False;Property;_Opacity;Opacity;7;0;Create;True;0;0;0;False;0;False;0.3;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;85.13346,99.76744;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;19;0
WireConnection;3;1;2;0
WireConnection;5;0;4;2
WireConnection;5;1;3;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;8;0;7;0
WireConnection;9;0;8;0
WireConnection;9;1;25;0
WireConnection;10;0;9;0
WireConnection;10;1;26;0
WireConnection;15;0;11;0
WireConnection;14;0;10;0
WireConnection;14;1;12;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;16;0;15;0
WireConnection;16;1;13;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;0;0;20;0
WireConnection;0;2;18;0
WireConnection;0;3;21;0
WireConnection;0;4;22;0
WireConnection;0;9;23;0
ASEEND*/
//CHKSM=473403CD3113670A4909C9DC668807865ADAB6F7