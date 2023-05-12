# Copyright (C) 2018-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

# enable LTO globally for all libraries below
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ${ENABLE_LTO})

add_definitions(-DIN_OV_CORE_LIBRARY)

set(OV_CORE_INCLUDE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/include)

if(CMAKE_COMPILER_IS_GNUCXX)
    ie_add_compiler_flags(-Wmissing-declarations)
endif()







add_subdirectory(dev_api)
add_subdirectory(builder)
add_subdirectory(reference)
add_subdirectory(shape_inference)
add_subdirectory(frontends)
add_subdirectory(inference)
add_subdirectory(transformations)


file(GLOB_RECURSE LIBRARY_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
file(GLOB_RECURSE LIBRARY_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp)
file(GLOB_RECURSE PUBLIC_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp)
set(NGRAPH_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)

source_group("src" FILES ${LIBRARY_SRC})
source_group("include" FILES ${LIBRARY_HEADERS})
source_group("public include" FILES ${LIBRARY_PUBLIC_HEADERS})

add_library(ngraph_obj OBJECT ${LIBRARY_SRC} ${LIBRARY_HEADERS} ${LIBRARY_PUBLIC_HEADERS})

target_include_directories(ngraph_obj
    PUBLIC
        $<BUILD_INTERFACE:${NGRAPH_INCLUDE_DIR}>
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_SOURCE_DIR}/transformations/include
        ${CMAKE_CURRENT_SOURCE_DIR}/inference/include
        ${CMAKE_CURRENT_SOURCE_DIR}/inference/src
        )
        

target_link_libraries(ngraph_obj PRIVATE ngraph::builder        
ngraph::reference openvino::util openvino::pugixml 
ov_shape_inference openvino::core::dev openvino::itt)
target_compile_definitions(ngraph_obj PRIVATE IMPLEMENT_OPENVINO_API )
target_compile_definitions(ngraph_obj PRIVATE CI_BUILD_NUMBER="${CI_BUILD_NUMBER}")

ie_mark_target_as_cc(ngraph_obj)



# set(MIXED_SRC
#     "${CMAKE_CURRENT_SOURCE_DIR}/src/runtime/allocator.cpp"
#     "${CMAKE_CURRENT_SOURCE_DIR}/src/runtime/itensor.cpp"
#     "${CMAKE_CURRENT_SOURCE_DIR}/src/runtime/ov_tensor.cpp")

# set_property(SOURCE ${MIXED_SRC}
#     APPEND PROPERTY INCLUDE_DIRECTORIES
#         ${OpenVINO_SOURCE_DIR}/src/core/inference/src)

# Create named folders for the sources within the .vcproj
# Empty name lists them directly under the .vcproj

# source_group("src" FILES ${LIBRARY_SRC})
# source_group("include" FILES ${PUBLIC_HEADERS})
# add_library(ngraph_obj OBJECT ${LIBRARY_SRC})

# target_include_directories(ngraph_obj, PUBLIC ${PUBLIC_HEADERS})
# target_link_libraries(ngraph_obj PRIVATE ngraph::builder        
# ngraph::reference openvino::util openvino::pugixml 
# ov_shape_inference openvino::core::dev)
# target_compile_definitions(ngraph_obj PRIVATE IMPLEMENT_OPENVINO_API)



# #
# # Add openvin::dev target
# #
# set(TARGET_NAME openvino)
# add_library(${TARGET_NAME}_dev INTERFACE)
# add_library(openvino::runtime::dev ALIAS ${TARGET_NAME}_dev)

# target_include_directories(${TARGET_NAME}_dev INTERFACE
#     $<BUILD_INTERFACE:${OpenVINO_SOURCE_DIR}/src/inference/dev_api>
#     $<BUILD_INTERFACE:${OpenVINO_SOURCE_DIR}/src/core/low_precision_transformations/include>
#     $<TARGET_PROPERTY:openvino_gapi_preproc,INTERFACE_INCLUDE_DIRECTORIES>)

# target_compile_definitions(${TARGET_NAME}_dev INTERFACE
#     $<TARGET_PROPERTY:openvino_gapi_preproc,INTERFACE_COMPILE_DEFINITIONS>)

# target_link_libraries(${TARGET_NAME}_dev INTERFACE ${TARGET_NAME} openvino::core::dev)

