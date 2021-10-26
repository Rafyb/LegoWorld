// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sea"
{
	Properties
	{
		_Speed("Speed", Float) = 1
		_TilingWave("Tiling Wave", Float) = 1
		_Height("Height", Float) = 1
		_Roughness("Roughness", Float) = 0.28
		_Normal("Normal", 2D) = "bump" {}
		_WaterColor("Water Color", Color) = (0.2352941,0.5843138,0.7019608,0)
		_TopColor("Top Color", Color) = (0.2352941,0.5411765,0.7019608,1)
		_EdgeDistance("Edge Distance", Float) = 1
		_EdgePower("Edge Power", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _Height;
		uniform float _Speed;
		uniform float _TilingWave;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeDistance;
		uniform float _EdgePower;
		uniform float _Roughness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (8.0).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_7_0 = ( _Time.y * _Speed );
			float2 _Direction = float2(-1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult10 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTiling11 = appendResult10;
			float4 UVWave24 = ( ( WorldSpaceTiling11 * float4( float2( 0.15,0.02 ), 0.0 , 0.0 ) ) * _TilingWave );
			float2 panner3 = ( temp_output_7_0 * _Direction + UVWave24.xy);
			float simplePerlin2D1 = snoise( panner3 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner27 = ( temp_output_7_0 * _Direction + ( UVWave24 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D28 = snoise( panner27 );
			simplePerlin2D28 = simplePerlin2D28*0.5 + 0.5;
			float temp_output_30_0 = ( simplePerlin2D1 + simplePerlin2D28 );
			float3 HeightWave36 = ( ( float3(0,1,0) * _Height ) * temp_output_30_0 );
			v.vertex.xyz += HeightWave36;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float temp_output_7_0 = ( _Time.y * _Speed );
			float2 _Direction = float2(-1,0);
			float3 ase_worldPos = i.worldPos;
			float4 appendResult10 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTiling11 = appendResult10;
			float4 UVWave24 = ( ( WorldSpaceTiling11 * float4( float2( 0.15,0.02 ), 0.0 , 0.0 ) ) * _TilingWave );
			float2 panner3 = ( temp_output_7_0 * _Direction + UVWave24.xy);
			float simplePerlin2D1 = snoise( panner3 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner27 = ( temp_output_7_0 * _Direction + ( UVWave24 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D28 = snoise( panner27 );
			simplePerlin2D28 = simplePerlin2D28*0.5 + 0.5;
			float temp_output_30_0 = ( simplePerlin2D1 + simplePerlin2D28 );
			float PatternWave33 = temp_output_30_0;
			float clampResult46 = clamp( PatternWave33 , 0.0 , 1.0 );
			float4 lerpResult44 = lerp( _WaterColor , _TopColor , clampResult46);
			float4 Albedo47 = lerpResult44;
			o.Albedo = Albedo47.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth50 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth50 = abs( ( screenDepth50 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float clampResult58 = clamp( ( ( 1.0 - distanceDepth50 ) * _EdgePower ) , 0.0 , 1.0 );
			float Edge55 = clampResult58;
			float3 temp_cast_4 = (Edge55).xxx;
			o.Emission = temp_cast_4;
			o.Smoothness = _Roughness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
201;73;1294;652;2700.735;1105.65;1.422784;True;False
Node;AmplifyShaderEditor.CommentaryNode;12;-2989.555,-1102.55;Inherit;False;737;336;UV's World Space;3;9;10;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-2939.555,-1052.55;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;10;-2663.555,-1020.549;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2124.593,-1112.129;Inherit;False;1032.326;755.1362;Wave UV => Stretch + Tiling;6;13;15;14;17;16;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-2481.555,-1025.55;Float;True;WorldSpaceTiling;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;15;-2038.134,-740.8736;Inherit;True;Constant;_Stretch;Stretch;3;0;Create;True;0;0;False;0;False;0.15,0.02;0.25,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;13;-2074.591,-1062.129;Inherit;True;11;WorldSpaceTiling;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1769.234,-615.993;Inherit;True;Property;_TilingWave;Tiling Wave;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1826.615,-847.2516;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1584.227,-750.8572;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1316.264,-753.6154;Inherit;True;UVWave;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2923.623,48.76105;Inherit;False;1885.678;878.0542;Wave Pattern;13;31;5;6;25;32;4;7;27;3;28;1;30;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2477.869,484.4335;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2487.029,361.2974;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-2727.066,787.2053;Inherit;False;24;UVWave;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2873.623,99.66077;Inherit;True;24;UVWave;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2372.062,791.8152;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2304.964,405.9449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-2431.945,173.5502;Inherit;False;Constant;_Direction;Direction;0;0;Create;True;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;3;-2133.204,102.714;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-1995.506,662.44;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-1804.461,98.76105;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-1250.668,1059.362;Inherit;False;1457.277;574.0266;Edge;7;51;50;52;53;58;55;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;28;-1754.36,658.487;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1433.836,492.1387;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1200.668,1239.142;Inherit;False;Property;_EdgeDistance;Edge Distance;7;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1044.949,-814.2869;Inherit;False;1128.737;442.3334;Wave Height;5;20;34;21;35;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;233.9272,-939.0765;Inherit;False;1155.21;712.4224;Waves Albedo;6;42;43;44;45;46;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1261.945,487.442;Inherit;False;PatternWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;50;-962.7883,1109.362;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;20;-994.9487,-764.287;Inherit;False;Constant;_Ripple;Ripple;3;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;52;-697.4736,1149.641;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-886.3077,1374.389;Float;True;Property;_EdgePower;Edge Power;8;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;283.9272,-456.6542;Inherit;True;33;PatternWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-988.1021,-570.6954;Inherit;False;Property;_Height;Height;2;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;46;655.2949,-456.654;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;640.1887,-692.6925;Inherit;False;Property;_TopColor;Top Color;6;0;Create;True;0;0;False;0;False;0.2352941,0.5411765,0.7019608,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-520.4598,1286.876;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-765.5062,-625.9532;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;42;640.1887,-889.0765;Inherit;False;Property;_WaterColor;Water Color;5;0;Create;True;0;0;False;0;False;0.2352941,0.5843138,0.7019608,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-404.6895,-617.3776;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;44;978.8251,-635.4138;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;58;-265.993,1284.742;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-140.2113,-622.424;Inherit;False;HeightWave;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;1165.138,-637.9316;Inherit;True;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-17.39109,1279.31;Inherit;False;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;402.7467,325.2183;Inherit;False;47;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-14.00942,705.6934;Inherit;False;36;HeightWave;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;198.4817,564.4848;Inherit;False;Property;_Roughness;Roughness;3;0;Create;True;0;0;False;0;False;0.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;260.3875,835.2488;Inherit;False;Constant;_Tesselation;Tesselation;3;0;Create;True;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;191.4134,468.9562;Inherit;False;55;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-192.1161,350.1248;Inherit;True;Property;_Normal;Normal;4;0;Create;True;0;0;False;0;False;-1;60e3bfc9f9fbdfc4abe9147480350232;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;572.5424,424.4799;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Sea;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;1
WireConnection;10;1;9;3
WireConnection;11;0;10;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;24;0;16;0
WireConnection;32;0;31;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;3;0;25;0
WireConnection;3;2;4;0
WireConnection;3;1;7;0
WireConnection;27;0;32;0
WireConnection;27;2;4;0
WireConnection;27;1;7;0
WireConnection;1;0;3;0
WireConnection;28;0;27;0
WireConnection;30;0;1;0
WireConnection;30;1;28;0
WireConnection;33;0;30;0
WireConnection;50;0;51;0
WireConnection;52;0;50;0
WireConnection;46;0;45;0
WireConnection;53;0;52;0
WireConnection;53;1;54;0
WireConnection;21;0;20;0
WireConnection;21;1;34;0
WireConnection;35;0;21;0
WireConnection;35;1;30;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;44;2;46;0
WireConnection;58;0;53;0
WireConnection;36;0;35;0
WireConnection;47;0;44;0
WireConnection;55;0;58;0
WireConnection;0;0;48;0
WireConnection;0;1;41;0
WireConnection;0;2;57;0
WireConnection;0;4;40;0
WireConnection;0;11;37;0
WireConnection;0;14;19;0
ASEEND*/
//CHKSM=52096FCD8D4844AD4518092F81B93D7DF477CB2E