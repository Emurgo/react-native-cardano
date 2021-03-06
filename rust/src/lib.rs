extern crate wallet_wasm;
extern crate cardano;

mod common;
mod constants;

#[cfg(target_os="android")]
extern crate jni;
#[cfg(target_os="android")]
mod android;
#[cfg(target_os="android")]
pub use self::android::*;

#[cfg(target_os="ios")]
mod ios;
#[cfg(target_os="ios")]
pub use self::ios::*;