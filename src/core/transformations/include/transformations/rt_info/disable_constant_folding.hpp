// Copyright (C) 2018-2023 Intel Corporation
// SPDX-License-Identifier: Apache-2.0
//

#pragma once

#include <assert.h>

#include <functional>
#include <memory>
#include <set>
#include <string>
#include <transformations_visibility.hpp>

#include "openvino/pass/constant_folding.hpp"

namespace ov {

using pass::constant_folding_is_disabled;
using pass::disable_constant_folding;
using pass::DisableConstantFolding;
using pass::enable_constant_folding;

}  // namespace ov