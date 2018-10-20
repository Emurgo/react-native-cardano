package io.crossroad.rncardano

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.facebook.react.bridge.JavaScriptModule

class CardanoPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf(
                HdWalletModule(reactContext),
                WalletModule(reactContext),
                PasswordProtect(reactContext),
                RandomAddressChecker(reactContext)
        )
    }

    // Deprecated from RN 0.47
    override fun createJSModules(): List<Class<out JavaScriptModule>> {
        return emptyList()
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }
}