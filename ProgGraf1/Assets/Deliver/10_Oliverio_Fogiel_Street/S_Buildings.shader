// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Buildings"
{
	Properties
	{
		_BottomText("Bottom Text", 2D) = "white" {}
		_HeightCut("HeightCut", Float) = 20
		_TopText("Top Text", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _BottomText;
		uniform float4 _BottomText_ST;
		uniform sampler2D _TopText;
		uniform float4 _TopText_ST;
		uniform float _HeightCut;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BottomText = i.uv_texcoord * _BottomText_ST.xy + _BottomText_ST.zw;
			float2 uv_TopText = i.uv_texcoord * _TopText_ST.xy + _TopText_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float4 lerpResult29 = lerp( tex2D( _BottomText, uv_BottomText ) , tex2D( _TopText, uv_TopText ) , step( _HeightCut , ase_worldPos.y ));
			o.Albedo = lerpResult29.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
100;73;1718;826;2022.529;255.4624;1.671408;True;False
Node;AmplifyShaderEditor.CommentaryNode;34;-1141.101,370.4964;Inherit;False;687.1954;511.3993;Texturas asignadas a la parte superior e inferior del edificio;4;22;23;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1139.197,-4.611242;Inherit;False;604.4874;332.524;Con la posicion del objeto defino la altura por la cual cambia la textura;2;20;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-469.2861,77.33515;Inherit;False;490.0019;233.0678;Interpola entre la textura inferior y la posterior usando la altura;2;21;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-1089.197,144.9127;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;20;-722.1284,133.9734;Inherit;False;Property;_HeightCut;HeightCut;1;0;Create;True;0;0;0;False;0;False;20;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-1091.101,420.4964;Inherit;True;Property;_BottomText;Bottom Text;0;0;Create;True;0;0;0;False;0;False;None;184ccedeb0ae21a469fa5be557582df0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;23;-1090.103,651.8958;Inherit;True;Property;_TopText;Top Text;2;0;Create;True;0;0;0;False;0;False;None;46f2c18cd3e4a3e4aa1460c5ebf33d63;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StepOpNode;21;-419.2861,175.4029;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-773.9057,420.8964;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-775.9057,650.8958;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;-161.2842,127.3352;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;86.97421,127.9332;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;S_Buildings;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;20;0
WireConnection;21;1;31;2
WireConnection;26;0;22;0
WireConnection;25;0;23;0
WireConnection;29;0;26;0
WireConnection;29;1;25;0
WireConnection;29;2;21;0
WireConnection;0;0;29;0
ASEEND*/
//CHKSM=A6C0F66B6A86E747050F47BAE38778102C78504A