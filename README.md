
# react-native-cardano

## Getting started

`$ npm install react-native-cardano --save`

### Mostly automatic installation

`$ react-native link react-native-cardano`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-cardano` and add `RNCardano.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNCardano.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import io.crossroad.react-native-cardano.RNCardanoPackage;` to the imports at the top of the file
  - Add `new RNCardanoPackage()` to the list returned by the `getPackages()` method
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
import RNCardano from 'react-native-cardano';

// TODO: What to do with the module?
RNCardano;
```
  
