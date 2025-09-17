name=c938

directory_objects_base=objects
directory_output_base=output

directory_objects=${directory_objects_base}/release

ifeq (${debug}, 1)
	name:=${name}_debug
	directory_objects=${directory_objects_base}/debug
	directory_output=${directory_output_base}/debug
else
	directory_output=${directory_output_base}/release
endif

directory_include=include
directory_objects_c=${directory_objects}/c
directory_objects_objc=${directory_objects}/objc
directory_sources=sources
directory_storyboards=storyboards
directory_textures=textures

directory_cer0=../cer0
directory_cer0_include=${directory_cer0}/include
directory_cer0_library=${directory_cer0}/library

directory_clic3=../clic3
directory_clic3_include=${directory_clic3}/include
directory_clic3_library=${directory_clic3}/library

directory_interrupt_handler=../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include
directory_interrupt_handler_library=${directory_interrupt_handler}/library

directory_metil=../metil
directory_metil_include=${directory_metil}/include
ifeq (${debug}, 1)
	directory_metil_library=${directory_metil}/library_debug
else
	directory_metil_library=${directory_metil}/library
endif

directory_metal=metal
directory_air=air

directory_app=${directory_output}/${name}.app
directory_app_contents=${directory_app}/Contents
directory_app_contents_macos=${directory_app_contents}/MacOS
directory_app_contents_resources=${directory_app_contents}/Resources
directory_app_contents_resources_textures=${directory_app_contents_resources}/textures

directory_macos_sdk=${shell xcrun --show-sdk-path}

file_cer0_library=${directory_cer0_library}/cer0.o
file_clic3_library=${directory_clic3_library}/clic3.o
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler.o
ifeq (${debug}, 1)
	file_metil_library=${directory_metil_library}/metil_debug.o
else
	file_metil_library=${directory_metil_library}/metil.o
endif

file_info_plist=Info.plist
file_output=${directory_app_contents_macos}/${name}
file_output_info_plist=${directory_app_contents}/Info.plist
file_output_metal=${directory_app_contents_resources}/default.metallib

files_libraries=${file_cer0_library} ${file_clic3_library} ${file_interrupt_handler_library} ${file_metil_library}

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objc=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects_c}/%.o,${files_sources_c}}
files_objects_objc=${patsubst ${directory_sources}/%.m,${directory_objects_objc}/%.o,${files_sources_objc}}

