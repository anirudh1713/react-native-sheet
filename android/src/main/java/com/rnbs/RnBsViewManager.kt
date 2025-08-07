package com.rnbs

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.RnBsViewManagerInterface
import com.facebook.react.viewmanagers.RnBsViewManagerDelegate

@ReactModule(name = RnBsViewManager.NAME)
class RnBsViewManager : SimpleViewManager<RnBsView>(),
  RnBsViewManagerInterface<RnBsView> {
  private val mDelegate: ViewManagerDelegate<RnBsView>

  init {
    mDelegate = RnBsViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<RnBsView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): RnBsView {
    return RnBsView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: RnBsView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "RnBsView"
  }
}
