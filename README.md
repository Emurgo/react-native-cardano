
# react-native-cardano

## Getting started

You must include this module manually in your `package.json`, e.g.:

```
"dependencies": {
  ...
  "react-native-cardano": "https://github.com/Emurgo/react-native-cardano.git"
}
```

If you are using RN > 0.64.0 and failed to instll this library By following error 
```
npm ERR! Could not resolve dependency:
npm ERR! peer react-native@"^0.60.0" from react-native-cardano@0.2.4
```
Then install the package using below command.

```
npm install --legacy-peer-deps react-native-cardano@"https://github.com/Emurgo/react-native-cardano.git"
```

### Installing Rust

`$ curl https://sh.rustup.rs -sSf | sh`

Follow instructions. Restart Terminal application after installation (PATH should be updated)

#### Install Rust targets and tools for iOS

1. Install build targets: `$ rustup target add aarch64-apple-ios armv7-apple-ios armv7s-apple-ios x86_64-apple-ios i386-apple-ios`
2. Install `cargo-lipo` for building: `$ cargo install cargo-lipo`

#### Install Rust targets for Android

`$ rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android`

Android NDK should be installed for Android. Check that `local.properties` file in `android` folder has `ndk.dir` property and it's path is correct.

### Mostly automatic installation

`$ react-native link react-native-cardano`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-cardano` and add `RNCardano.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNCardano.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import io.crossroad.rnardano.CardanoPackage;` to the imports at the top of the file
  - Add `new CardanoPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-cardano'
  	project(':react-native-cardano').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-cardano/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-cardano')
  	```


## Usage
```javascript
import { Wallet, HdWallet, RandomAddressChecker, PasswordProtect } from 'react-native-cardano';

Wallet
  .checkAddress(
    "DdzFFzCqrhtCUjHyzgvgigwA5soBgDxpc8WfnG1RGhrsRrWMV8uKdpgVfCXGgNuXhdN4qxPMvRUtbUnWhPzxSdxJrWzPqACZeh6scCH5"
  )
  .then(isValid => console.log(isValid)); // Should print "true"
```

You can check all exported functions [there](index.d.ts).
