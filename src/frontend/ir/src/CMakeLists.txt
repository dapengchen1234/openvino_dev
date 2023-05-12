# Copyright (C) 2018-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#




set(TARGET_NAME "${FRONTEND_NAME_PREFIX}${OV_FRONTEND_NAME}${FRONTEND_NAME_SUFFIX}")

list(APPEND FRONTEND_NAMES ${OV_FRONTEND_NAME})
set(FRONTEND_NAMES "${FRONTEND_NAMES}" CACHE INTERNAL "" FORCE)
set(frontend_root_dir "${CMAKE_CURRENT_SOURCE_DIR}")

set(frontend_root_dir "${CMAKE_CURRENT_SOURCE_DIR}")
if(frontend_root_dir MATCHES ".*src$")
    get_filename_component(frontend_root_dir "${frontend_root_dir}" DIRECTORY)
endif()


file(GLOB_RECURSE LIBRARY_SRC ${frontend_root_dir}/src/*.cpp)

if (WIN32)
    # Remove linux specific files
    file(GLOB_RECURSE LIN_FILES ${frontend_root_dir}/src/os/lin/*.cpp
                                ${frontend_root_dir}/src/os/lin/*.hpp)
    list(REMOVE_ITEM LIBRARY_SRC "${LIN_FILES}")
else()
    # Remove windows specific files
    file(GLOB_RECURSE WIN_FILES ${frontend_root_dir}/src/os/win/*.cpp
                                ${frontend_root_dir}/src/os/win/*.hpp)
    list(REMOVE_ITEM LIBRARY_SRC "${WIN_FILES}")
endif()

file(GLOB_RECURSE LIBRARY_HEADERS ${frontend_root_dir}/src/*.hpp)
file(GLOB_RECURSE LIBRARY_PUBLIC_HEADERS ${frontend_root_dir}/include/*.hpp)


set(${TARGET_NAME}_INCLUDE_DIR ${frontend_root_dir}/include)

# Create named folders for the sources within the .vcproj
# Empty name lists them directly under the .vcproj

source_group("src" FILES ${LIBRARY_SRC})
source_group("include" FILES ${LIBRARY_HEADERS})
source_group("public include" FILES ${LIBRARY_PUBLIC_HEADERS})


# Disable all warnings for generated code
set_source_files_properties(${PROTO_SRCS} ${PROTO_HDRS} PROPERTIES COMPILE_OPTIONS -w GENERATED TRUE)

# Create library
add_library(${TARGET_NAME} ${LIBRARY_SRC} ${LIBRARY_HEADERS} ${LIBRARY_PUBLIC_HEADERS})

if(OV_FRONTEND_LINKABLE_FRONTEND)
    # create beautiful alias
    add_library(openvino::frontend::${OV_FRONTEND_NAME} ALIAS ${TARGET_NAME})
endif()

if(NOT BUILD_SHARED_LIBS)
    # override default function names
    target_compile_definitions(${TARGET_NAME} PRIVATE
        "-Dget_front_end_data=get_front_end_data_${OV_FRONTEND_NAME}"
        "-Dget_api_version=get_api_version_${OV_FRONTEND_NAME}")
endif()

target_include_directories(${TARGET_NAME}
        PUBLIC
            $<BUILD_INTERFACE:${${TARGET_NAME}_INCLUDE_DIR}>
        PRIVATE
            ${frontend_root_dir}/src
            ${CMAKE_CURRENT_BINARY_DIR})

message("target name is" ${TARGET_NAME})
# target_link_libraries(${TARGET_NAME} PUBLIC openvino::runtime)

target_link_libraries(${TARGET_NAME} PRIVATE openvino::pugixml openvino::core::dev)




# ov_add_library_version(${TARGET_NAME})


# ov_add_frontend(NAME ir
#                 FILEDESCRIPTION "FrontEnd to load OpenVINO IR file format"
#                 LINK_LIBRARIES openvino::pugixml
#                                # TODO: remove dependency below in CVS-69781
#                                openvino::runtime::dev)
