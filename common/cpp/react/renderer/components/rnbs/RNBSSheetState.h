#pragma once

#include <react/renderer/core/graphicsConversions.h>
#include <react/renderer/graphics/Float.h>

#include "FrameCorrectionModes.h"

namespace facebook {
namespace react {

class JSI_EXPORT RNBSSheetState final {
public:
  using Shared = std::shared_ptr<const RNBSSheetState>;
  
  RNBSSheetState(){};
  RNBSSheetState(Size frameSize_): frameSize(frameSize_){};
  
  const Size frameSize{};
};

} // namespace react
} // namespace facebook
