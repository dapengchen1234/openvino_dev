add_definitions(-DPROJECT_ROOT_DIR="${OpenVINO_SOURCE_DIR}")
include(cmake/install_tbb.cmake)



# CC library should be registered before other cc targets
add_subdirectory(common)
add_subdirectory(core)
include(cmake/openvino.cmake)
add_subdirectory(frontend)
add_subdirectory(plugins)


# add_subdirectory(inference)
# include(cmake/openvino.cmake)

# # add_subdirectory(plugins)