# set_ie_threading_interface_for(${TARGET_NAME}_dev)
# set_target_properties(${TARGET_NAME}_dev PROPERTIES EXPORT_NAME runtime::dev)
# openvino_developer_export_targets(COMPONENT core TARGETS openvino::runtime::dev)

# # Install static libraries for case BUILD_SHARED_LIBS=OFF

# ov_install_static_lib(${TARGET_NAME}_dev ${OV_CPACK_COMP_CORE})







# if(ENABLE_SYSTEM_PUGIXML)
#     set_target_properties(ngraph_obj PROPERTIES NO_SYSTEM_FROM_IMPORTED ON)
# endif()
# target_compile_definitions(ngraph_obj PRIVATE IMPLEMENT_OPENVINO_API)

# # ov_add_version_defines(src/version.cpp ngraph_obj)
# target_link_libraries(ngraph_obj PRIVATE ngraph::builder        
# ngraph::reference openvino::util openvino::pugixml 
# ov_shape_inference)


# target_link_libraries(ngraph_obj PRIVATE ngraph::builder        
# ngraph::reference openvino::util openvino::pugixml 
# ov_shape_inference openvino::core::dev)



# ie_mark_target_as_cc(ngraph_obj)

# ov_ncc_naming_style(FOR_TARGET ngraph_obj
#                     SOURCE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include")

# add_clang_format_target(ngraph_clang FOR_TARGETS ngraph_obj)

# if(NOT BUILD_SHARED_LIBS)
#     target_compile_definitions(ngraph_obj PUBLIC OPENVINO_STATIC_LIBRARY)
# endif()










# add_library(ngraph_obj OBJECT ${LIBRARY_SRC} ${PUBLIC_HEADERS})

# if(ENABLE_SYSTEM_PUGIXML)
#     set_target_properties(ngraph_obj PROPERTIES NO_SYSTEM_FROM_IMPORTED ON)
# endif()

# target_compile_definitions(ngraph_obj PRIVATE IMPLEMENT_OPENVINO_API)

# ov_add_version_defines(src/version.cpp ngraph_obj)

# target_link_libraries(ngraph_obj PRIVATE ngraph::builder        
# ngraph::reference openvino::util openvino::pugixml 
# ov_shape_inference openvino::core::dev)



# ie_mark_target_as_cc(ngraph_obj)

# ov_ncc_naming_style(FOR_TARGET ngraph_obj
#                     SOURCE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include")

# add_clang_format_target(ngraph_clang FOR_TARGETS ngraph_obj)

# if(NOT BUILD_SHARED_LIBS)
#     target_compile_definitions(ngraph_obj PUBLIC OPENVINO_STATIC_LIBRARY)
# endif()




# if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
#     # ngraph is linked against ngraph_builders, ngraph_reference, ov_shape_inference static libraries
#     # which include ngraph headers with dllimport attribute. Linker complains about it
#     # but no way to fix this: linking with no attribute defaults to dllexport and we have
#     # multiple defitions for ngraph symbols.
#     #
#     # The possible way is to use object libraries for ngraph_builders, ngraph_reference
#     # but it's not convinient since these libraries are exported from build tree
#     # and it's better to use them as static libraries in 3rd party projects
#     if(BUILD_SHARED_LIBS)
#         set(link_type PRIVATE)
#     else()
#         set(link_type PUBLIC)
#     endif()

#     target_link_options(ngraph_obj ${link_type} "/IGNORE:4217,4286")
# endif()

