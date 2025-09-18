#pragma once

#include <react/debug/react_native_assert.h>
#include <react/renderer/components/RnBsViewSpec/Props.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include "RNBSSheetShadowNode.h"

namespace facebook {
namespace react {

class RNBSSheetComponentDescriptor final
    : public ConcreteComponentDescriptor<RNBSSheetShadowNode> {
 public:
  using ConcreteComponentDescriptor::ConcreteComponentDescriptor;

  void adopt(ShadowNode &shadowNode) const override {
    react_native_assert(dynamic_cast<RNBSSheetShadowNode *>(&shadowNode));
    auto &screenShadowNode = static_cast<RNBSSheetShadowNode &>(shadowNode);

    react_native_assert(
        dynamic_cast<YogaLayoutableShadowNode *>(&screenShadowNode));
    auto &layoutableShadowNode =
        dynamic_cast<YogaLayoutableShadowNode &>(screenShadowNode);

    auto state =
        std::static_pointer_cast<const RNBSSheetShadowNode::ConcreteState>(
            shadowNode.getState());
    auto stateData = state->getData();
    
    if (stateData.frameSize.width != 0 && stateData.frameSize.height != 0) {
      layoutableShadowNode.setSize(Size{stateData.frameSize.width, stateData.frameSize.height});
    }
    
    ConcreteComponentDescriptor::adopt(shadowNode);
  }
};

} // namespace react
} // namespace facebook
