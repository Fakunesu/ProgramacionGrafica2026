// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterSurface"
{
	Properties
	{
		_pannerSpeed("pannerSpeed", Float) = 0
		_pannerUV("pannerUV", Vector) = (0,0,0,0)
		_tilling("tilling", Vector) = (0,0,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_distortionProportion("distortionProportion", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample0;
			uniform float2 _pannerUV;
			uniform float _pannerSpeed;
			uniform float2 _tilling;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _distortionProportion;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord21 = i.ase_texcoord1.xy * _tilling + float2( 0,0 );
				float2 uv_TextureSample1 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 tex2DNode23 = tex2D( _TextureSample1, uv_TextureSample1 );
				float2 appendResult24 = (float2(tex2DNode23.r , tex2DNode23.g));
				float2 lerpResult19 = lerp( texCoord21 , ( appendResult24 + texCoord21 ) , _distortionProportion);
				float2 panner13 = ( 1.0 * _Time.y * ( _pannerUV * _pannerSpeed ) + lerpResult19);
				
				
				finalColor = ( tex2D( _TextureSample0, panner13 ) + float4( 0,0,0,0 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
366;73;1098;609;2072.919;653.4672;2.459858;True;False
Node;AmplifyShaderEditor.CommentaryNode;29;-1927.347,-525.975;Inherit;False;836.1091;449.5714;Para el agua armé esto para que se pueda aplicar el art style del proyecto como ondas en el agua.;7;19;20;24;21;22;23;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;22;-1890.34,-281.7029;Inherit;False;Property;_tilling;tilling;5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;23;-1899.877,-475.9751;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-1796.811,76.73531;Inherit;False;549.1744;272.8795;Con esto se modifican las ondas en función de la textura de arriba.;3;14;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1679.133,-300.5211;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1595.311,-447.4303;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1624.075,-169.9746;Inherit;False;Property;_distortionProportion;distortionProportion;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1432.138,-391.749;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1712.029,253.904;Inherit;False;Property;_pannerSpeed;pannerSpeed;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-1699.561,113.6923;Inherit;False;Property;_pannerUV;pannerUV;4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;31;-1095.834,-65.87724;Inherit;False;1395.147;248.2;Esto es para aplicar el movimiento de ondas sobre la textura. El ADD está por si se quiere usar el Depth Fade. Usamos el Legacy/Unlit para fragmentar el color y poder aplicar Depth Fade.;4;1;3;4;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1479.199,174.3948;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;19;-1252.534,-291.3838;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1161.655,268.4347;Inherit;False;1072.276;328.8295;Si bien en la escena actual el barco no toca el agua, eventualmente debería tocarlo. Agregué esto para que se haga el efecto de "estar dentro".;1;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;13;-1045.834,52.06894;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1158.837,303.0544;Inherit;False;1067.773;287.7322;No lo conecto al ADD porque capaz no es lo que quiere el cliente.;8;6;5;10;9;12;11;7;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;4;-790.1877,-15.87724;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;12;-384.0671,350.3439;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-452.7074,-6.596584;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;11;-555.066,352.4914;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;6;-1133.345,361.9597;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1019.132,476.7446;Inherit;False;Property;_bias;bias;0;0;Create;True;0;0;0;False;0;False;1;4.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-885.9655,353.2914;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-545.0661,472.5473;Inherit;False;Property;_power;power;2;0;Create;True;0;0;0;False;0;False;0.01;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-726.1664,354.1914;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-681.8438,482.5804;Inherit;False;Property;_scale;scale;1;0;Create;True;0;0;0;False;0;False;0.3;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-241.3467,-4.312475;Float;False;True;-1;2;ASEMaterialInspector;100;1;WaterSurface;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;21;0;22;0
WireConnection;24;0;23;1
WireConnection;24;1;23;2
WireConnection;20;0;24;0
WireConnection;20;1;21;0
WireConnection;14;0;17;0
WireConnection;14;1;16;0
WireConnection;19;0;21;0
WireConnection;19;1;20;0
WireConnection;19;2;25;0
WireConnection;13;0;19;0
WireConnection;13;2;14;0
WireConnection;4;1;13;0
WireConnection;12;0;11;0
WireConnection;3;0;4;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;1;0;3;0
ASEEND*/
//CHKSM=98AD9BF540B83AD16A039FB03A7C17CA7B8F0E84