files_metal=${wildcard ${directory_metal}/*.metal}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}

files_storyboards=${wildcard ${directory_storyboards}/*.storyboard}
files_storyboards_compiled=${patsubst ${directory_storyboards}/%.storyboard,${directory_app_contents_resources}/%.storyboardc,${files_storyboards}}

prefix_asset_texture=__asset_texture
prefix_asset_texture_always=${prefix_asset_texture}_always

files_assets_textures_names=concrete_1.png concrete_2.png concrete_3.png concrete_4.png concrete_5.png red_1.png red_2.png red_3.png red_4.png red_5.png
files_assets_textures=${addprefix ${prefix_asset_texture}/,${files_assets_textures_names}}
files_assets_textures_always=${addprefix ${prefix_asset_texture_always}/,${files_assets_textures_names}}

files_textures=${wildcard ${directory_textures}/*}
files_textures_resources=${patsubst ${directory_textures}/%,${directory_app_contents_resources_textures}/%,${files_textures}}

url_assets=https://content.alic3.dev/assets/${name}
url_assets_textures=${url_assets}/textures

target_device=mac
target_macos_version=15.0
target_macos_version_metal=${target_macos_version}
target_platform=arm64-apple-macos${target_macos_version}
target_platform_metal=air64-apple-macos${target_macos_version_metal}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_interrupt_handler_include} -I${directory_metil_include}
c_flags_platform=-target ${target_platform} -isysroot ${directory_macos_sdk}

c_flags_objc_debug=-O0 -g -v
c_flags_debug=${c_flags_objc_debug} -da -Q

c_flags_c=${c_flags_platform} ${c_flags_includes}
c_flags_objc=${c_flags_platform} ${c_flags_includes} -x objective-c -fmodules -fconstant-cfstrings -DTARGET_MACOS
c_flags_frameworks=${addprefix -framework ,${frameworks}}
c_flags_output=${c_flags_platform} ${c_flags_frameworks}

ifeq (${debug}, 1)
	c_flags_c:=${c_flags_c} ${c_flags_debug}
	c_flags_objc:=${c_flags_objc} ${c_flags_objc_debug}
	c_flags_output:=${c_flags_output} ${c_flags_objc_debug}
else
	c_flags_c:=${c_flags_c} -O3
	c_flags_objc:=${c_flags_objc} -O3
	c_flags_output:=${c_flags_output} -O3
endif

strip=strip
strip_flags=-x

metal=xcrun -sdk macosx metal
metal_flags_common=-target ${target_platform_metal}
metal_flags=${metal_flags_common} -I${directory_include} -I${directory_clic3_include} -I${directory_metil_include} -isysroot ${directory_macos_sdk}

ifneq (${disable_metal_fast_options}, 1)
	metal_flags:=${metal_flags} -fmetal-math-mode\=fast -fmetal-math-fp32-functions\=fast
endif

metal_flags_output=${metal_flags_common}

all: ${name}

run: .always
	${file_output}

${name}: ${file_output}

${file_output}: ${files_objects_c} ${files_objects_objc} ${file_output_metal} ${files_storyboards_compiled} ${file_output_info_plist} ${files_textures_resources}
	mkdir -p ${directory_app_contents_macos}
	${cc} ${c_flags_output} ${files_objects_c} ${files_objects_objc} ${files_libraries} -o ${file_output}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_output}
endif

${directory_app_contents_resources_textures}/%: ${directory_textures}/%
	mkdir -p ${directory_app_contents_resources_textures}
	cp $< $@

${file_output_metal}: ${files_air}
	mkdir -p ${directory_app_contents_resources}
	${metal} ${metal_flags_output} ${files_air} -o ${file_output_metal}

${directory_air}/%.air: ${directory_metal}/%.metal
	mkdir -p ${directory_air}
	${metal} ${metal_flags} -c $< -o $@

${directory_objects_c}/%.o: ${directory_sources}/%.c
	mkdir -p "${dir $@}"
	${cc} ${c_flags_c} -c $< -o $@

${directory_objects_objc}/%.o: ${directory_sources}/%.m
	mkdir -p "${dir $@}"
	${cc} ${c_flags_objc} -c $< -o $@

${directory_app_contents_resources}/%.storyboardc: ${directory_storyboards}/%.storyboard
	mkdir -p ${directory_app_contents_resources}
	ibtool --module ${name} --target-device ${target_device} --minimum-deployment-target ${target_macos_version} --output-format human-readable-text $< --compilation-directory ${directory_app_contents_resources}	

${file_output_info_plist}: ${file_info_plist}
	mkdir -p ${directory_app_contents}
	cp ${file_info_plist} ${file_output_info_plist}

pull_assets: ${directory_textures} ${files_assets_textures}

pull_assets_all: ${directory_textures} ${files_assets_textures_always}

${directory_textures}:
	mkdir -p ${directory_textures}

${prefix_asset_texture}/%:
	if [[ ! -f ${patsubst ${prefix_asset_texture}/%,${directory_textures}/%,$@} ]]; then curl ${patsubst ${prefix_asset_texture}/%,${url_assets_textures}/%,$@} -o ${patsubst ${prefix_asset_texture}/%,${directory_textures}/%,$@}; fi

${prefix_asset_texture_always}/%:
	curl ${patsubst ${prefix_asset_texture_always}/%,${url_assets_textures}/%,$@} -o ${patsubst ${prefix_asset_texture_always}/%,${directory_textures}/%,$@}

clean_all: clean

clean: clean_air clean_objects clean_output

clean_air:
	-rm -r ${directory_air}

clean_objects:
	-rm -r ${directory_objects_base}

clean_output:
	-rm -r ${directory_output_base}

.always:
