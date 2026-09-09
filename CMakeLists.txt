project(Vanilla-Engine-Citrus)
cmake_minimum_required(VERSION  3.10.2)
enable_language(C CXX ASM)
if(APPLE)
    enable_language(OBJCXX)
endif()

# Install custom module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

option(XASH_DEDICATED "Enable dedicated build. Servers must choose this." OFF) # Servers must choose this

set(HLSDK_PATH ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Path to hlsdk")
set(HL2SDK_PATH ${CMAKE_CURRENT_SOURCE_DIR}/SourceSDK CACHE PATH "Path to hl2sdk")
include(cmake/platform_config.cmake)
include(cmake/video_config.cmake)

# Desktop or dedicated version options
if(XASH_DEDICATED)
	option(XASH_SDL "Enable SDL." OFF) # Dedicated servers still can use SDL
	option(XASH_SINGLE_BINARY "Don't build game launcher and build engine as executable" ON)
else()
	option(XASH_SDL "Enable SDL." ON)
	option(XASH_SINGLE_BINARY "Don't build game launcher and build engine as executable" OFF)
endif()

set(XASH_BUILD_COMMIT "${CMAKE_BUILD_POSTFIX}")
set(XASH_LIBDL true)
if(NOT ANDROID AND NOT IOS)
	option(XASH_ANGLE "Use OpenGL ES on desktop platforms" OFF) # use angle on desktop platforms
endif()

set(CMAKE_CXX_STANDARD 20)

if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.16.0")
	option(XASH_PCH "Enable PCH support." ON)
	option(XASH_UNITY_BUILD "Enable Unity Build support." OFF)
endif()

option(XASH_VCPKG "Enable VCPKG support." OFF)

if(XASH_DEDICATED)
	set(XASH_SDL  OFF) # Dedicated servers still can use SDL
else()
	option(XASH_SDL "Enable SDL." ON)
endif()
set(XASH_STATIC_GAMELIB ON)

if(XASH_PCH)
	if(${CMAKE_VERSION} VERSION_LESS "3.16.0")
		message(FATAL_ERROR "PCH is not supported. Please update to CMake 3.16 or higher.")
	endif()
	add_definitions(-DXASH_PCH=1)
endif()

if(XASH_UNITY_BUILD)
	if(${CMAKE_VERSION} VERSION_LESS "3.16.0")
		message(FATAL_ERROR "Unity build is not supported. Please update to CMake 3.16 or higher.")
	endif()
	add_definitions(-DXASH_UNITY_BUILD=1)
endif()

if(XASH_STATIC_GAMELIB)
	add_definitions(-DXASH_STATIC_GAMELIB=1)
endif()

if(NOT XASH_DEDICATED)
	option(XASH_IMGUI "ImGui support" OFF)
	option(XASH_VGUI2 "VGUI2 support" OFF)
	option(XASH_RAGDOLL "Bullet3 RagDoll support" OFF) # disable by default
else()
	set(XASH_IMGUI OFF)
	set(XASH_VGUI2 OFF)
	set(XASH_RAGDOLL OFF)
endif()

option(XASH_LUASH "Lua scripting support" OFF)

if (APPLE OR ANDROID)
	add_compile_options(-Wall -Wextra -Wno-unused-parameter -Wno-unused-variable -Wno-invalid-offsetof -Wno-format-security -Wno-missing-braces -Wno-missing-field-initializers)
elseif(MSVC)

else()
	add_compile_options( -Wall -Wextra -Wno-unused-parameter -Wl,--no-undefined )
endif()

# Important, as HLSDK and engine shares some symbol names!
if(NOT WIN32) # Windows by default have hidden visibility and better linker
	add_compile_options(-fvisibility=hidden)
endif()

if(CMAKE_COMPILER_IS_GNUCXX)
	add_compile_options(-Wpedantic)
endif()

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
	add_compile_options(-Wno-unused-private-field)
endif()


if(MSVC)
	# force xp build
	add_definitions(-D_USING_V110_SDK71_)

	# MultiByte charset
	add_compile_options(/utf-8)

	# static CRT
	if(XASH_STATIC_GAMELIB)
		set(CompilerFlags
			CMAKE_CXX_FLAGS
			CMAKE_CXX_FLAGS_DEBUG
			CMAKE_CXX_FLAGS_RELEASE
			CMAKE_CXX_FLAGS_MINSIZEREL
			CMAKE_CXX_FLAGS_RELWITHDEBINFO
			CMAKE_C_FLAGS
			CMAKE_C_FLAGS_DEBUG
			CMAKE_C_FLAGS_RELEASE
			CMAKE_C_FLAGS_MINSIZEREL
			CMAKE_C_FLAGS_RELWITHDEBINFO
			)
		foreach(CompilerFlag ${CompilerFlags})
		  string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
		endforeach()
	endif()
endif()

if(XASH_DEDICATED)
	add_definitions(-DXASH_DEDICATED)
endif()

if(APPLE)
	add_definitions(-DHAVE_STDINT_H)
endif()

set(XASH_64BIT PLATFORM_64BIT)

# Desktop or dedicated version options
if(XASH_DEDICATED)
	option(XASH_SDL "Enable SDL." OFF) # Dedicated servers still can use SDL
	option(XASH_SINGLE_BINARY "Don't build game launcher and build engine as executable" ON)
else()
	option(XASH_SDL "Enable SDL." ON)
	option(XASH_SINGLE_BINARY "Don't build game launcher and build engine as executable" OFF)
endif()

set(XASH_BUILD_COMMIT "${CMAKE_BUILD_POSTFIX}")
set(XASH_LIBDL true)

add_subdirectory(3rdparty EXCLUDE_FROM_ALL)

# Optional ImGui/Lua/VGUI layers are disabled for this vanilla build.

ADD_SUBDIRECTORY(SourceSDK)

# Vanilla game code is supplied by FWGS/hlsdk-portable at build time.
# The CSMoE game/client layer is intentionally not part of this project.
if(NOT EXISTS "${CMAKE_SOURCE_DIR}/external/hlsdk-portable/CMakeLists.txt")
    message(FATAL_ERROR "Vanilla HLSDK is missing. Run scripts/fetch_vanilla_hlsdk.sh first.")
endif()
add_subdirectory(external/hlsdk-portable)

if(NOT XASH_DEDICATED)
    ADD_SUBDIRECTORY(mainui_cpp)
endif()
ADD_SUBDIRECTORY(engine)
if(NOT XASH_SINGLE_BINARY AND NOT ANDROID AND NOT IOS)
	ADD_SUBDIRECTORY(game_launch)
endif()
