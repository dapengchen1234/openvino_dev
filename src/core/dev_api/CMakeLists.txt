#
# Create ov_core_dev library
#

add_library(ov_core_dev INTERFACE)
add_library(openvino::core::dev ALIAS ov_core_dev)

target_include_directories(ov_core_dev INTERFACE
    $<BUILD_INTERFACE:${OV_CORE_INCLUDE_PATH}>
    $<BUILD_INTERFACE:${OpenVINO_SOURCE_DIR}/src/core/dev_api>
    $<BUILD_INTERFACE:${OpenVINO_SOURCE_DIR}/src/core/frontends/common/include>
    $<BUILD_INTERFACE:${OpenVINO_SOURCE_DIR}/src/common/transformations/include>)

target_link_libraries(ov_core_dev INTERFACE openvino::itt openvino::util)
set_target_properties(ov_core_dev PROPERTIES EXPORT_NAME core::dev)
openvino_developer_export_targets(COMPONENT core TARGETS openvino::core::dev)

# Install interface libraries for case BUILD_SHARED_LIBS=OFF
ov_install_static_lib(ov_core_dev ${OV_CPACK_COMP_CORE})