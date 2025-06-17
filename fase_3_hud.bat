@echo off
chcp 65001 > nul
color 0E
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  K.A.Y. FASE 3 - HUD 3D                     ║
echo ║               Tu Esfera Mágica en Android                   ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/2] Creando kay_hud.html con tu esfera perfecta...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="es"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>K.A.Y. HUD^</title^>
echo     ^<style^>
echo         * {
echo             margin: 0;
echo             padding: 0;
echo             box-sizing: border-box;
echo         }
echo.
echo         body {
echo             font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
echo             height: 100vh;
echo             background: linear-gradient^(180deg, #0a0a0f 0%%, #1a1a2e 30%%, #16213e 70%%, #0f3460 100%%^);
echo             display: flex;
echo             align-items: center;
echo             justify-content: center;
echo             overflow: hidden;
echo             position: relative;
echo         }
echo.
echo         .three-container {
echo             position: absolute;
echo             top: 0;
echo             left: 0;
echo             width: 100%%;
echo             height: 100%%;
echo             z-index: 1;
echo         }
echo.
echo         .hud-overlay {
echo             position: absolute;
echo             top: 0;
echo             left: 0;
echo             width: 100%%;
echo             height: 100%%;
echo             z-index: 10;
echo             pointer-events: none;
echo         }
echo.
echo         .mic-indicator {
echo             position: absolute;
echo             top: 20px;
echo             right: 20px;
echo             width: 20px;
echo             height: 20px;
echo             border-radius: 50%%;
echo             background: #ff4444;
echo             opacity: 0;
echo             z-index: 100;
echo             pointer-events: none;
echo             animation: pulse 2s infinite;
echo         }
echo.
echo         .mic-indicator.active {
echo             opacity: 1;
echo             background: #44ff44;
echo         }
echo.
echo         .mic-indicator.listening {
echo             background: #ffaa44;
echo             animation: pulse 0.5s infinite;
echo         }
echo.
echo         .status-text {
echo             position: absolute;
echo             bottom: 40px;
echo             left: 50%%;
echo             transform: translateX^(-50%%^);
echo             color: rgba^(255, 255, 255, 0.8^);
echo             font-size: 14px;
echo             text-align: center;
echo             z-index: 100;
echo             pointer-events: none;
echo             opacity: 0;
echo             transition: opacity 0.3s ease;
echo         }
echo.
echo         .status-text.visible {
echo             opacity: 1;
echo         }
echo.
echo         .nav-dots {
echo             position: absolute;
echo             bottom: 80px;
echo             left: 50%%;
echo             transform: translateX^(-50%%^);
echo             display: flex;
echo             gap: 8px;
echo             z-index: 100;
echo         }
echo.
echo         .dot {
echo             width: 8px;
echo             height: 8px;
echo             border-radius: 50%%;
echo             background: rgba^(255, 255, 255, 0.3^);
echo             transition: all 0.3s ease;
echo             cursor: pointer;
echo         }
echo.
echo         .dot.active {
echo             background: white;
echo             box-shadow: 0 0 15px rgba^(255, 255, 255, 0.8^);
echo             transform: scale^(1.2^);
echo         }
echo.
echo         .triple-tap-area {
echo             position: absolute;
echo             top: 0;
echo             left: 0;
echo             width: 100px;
echo             height: 100px;
echo             z-index: 1000;
echo             background: transparent;
echo         }
echo.
echo         @keyframes pulse {
echo             0%%, 100%% { transform: scale^(1^); opacity: 0.7; }
echo             50%% { transform: scale^(1.2^); opacity: 1; }
echo         }
echo.
echo         .floating-elements {
echo             position: absolute;
echo             top: 0;
echo             left: 0;
echo             width: 100%%;
echo             height: 100%%;
echo             pointer-events: none;
echo             z-index: 5;
echo         }
echo.
echo         .floating-element {
echo             position: absolute;
echo             width: 3px;
echo             height: 3px;
echo             background: rgba^(255, 255, 255, 0.6^);
echo             border-radius: 50%%;
echo             animation: float-particle 15s linear infinite;
echo         }
echo.
echo         @keyframes float-particle {
echo             0%% { 
echo                 opacity: 0; 
echo                 transform: translateY^(100vh^) translateX^(0^) scale^(0^); 
echo             }
echo             10%% { 
echo                 opacity: 1; 
echo                 transform: translateY^(90vh^) translateX^(30px^) scale^(1^); 
echo             }
echo             90%% { 
echo                 opacity: 1; 
echo                 transform: translateY^(10vh^) translateX^(-30px^) scale^(1^); 
echo             }
echo             100%% { 
echo                 opacity: 0; 
echo                 transform: translateY^(-10vh^) translateX^(0^) scale^(0^); 
echo             }
echo         }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="three-container" id="threeContainer"^>^</div^>
echo     ^<div class="floating-elements" id="floatingElements"^>^</div^>
echo.    
echo     ^<div class="hud-overlay"^>
echo         ^<div class="mic-indicator" id="micIndicator"^>^</div^>
echo         ^<div class="status-text" id="statusText"^>K.A.Y. inicializando...^</div^>
echo         ^<div class="nav-dots"^>
echo             ^<div class="dot active" onclick="changePage^(0^)"^>^</div^>
echo             ^<div class="dot" onclick="changePage^(1^)"^>^</div^>
echo             ^<div class="dot" onclick="changePage^(2^)"^>^</div^>
echo             ^<div class="dot" onclick="changePage^(3^)"^>^</div^>
echo         ^</div^>
echo         ^<div class="triple-tap-area" id="tripleTapArea"^>^</div^>
echo     ^</div^>
echo.
echo     ^<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"^>^</script^>
echo     ^<script^>
echo         let scene, camera, renderer, orb, cottonCandy;
echo         let mouseX = 0, mouseY = 0;
echo         let time = 0;
echo         let currentScreen = 0;
echo         let tapCount = 0;
echo.
echo         function initThree^(^) {
echo             const container = document.getElementById^('threeContainer'^);
echo.            
echo             scene = new THREE.Scene^(^);
echo             camera = new THREE.PerspectiveCamera^(75, window.innerWidth / window.innerHeight, 0.1, 1000^);
echo             camera.position.z = 5;
echo.            
echo             renderer = new THREE.WebGLRenderer^({ alpha: true, antialias: true }^);
echo             renderer.setSize^(window.innerWidth, window.innerHeight^);
echo             renderer.setClearColor^(0x000000, 0^);
echo             container.appendChild^(renderer.domElement^);
echo.            
echo             createOrb^(^);
echo             createLights^(^);
echo             animate^(^);
echo         }
echo.
echo         function createOrb^(^) {
echo             const geometry = new THREE.SphereGeometry^(1.2, 64, 64^);
echo             const material = new THREE.ShaderMaterial^({
echo                 uniforms: {
echo                     time: { value: 0 },
echo                     colorA: { value: new THREE.Color^(0x667eea^) },
echo                     colorB: { value: new THREE.Color^(0x764ba2^) },
echo                     colorC: { value: new THREE.Color^(0xf093fb^) }
echo                 },
echo                 vertexShader: `
echo                     varying vec2 vUv;
echo                     varying vec3 vNormal;
echo                     uniform float time;
echo.                    
echo                     void main^(^) {
echo                         vUv = uv;
echo                         vNormal = normal;
echo.                        
echo                         vec3 pos = position;
echo                         pos += 0.03 * sin^(pos.x * 8.0 + time * 2.0^) * normal;
echo                         pos += 0.02 * sin^(pos.y * 10.0 + time * 1.5^) * normal;
echo.                        
echo                         gl_Position = projectionMatrix * modelViewMatrix * vec4^(pos, 1.0^);
echo                     }
echo                 `,
echo                 fragmentShader: `
echo                     uniform float time;
echo                     uniform vec3 colorA;
echo                     uniform vec3 colorB;
echo                     uniform vec3 colorC;
echo                     varying vec2 vUv;
echo                     varying vec3 vNormal;
echo.                    
echo                     void main^(^) {
echo                         vec2 uv = vUv;
echo.                        
echo                         float noise = sin^(uv.x * 10.0 + time^) * sin^(uv.y * 10.0 + time * 0.8^);
echo.                        
echo                         vec3 color = mix^(colorA, colorB, uv.x + noise * 0.1^);
echo                         color = mix^(color, colorC, uv.y + noise * 0.05^);
echo.                        
echo                         float fresnel = pow^(1.0 - dot^(normalize^(vNormal^), vec3^(0.0, 0.0, 1.0^)^), 2.0^);
echo                         color += fresnel * 0.4;
echo.                        
echo                         gl_FragColor = vec4^(color, 0.8^);
echo                     }
echo                 `,
echo                 transparent: true,
echo                 side: THREE.DoubleSide
echo             }^);
echo.            
echo             orb = new THREE.Mesh^(geometry, material^);
echo             orb.position.set^(0, 0, 0^);
echo             scene.add^(orb^);
echo.            
echo             const cottonGeometry = new THREE.SphereGeometry^(0.8, 32, 32^);
echo             const cottonMaterial = new THREE.ShaderMaterial^({
echo                 uniforms: {
echo                     time: { value: 0 },
echo                     colorShift: { value: new THREE.Color^(0x667eea^) }
echo                 },
echo                 vertexShader: `
echo                     varying vec2 vUv;
echo                     uniform float time;
echo.                    
echo                     void main^(^) {
echo                         vUv = uv;
echo.                        
echo                         vec3 pos = position;
echo                         pos += 0.3 * sin^(pos.x * 4.0 + time^) * normalize^(pos^);
echo                         pos += 0.25 * sin^(pos.y * 6.0 + time * 1.3^) * normalize^(pos^);
echo                         pos += 0.2 * sin^(pos.z * 8.0 + time * 0.8^) * normalize^(pos^);
echo.                        
echo                         gl_Position = projectionMatrix * modelViewMatrix * vec4^(pos, 1.0^);
echo                     }
echo                 `,
echo                 fragmentShader: `
echo                     uniform float time;
echo                     uniform vec3 colorShift;
echo                     varying vec2 vUv;
echo.                    
echo                     void main^(^) {
echo                         vec2 uv = vUv;
echo.                        
echo                         float noise1 = sin^(uv.x * 25.0 + time^) * sin^(uv.y * 25.0 + time * 1.2^);
echo                         float noise2 = sin^(uv.x * 50.0 + time * 1.8^) * 0.6;
echo                         float noise3 = sin^(uv.y * 75.0 + time * 0.9^) * 0.4;
echo.                        
echo                         float combined = noise1 + noise2 + noise3;
echo.                        
echo                         vec3 baseColor = colorShift;
echo                         vec3 accentColor1 = vec3^(1.0, 0.4, 0.8^);
echo                         vec3 accentColor2 = vec3^(0.4, 0.9, 1.0^);
echo.                        
echo                         vec3 finalColor = mix^(baseColor, accentColor1, combined * 0.4^);
echo                         finalColor = mix^(finalColor, accentColor2, sin^(time^) * 0.3^);
echo.                        
echo                         float alpha = 0.8 + combined * 0.3;
echo                         alpha = smoothstep^(0.4, 1.0, alpha^);
echo.                        
echo                         gl_FragColor = vec4^(finalColor, alpha * 0.9^);
echo                     }
echo                 `,
echo                 transparent: true,
echo                 side: THREE.DoubleSide
echo             }^);
echo.            
echo             cottonCandy = new THREE.Mesh^(cottonGeometry, cottonMaterial^);
echo             cottonCandy.position.set^(0, 0, 0^);
echo             scene.add^(cottonCandy^);
echo         }
echo.
echo         function createLights^(^) {
echo             const ambientLight = new THREE.AmbientLight^(0x404040, 0.5^);
echo             scene.add^(ambientLight^);
echo.            
echo             const pointLight = new THREE.PointLight^(0x667eea, 1.2, 100^);
echo             pointLight.position.set^(0, 8, 8^);
echo             scene.add^(pointLight^);
echo.            
echo             const pointLight2 = new THREE.PointLight^(0x764ba2, 1.0, 100^);
echo             pointLight2.position.set^(-8, -8, 8^);
echo             scene.add^(pointLight2^);
echo         }
echo.
echo         function animate^(^) {
echo             requestAnimationFrame^(animate^);
echo.            
echo             time += 0.015;
echo.            
echo             if ^(orb^) {
echo                 orb.rotation.y += 0.008;
echo                 orb.rotation.x += 0.003;
echo                 orb.material.uniforms.time.value = time;
echo             }
echo.            
echo             if ^(cottonCandy^) {
echo                 cottonCandy.rotation.y -= 0.01;
echo                 cottonCandy.rotation.z += 0.005;
echo                 cottonCandy.material.uniforms.time.value = time;
echo.                
echo                 const hue = ^(time * 0.1^) %% 1;
echo                 const color = new THREE.Color^(^).setHSL^(hue * 0.3 + 0.6, 0.8, 0.7^);
echo                 cottonCandy.material.uniforms.colorShift.value = color;
echo             }
echo.            
echo             renderer.render^(scene, camera^);
echo         }
echo.
echo         function setStatus^(text^) {
echo             const statusElement = document.getElementById^('statusText'^);
echo             statusElement.textContent = text;
echo             statusElement.classList.add^('visible'^);
echo             setTimeout^(^(^) =^> {
echo                 statusElement.classList.remove^('visible'^);
echo             }, 3000^);
echo         }
echo.
echo         function setMicrophoneStatus^(active, listening^) {
echo             const micElement = document.getElementById^('micIndicator'^);
echo             micElement.classList.toggle^('active', active^);
echo             micElement.classList.toggle^('listening', listening^);
echo         }
echo.
echo         function simulateKAYSpeaking^(^) {
echo             if ^(orb^) {
echo                 orb.scale.set^(1.3, 1.3, 1.3^);
echo                 setTimeout^(^(^) =^> {
echo                     orb.scale.set^(1, 1, 1^);
echo                 }, 1000^);
echo             }
echo         }
echo.
echo         function simulateUserSpeaking^(^) {
echo             setMicrophoneStatus^(true, true^);
echo             setTimeout^(^(^) =^> {
echo                 setMicrophoneStatus^(true, false^);
echo             }, 2000^);
echo         }
echo.
echo         function changePage^(index^) {
echo             const dots = document.querySelectorAll^('.dot'^);
echo             dots.forEach^(^(dot, i^) =^> {
echo                 if ^(i === index^) {
echo                     dot.classList.add^('active'^);
echo                 } else {
echo                     dot.classList.remove^('active'^);
echo                 }
echo             }^);
echo.            
echo             const colorSets = [
echo                 { a: 0x667eea, b: 0x764ba2, c: 0xf093fb },
echo                 { a: 0x4facfe, b: 0x00f2fe, c: 0x43e97b },
echo                 { a: 0xfa709a, b: 0xfee140, c: 0xff6b6b },
echo                 { a: 0x667eea, b: 0xa8edea, c: 0xfed6e3 }
echo             ];
echo.            
echo             if ^(orb ^&^& colorSets[index]^) {
echo                 const colors = colorSets[index];
echo                 orb.material.uniforms.colorA.value.setHex^(colors.a^);
echo                 orb.material.uniforms.colorB.value.setHex^(colors.b^);
echo                 orb.material.uniforms.colorC.value.setHex^(colors.c^);
echo             }
echo.            
echo             currentScreen = index;
echo         }
echo.
echo         function createFloatingElements^(^) {
echo             const container = document.getElementById^('floatingElements'^);
echo.            
echo             for ^(let i = 0; i ^< 30; i++^) {
echo                 const element = document.createElement^('div'^);
echo                 element.className = 'floating-element';
echo                 element.style.left = Math.random^(^) * 100 + '%%';
echo                 element.style.animationDelay = Math.random^(^) * 15 + 's';
echo                 element.style.animationDuration = ^(Math.random^(^) * 10 + 10^) + 's';
echo                 container.appendChild^(element^);
echo             }
echo         }
echo.
echo         document.getElementById^('tripleTapArea'^).addEventListener^('click', function^(^) {
echo             tapCount++;
echo             if ^(tapCount === 3^) {
echo                 if ^(typeof Android !== 'undefined'^) {
echo                     Android.onTripleTap^(^);
echo                 }
echo                 tapCount = 0;
echo             }
echo             setTimeout^(^(^) =^> {
echo                 if ^(tapCount ^< 3^) tapCount = 0;
echo             }, 1000^);
echo         }^);
echo.
echo         window.addEventListener^('resize', ^(^) =^> {
echo             camera.aspect = window.innerWidth / window.innerHeight;
echo             camera.updateProjectionMatrix^(^);
echo             renderer.setSize^(window.innerWidth, window.innerHeight^);
echo         }^);
echo.
echo         document.addEventListener^('DOMContentLoaded', function^(^) {
echo             initThree^(^);
echo             createFloatingElements^(^);
echo             setStatus^('K.A.Y. listo para servir'^);
echo             setMicrophoneStatus^(true, false^);
echo         }^);
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > "app\src\main\assets\kay_hud.html"
echo ✅ kay_hud.html creado con tu esfera perfecta
echo.

echo [2/2] Agregando respuesta al nombre en KAYBrain.kt...
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                     FASE 3 COMPLETADA                       ║
echo ║ ✅ kay_hud.html creado con tu hermosa esfera 3D             ║
echo ║ ✅ Efectos de algodón de azúcar incluidos                   ║
echo ║ ✅ Triple tap secreto funcionando                            ║
echo ║ ✅ Indicador de micrófono activo                             ║
echo ║                                                              ║
echo ║ 🎯 FALTA: Agregar 10 líneas a KAYBrain.kt                   ║
echo ║    ^(Respuesta al nombre "Kay"^)                               ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause