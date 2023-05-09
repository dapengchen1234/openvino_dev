# Copyright (C) 2018-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

# Usage: ie_option(<option_variable> "description" <initial value or boolean expression> [IF <condition>])

include (CMakeDependentOption)

if(POLICY CMP0127)
    cmake_policy(SET CMP0127 NEW)
endif()

macro (ie_option variable description value)
    option(${variable} "${description}" ${value})
    list(APPEND IE_OPTIONS ${variable})
endmacro()

# Usage: ov_option(<option_variable> "description" <initial value or boolean expression> [IF <condition>])
macro (ov_option variable description value)
    ie_option(${variable} "${description}" ${value})
endmacro()

macro (ie_dependent_option variable description def_value condition fallback_value)
    
    cmake_dependent_option(${variable} "${description}" ${def_value} "${condition}" ${fallback_value})
    list(APPEND IE_OPTIONS ${variable})
endmacro()

macro (ie_option_enum variable description value)
    set(OPTIONS)
    set(ONE_VALUE_ARGS)
    set(MULTI_VALUE_ARGS ALLOWED_VALUES)
    cmake_parse_arguments(IE_OPTION_ENUM "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT ${value} IN_LIST IE_OPTION_ENUM_ALLOWED_VALUES)
        message(FATAL_ERROR "variable must be one of ${IE_OPTION_ENUM_ALLOWED_VALUES}")
    endif()

    list(APPEND IE_OPTIONS ${variable})

    set(${variable} ${value} CACHE STRING "${description}")
    set_property(CACHE ${variable} PROPERTY STRINGS ${IE_OPTION_ENUM_ALLOWED_VALUES})
endmacro()

function (print_enabled_features)
    if(NOT COMMAND set_ci_build_number)
        message(FATAL_ERROR "CI_BUILD_NUMBER is not set yet")
    endif()

    message(STATUS "OpenVINO Runtime enabled features: ")
    message(STATUS "")
    message(STATUS "    CI_BUILD_NUMBER: ${CI_BUILD_NUMBER}")
    foreach(_var ${IE_OPTIONS})
        message(STATUS "    ${_var} = ${${_var}}")
    endforeach()
    message(STATUS "")
endfunction()


# 这段代码定义了一些辅助的CMake宏和函数，用于在CMake构建系统中方便地定义和使用选项。这些选项可以控制项目的行为，例如启用或禁用某些功能。

# 具体来说，这些宏包括：

# - `ie_option`：定义一个普通的CMake选项，即一个布尔变量，表示是否启用某个功能。
# - `ov_option`：与 `ie_option` 类似，但是将新定义的选项添加到 `IE_OPTIONS` 列表中，以备后续使用。
# - `ie_dependent_option`：定义一个有条件的选项，即根据其他选项的值来确定自身的默认值和可用性。
# - `ie_option_enum`：定义一个枚举类型的选项，即只能从几个预定义的值中选择一个。

# 此外还定义了一个打印所有已启用选项的函数 `print_enabled_features`。

# 这些宏和函数可以帮助开发人员更轻松地管理选项，并使得在构建时更容易支持不同的配置。生成函数的注释可以帮助其他开发人员理解这些宏和函数的作用，以及如何正确使用它们。