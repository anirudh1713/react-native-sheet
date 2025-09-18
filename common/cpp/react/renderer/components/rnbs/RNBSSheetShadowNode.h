#pragma once

#include <jsi/jsi.h>
#include <react/renderer/components/RnBsViewSpec/EventEmitters.h>
#include <react/renderer/components/RnBsViewSpec/Props.h>
#include <react/renderer/components/view/ConcreteViewShadowNode.h>
#include <react/renderer/core/LayoutContext.h>
#include "FrameCorrectionModes.h"
#include "RNBSSheetState.h"

namespace facebook {
namespace react {

JSI_EXPORT extern const char RNBSSheetComponentName[];

class JSI_EXPORT RNBSSheetShadowNode final : public ConcreteViewShadowNode<
                                                 RNBSSheetComponentName,
                                                 RnBsViewProps,
                                                 RnBsViewEventEmitter,
                                                 RNBSSheetState> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;
  
  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteViewShadowNode::BaseTraits();
    traits.set(ShadowNodeTraits::Trait::RootNodeKind);
    return traits;
  }
                                                   
};

}
}