# # some sources are located in ngraph, while headers are in inference_engine_transformations
# file(GLOB_RECURSE smart_reshape_srcs ${CMAKE_CURRENT_SOURCE_DIR}/src/pass/smart_reshape/*.cpp)
# file(GLOB_RECURSE rt_info_srcs ${CMAKE_CURRENT_SOURCE_DIR}/src/pass/rt_info/*.cpp)
# set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/src/pass/convert_precision.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/pass/convert_fp32_to_fp16.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/pass/fix_rt_info.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/pass/init_node_info.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/pass/serialize.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/op/type_relaxed.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/preprocess/preprocess_steps_impl.cpp"
#                             "${CMAKE_CURRENT_SOURCE_DIR}/src/model.cpp" # for SmartReshape
#                             ${smart_reshape_srcs} ${rt_info_srcs}
#         PROPERTIES INCLUDE_DIRECTORIES $<TARGET_PROPERTY:inference_engine_transformations,INTERFACE_INCLUDE_DIRECTORIES>)
#     #  上述代码使用了CMake的`file()`和`set_source_files_properties()`命令来管理源文件。
#     # 首先，`file(GLOB_RECURSE variable [RELATIVE path] [globbing expressions]...)`命令会将所有匹配给定通配符表达式(globbing expressions)的源文件路径扫描到一个变量(variable)列表中，其中包括在指定目录(path)下的所有子目录。在这里，变量`smart_reshape_srcs`和`rt_info_srcs`分别存储了所有位于`${CMAKE_CURRENT_SOURCE_DIR}/src/pass/smart_reshape/*.cpp`和`${CMAKE_CURRENT_SOURCE_DIR}/src/pass/rt_info/*.cpp`路径下的源文件路径。

#     # 接着，`set_source_files_properties()`命令可以设置一组源文件的属性，如修改其编译标志、头文件搜索路径、依赖关系等，从而实现对源码的灵活管理。在这里，该命令设置了多个`.cpp`源文件的`INCLUDE_DIRECTORIES`属性值，以便它们可以访问`inference_engine_transformations`目标所公开的头文件路径列表。这些文件包括：

#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/pass/convert_precision.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/pass/convert_fp32_to_fp16.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/pass/fix_rt_info.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/pass/init_node_info.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/pass/serialize.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/op/type_relaxed.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/preprocess/preprocess_steps_impl.cpp"`
#     # - `"${CMAKE_CURRENT_SOURCE_DIR}/src/model.cpp"`（为SmartReshape准备）
#     # - 所有匹配 `${CMAKE_CURRENT_SOURCE_DIR}/src/pass/smart_reshape/*.cpp` 路径的源文件
#     # - 所有匹配`${CMAKE_CURRENT_SOURCE_DIR}/src/pass/rt_info/*.cpp`路径的源文件

#     # 注意，这里使用了 `$<TARGET_PROPERTY:inference_engine_transformations,INTERFACE_INCLUDE_DIRECTORIES>` 生成器表达式来获取 `inference_engine_transformations` 目标公开的头文件搜索路径列表，以便这些源文件能够引用该目标所包含的头文件。



# # Defines macro in C++ to load backend plugin
# target_include_directories(ngraph_obj PUBLIC $<BUILD_INTERFACE:${OV_CORE_INCLUDE_PATH}>
#                                       PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

# add_library(ngraph INTERFACE)
# target_link_libraries(ngraph INTERFACE openvino::runtime)
# # Add an alias so that library can be used inside the build tree, e.g. when testing
# add_library(openvino::core ALIAS ngraph)

# target_include_directories(ngraph INTERFACE $<BUILD_INTERFACE:${OV_CORE_INCLUDE_PATH}>)

# #-----------------------------------------------------------------------------------------------
# # Installation logic...
# #-----------------------------------------------------------------------------------------------

# install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
#         DESTINATION ${OV_CPACK_INCLUDEDIR}
#         COMPONENT ${OV_CPACK_COMP_CORE_DEV}
#         FILES_MATCHING
#             PATTERN "*.hpp"
#             PATTERN "*.h")

# configure_package_config_file(${OpenVINO_SOURCE_DIR}/cmake/templates/ngraphConfig.cmake.in
#     ${CMAKE_BINARY_DIR}/ngraphConfig.cmake
#     INSTALL_DESTINATION ${OV_CPACK_NGRAPH_CMAKEDIR})

# write_basic_package_version_file(${CMAKE_BINARY_DIR}/ngraphConfigVersion.cmake
#     VERSION ${OpenVINO_VERSION_MAJOR}.${OpenVINO_VERSION_MINOR}.${OpenVINO_VERSION_PATCH}
#     COMPATIBILITY SameMajorVersion)

# install(FILES ${CMAKE_BINARY_DIR}/ngraphConfig.cmake
#               ${CMAKE_BINARY_DIR}/ngraphConfigVersion.cmake
#         DESTINATION ${OV_CPACK_NGRAPH_CMAKEDIR}
#         COMPONENT ${OV_CPACK_COMP_CORE_DEV})