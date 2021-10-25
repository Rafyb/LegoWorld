// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LegoFlo"
{
	Properties
	{
		_sccnbdnp_2K_Roughness("sccnbdnp_2K_Roughness", 2D) = "white" {}
		_sccnbdnp_2K_Normal("sccnbdnp_2K_Normal", 2D) = "white" {}
		_Roughness("Roughness", Range( 0 , 1)) = 1
		_Normal("Normal", Range( 0 , 1)) = 0
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _sccnbdnp_2K_Normal;
		uniform float4 _Tiling;
		uniform float _Normal;
		uniform sampler2D _sccnbdnp_2K_Roughness;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult8 = (float2(_Tiling.xy));
			float2 uv_TexCoord9 = i.uv_texcoord * appendResult8;
			o.Normal = UnpackScaleNormal( tex2D( _sccnbdnp_2K_Normal, uv_TexCoord9 ), _Normal );
			o.Albedo = i.vertexColor.rgb;
			float2 uv_TexCoord6 = i.uv_texcoord * appendResult8;
			o.Smoothness = ( tex2D( _sccnbdnp_2K_Roughness, uv_TexCoord6 ) * _Roughness ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
1920;515;827;484;1367.22;445.9389;2.358485;False;False
Node;AmplifyShaderEditor.Vector4Node;7;-1239.626,232.8893;Inherit;False;Property;_Tiling;Tiling;4;0;Create;True;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1024.626,237.8893;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-855.1544,67.68118;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-428,48;Inherit;True;Property;_sccnbdnp_2K_Roughness;sccnbdnp_2K_Roughness;0;0;Create;True;0;0;False;0;False;-1;f2f70718b3daba44abbf721d9cff03d4;f2f70718b3daba44abbf721d9cff03d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-893.9618,545.7984;Inherit;False;Property;_Normal;Normal;3;0;Create;True;0;0;False;0;False;0;0.398;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-786.6265,359.8893;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-118.7272,185.6279;Inherit;False;Property;_Roughness;Roughness;2;0;Create;True;0;0;False;0;False;1;0.571;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;8.942576,59.33399;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-497.057,345.7932;Inherit;True;Property;_sccnbdnp_2K_Normal;sccnbdnp_2K_Normal;1;0;Create;True;0;0;False;0;False;-1;f4d3e57cc3499334a9e0649a6fee3ae0;f4d3e57cc3499334a9e0649a6fee3ae0;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-126.552,-162.8836;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;11;94.38817,-269.8;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;250.5879,-12.12523;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LegoFlo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;6;0;8;0
WireConnection;1;1;6;0
WireConnection;9;0;8;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;2;1;9;0
WireConnection;2;5;5;0
WireConnection;0;0;11;0
WireConnection;0;1;2;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=4C987DED3044A629B8929BE0F85987E21DAD317B