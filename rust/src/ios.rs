use common::*;
use wallet_wasm::*;

use std::os::raw::{c_uchar, c_char};
use std::ffi::CString;
use std::panic;
use std::usize;

pub use constants::*;

fn handle_error<F: FnOnce() -> R + panic::UnwindSafe, R>(error: *mut*mut c_char, err_val: R, func: F) -> R {
  match handle_exception(func) {
    Ok(val) => val,
    Err(err) => {
      unsafe {
        *error = CString::new(err).unwrap().into_raw();
      }
      err_val
    }
  }
}

#[no_mangle]
pub extern "C" fn dealloc_string(ptr: *mut c_char) {
  dealloc_str(ptr);
}

#[no_mangle]
pub extern "C" fn wallet_from_enhanced_entropy_safe(
  entropy_ptr: *const c_uchar, entropy_size: usize,
  password_ptr: *const c_uchar, password_size: usize,
  out: *mut c_uchar,
  error: *mut*mut c_char
) -> usize {
  handle_error(error, usize::MAX, || {
    wallet_from_enhanced_entropy(entropy_ptr, entropy_size, password_ptr, password_size, out)
  })
}

#[no_mangle]
pub extern "C" fn xwallet_from_master_key_safe(
  input_ptr: *const c_uchar, output_ptr: *mut c_uchar, error: *mut*mut c_char
) -> i32 {
  handle_error(error, -1, || {
    xwallet_from_master_key(input_ptr, output_ptr)
  })
} 