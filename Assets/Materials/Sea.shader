// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sea"
{
	Properties
	{
		_Speed("Speed", Float) = 1
		_TilingWave("Tiling Wave", Float) = 1
		_Height("Height", Float) = 1
		_WaterColor("Water Color", Color) = (0.2352941,0.5372549,0.6980392,1)
		_TopColor("Top Color", Color) = (0.2862745,0.6862745,0.8235294,1)
		_EdgeDistance("Edge Distance", Float) = 1
		_EdgePower("Edge Power", Range( 0 , 1)) = 1
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalSpeed("Normal Speed", Float) = 1
		_TileNormal("Tile Normal", Float) = 1
		_NormalStrength("Normal Strength", Range( 0 , 1)) = 1
		_Transparence("Transparence", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _Height;
		uniform float _Speed;
		uniform float _TilingWave;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalMap);
		uniform float _NormalSpeed;
		uniform float _TileNormal;
		SamplerState sampler_NormalMap;
		uniform float _NormalStrength;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeDistance;
		uniform float _EdgePower;
		uniform float _Transparence;


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
			float3 ase_worldPos = i.worldPos;
			float4 appendResult10 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTiling11 = appendResult10;
			float4 temp_output_64_0 = ( WorldSpaceTiling11 * _TileNormal );
			float2 panner68 = ( 1.0 * _Time.y * ( float2( 1,0 ) * _NormalSpeed ) + temp_output_64_0.xy);
			float2 panner69 = ( 1.0 * _Time.y * ( float2( 1,0 ) * ( _NormalSpeed * 3.0 ) ) + ( temp_output_64_0 * ( _TileNormal * 5.0 ) ).xy);
			float3 Normals78 = BlendNormals( UnpackScaleNormal( SAMPLE_TEXTURE2D( _NormalMap, sampler_NormalMap, panner68 ), _NormalStrength ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _NormalMap, sampler_NormalMap, panner69 ), _NormalStrength ) );
			o.Normal = Normals78;
			float temp_output_7_0 = ( _Time.y * _Speed );
			float2 _Direction = float2(-1,0);
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
			float3 temp_cast_6 = (Edge55).xxx;
			o.Emission = temp_cast_6;
			o.Smoothness = 0.9;
			o.Alpha = _Transparence;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
201;73;1294;652;346.8166;-259.5952;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;12;-2989.555,-1102.55;Inherit;False;737;336;UV's World Space;3;9;10;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-2939.555,-1052.55;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;10;-2663.555,-1020.549;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2124.593,-1112.129;Inherit;False;1032.326;755.1362;Wave UV => Stretch + Tiling;6;13;15;14;17;16;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-2481.555,-1025.55;Float;True;WorldSpaceTiling;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;15;-2038.134,-740.8736;Inherit;True;Constant;_Stretch;Stretch;3;0;Create;True;0;0;False;0;False;0.15,0.02;0.25,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;13;-2074.591,-1062.129;Inherit;True;11;WorldSpaceTiling;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1826.615,-847.2516;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1769.234,-615.993;Inherit;True;Property;_TilingWave;Tiling Wave;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1584.227,-750.8572;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2923.623,48.76105;Inherit;False;1885.678;878.0542;Wave Pattern;13;31;5;6;25;32;4;7;27;3;28;1;30;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1316.264,-753.6154;Inherit;True;UVWave;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-2746.812,686.0102;Inherit;True;24;UVWave;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2555.619,580.6931;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2564.779,457.5572;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2382.714,502.2047;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2873.623,99.66077;Inherit;True;24;UVWave;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;4;-2431.945,173.5502;Inherit;False;Constant;_Direction;Direction;0;0;Create;True;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2391.808,690.6201;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;27;-1995.506,662.44;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1019.788,1159.112;Inherit;False;2477.287;983.627;Normal Map;19;67;65;66;63;61;62;41;68;64;71;70;72;75;74;73;69;76;77;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;3;-2133.204,102.714;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-950.5252,1209.113;Inherit;True;11;WorldSpaceTiling;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;28;-1754.36,658.487;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-918.6992,1525.47;Inherit;True;Property;_TileNormal;Tile Normal;9;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2924.547,1021.071;Inherit;False;1457.277;574.0266;Edge;7;51;50;52;53;58;55;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-313.2291,1582.836;Float;False;Property;_NormalSpeed;Normal Speed;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-1804.461,98.76105;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1433.836,492.1387;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2874.547,1200.85;Inherit;True;Property;_EdgeDistance;Edge Distance;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;70;-310.0711,1454.264;Float;False;Constant;_PanDirection;Pan Direction;8;0;Create;True;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-84.83234,1726.485;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-632.0051,1359.633;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-565.5121,1902.408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;71;-23.12179,1978.739;Float;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DepthFade;50;-2636.667,1071.071;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1044.949,-814.2869;Inherit;False;1128.737;442.3334;Wave Height;5;20;34;21;35;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;233.9272,-939.0765;Inherit;False;1155.21;712.4224;Waves Albedo;6;42;43;44;45;46;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-47.584,1433.578;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-239.8084,1884.213;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;186.8593,1983.851;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1222.453,745.3651;Inherit;False;PatternWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;68;158.7108,1356.149;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2560.186,1336.097;Float;True;Property;_EdgePower;Edge Power;6;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;20;-994.9487,-764.287;Inherit;False;Constant;_Ripple;Ripple;3;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;61;-969.7876,1796.908;Inherit;True;Property;_NormalMap;Normal Map;7;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;77;213.499,1641.654;Float;False;Property;_NormalStrength;Normal Strength;10;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;69;381.3217,1875.718;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;283.9272,-456.6542;Inherit;True;33;PatternWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-988.1021,-570.6954;Float;False;Property;_Height;Height;2;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-2371.352,1111.349;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-765.5062,-625.9532;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;41;579.9313,1394.489;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;False;0;False;-1;None;60e3bfc9f9fbdfc4abe9147480350232;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;42;640.1887,-889.0765;Inherit;False;Property;_WaterColor;Water Color;3;0;Create;True;0;0;False;0;False;0.2352941,0.5372549,0.6980392,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;46;655.2949,-456.654;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;640.1887,-692.6925;Inherit;False;Property;_TopColor;Top Color;4;0;Create;True;0;0;False;0;False;0.2862745,0.6862745,0.8235294,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;576.8152,1801.817;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;False;-1;None;60e3bfc9f9fbdfc4abe9147480350232;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-2194.338,1248.584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;978.8251,-635.4138;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;76;998.4993,1624.654;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;58;-1939.87,1246.45;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-404.6895,-617.3776;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-140.2113,-622.424;Inherit;True;HeightWave;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-1691.269,1241.019;Inherit;True;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;1233.499,1619.654;Float;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;1229.583,-639.2734;Inherit;True;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;191.4134,468.9562;Inherit;False;55;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;402.7467,325.2183;Inherit;False;47;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;343.1834,670.5952;Float;False;Property;_Transparence;Transparence;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;198.4817,564.4848;Inherit;False;Constant;_Roughness;Roughness;4;0;Create;True;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;190.9489,380.7003;Inherit;False;78;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;260.3875,836.481;Inherit;False;Constant;_Tesselation;Tesselation;3;0;Create;True;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-14.00942,705.6934;Inherit;True;36;HeightWave;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;572.5424,424.4799;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Sea;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;1
WireConnection;10;1;9;3
WireConnection;11;0;10;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;24;0;16;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;32;0;31;0
WireConnection;27;0;32;0
WireConnection;27;2;4;0
WireConnection;27;1;7;0
WireConnection;3;0;25;0
WireConnection;3;2;4;0
WireConnection;3;1;7;0
WireConnection;28;0;27;0
WireConnection;1;0;3;0
WireConnection;30;0;1;0
WireConnection;30;1;28;0
WireConnection;74;0;73;0
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;66;0;65;0
WireConnection;50;0;51;0
WireConnection;72;0;70;0
WireConnection;72;1;73;0
WireConnection;67;0;64;0
WireConnection;67;1;66;0
WireConnection;75;0;71;0
WireConnection;75;1;74;0
WireConnection;33;0;30;0
WireConnection;68;0;64;0
WireConnection;68;2;72;0
WireConnection;69;0;67;0
WireConnection;69;2;75;0
WireConnection;52;0;50;0
WireConnection;21;0;20;0
WireConnection;21;1;34;0
WireConnection;41;0;61;0
WireConnection;41;1;68;0
WireConnection;41;5;77;0
WireConnection;46;0;45;0
WireConnection;62;0;61;0
WireConnection;62;1;69;0
WireConnection;62;5;77;0
WireConnection;53;0;52;0
WireConnection;53;1;54;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;44;2;46;0
WireConnection;76;0;41;0
WireConnection;76;1;62;0
WireConnection;58;0;53;0
WireConnection;35;0;21;0
WireConnection;35;1;30;0
WireConnection;36;0;35;0
WireConnection;55;0;58;0
WireConnection;78;0;76;0
WireConnection;47;0;44;0
WireConnection;0;0;48;0
WireConnection;0;1;80;0
WireConnection;0;2;57;0
WireConnection;0;4;40;0
WireConnection;0;9;81;0
WireConnection;0;11;37;0
WireConnection;0;14;19;0
ASEEND*/
//CHKSM=EC93433AF33174D22F87B074DDD0CFF9641368BD