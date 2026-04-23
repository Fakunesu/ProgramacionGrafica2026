// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ghost_Surface"
{
	Properties
	{
		_Cuerpo("Cuerpo", 2D) = "white" {}
		_Tilling("Tilling", Vector) = (6,1,0,0)
		_Speed("Speed", Float) = 3
		_Face("Face", 2D) = "white" {}
		_Opacity("Opacity", Float) = 0.5
		_FaceColor("FaceColor", Color) = (1,1,1,0)
		_FaceEmission("FaceEmission", Float) = 1
		_ghostColor("ghostColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
		};

		uniform float4 _ghostColor;
		uniform float4 _FaceColor;
		uniform sampler2D _Face;
		uniform float4 _Face_ST;
		uniform sampler2D _Cuerpo;
		uniform float2 _Tilling;
		uniform float _Speed;
		uniform float _FaceEmission;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Face = i.uv_texcoord * _Face_ST.xy + _Face_ST.zw;
			float4 Face12 = ( _FaceColor * ( 1.0 - tex2D( _Face, uv_Face ) ) );
			float mulTime5 = _Time.y * _Speed;
			float4 appendResult8 = (float4(mulTime5 , 0.0 , 0.0 , 0.0));
			float4 tex2DNode13 = tex2D( _Cuerpo, ( float4( ( i.uv_texcoord * _Tilling ), 0.0 , 0.0 ) + appendResult8 ).xy );
			o.Albedo = ( _ghostColor * ( Face12 + tex2DNode13 ) ).rgb;
			o.Emission = ( Face12 * _FaceEmission ).rgb;
			o.Alpha = ( tex2DNode13 * _Opacity ).r;
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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
381;73;1152;640;943.3453;317.3925;1.3;False;False
Node;AmplifyShaderEditor.CommentaryNode;22;-1870.95,195.5361;Inherit;False;625.6538;254.0709;Movimiento de textura;3;1;8;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-1757.544,-821.3517;Inherit;False;1049.324;552.9119;Modificar color de la cara;5;7;12;9;6;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-1736.45,-500.3072;Inherit;True;Property;_Face;Face;3;0;Create;True;0;0;0;False;0;False;-1;9afd14c668dd15d4e8a021d9a86ef1e7;9afd14c668dd15d4e8a021d9a86ef1e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;23;-1750.195,-195.286;Inherit;False;440.7686;353.7639;Multiplicar textura en un eje;3;10;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-1840.358,251.226;Inherit;False;Property;_Speed;Speed;2;0;Create;True;0;0;0;False;0;False;3;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-1369.295,-494.4261;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-1403.061,-705.8064;Inherit;False;Property;_FaceColor;FaceColor;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1694.049,-124.2883;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1653.428,257.9419;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-1632.05,16.71177;Inherit;False;Property;_Tilling;Tilling;1;0;Create;True;0;0;0;False;0;False;6,1;10,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1109.955,-570.7482;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1405.894,257.9872;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1444.071,-53.37859;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-922.3828,-572.1219;Inherit;False;Face;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;24;-608.7698,-335.9851;Inherit;False;482.4447;350.7538;Agregar cara a la textura;2;16;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1246.37,-53.01676;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;13;-1052.971,-46.65157;Inherit;True;Property;_Cuerpo;Cuerpo;0;0;Create;True;0;0;0;False;0;False;-1;388640c64896078449d0ae8f088fe3c5;388640c64896078449d0ae8f088fe3c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;25;-616.3097,49.56501;Inherit;False;502.3616;302.8299;Hacer que la cara se ilumine;3;18;15;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-619.6775,373.0385;Inherit;False;456.189;286.3397;Modificar opacidad;2;20;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-586.0926,-222.6824;Inherit;False;12;Face;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-599.3931,476.4713;Inherit;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;0.5;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-118.8501,-212.664;Inherit;False;Property;_ghostColor;ghostColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-395.3812,-219.1718;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-549.8679,247.2715;Inherit;False;Property;_FaceEmission;FaceEmission;6;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-530.1583,100.7837;Inherit;False;12;Face;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-320.6361,113.8866;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-369.9269,421.0936;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;19.8539,-16.76255;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;175.8226,64.19123;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ghost_Surface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;2;0
WireConnection;5;0;1;0
WireConnection;9;0;7;0
WireConnection;9;1;6;0
WireConnection;8;0;5;0
WireConnection;10;0;4;0
WireConnection;10;1;3;0
WireConnection;12;0;9;0
WireConnection;11;0;10;0
WireConnection;11;1;8;0
WireConnection;13;1;11;0
WireConnection;19;0;16;0
WireConnection;19;1;13;0
WireConnection;18;0;15;0
WireConnection;18;1;14;0
WireConnection;20;0;13;0
WireConnection;20;1;17;0
WireConnection;27;0;28;0
WireConnection;27;1;19;0
WireConnection;0;0;27;0
WireConnection;0;2;18;0
WireConnection;0;9;20;0
ASEEND*/
//CHKSM=7C53BCCD17399C4898298FEB06A891C51F317ADF