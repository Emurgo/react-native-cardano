use wallet_wasm::*;
use cardano;

use std::str;
use std::ptr;

// This is the interface to the JVM that we'll
// call the majority of our methods on.
use jni::JNIEnv;

// These objects are what you should use as arguments to your native function.
// They carry extra lifetime information to prevent them escaping this context
// and getting used after being GC'd.
use jni::objects::{JObject, JString};

// This is just a pointer. We'll be returning it from our function.
// We can't return one of the objects with lifetime information because the
// lifetime checker won't let us.
use jni::sys::{jbyteArray, jobject};

const MAX_OUTPUT_SIZE: usize = 4096;

mod password_encryption_parameter {
  pub const SALT_SIZE  : usize = 32;
  pub const NONCE_SIZE : usize = 12;
  pub const TAG_SIZE   : usize = 16;
}

fn json_string_to_object(env: &JNIEnv, data: &[u8]) -> jobject {
  let class = env.find_class("org/json/JSONObject").unwrap();
  let string = str::from_utf8(data).unwrap();
  let json = *env.new_string(string).expect("Couldn't create java string!");
  env.new_object(class, "(Ljava/lang/String;)V", &[json.into()]).unwrap().into_inner()
}

fn json_string_to_array(env: &JNIEnv, data: &[u8]) -> jobject {
  let class = env.find_class("org/json/JSONArray").unwrap();
  let string = str::from_utf8(data).unwrap();
  let json = *env.new_string(string).expect("Couldn't create java string!");
  env.new_object(class, "(Ljava/lang/String;)V", &[json.into()]).unwrap().into_inner()
}

fn json_object_to_string(env: &JNIEnv, obj: JObject) -> String {
  let jstr = env.call_method(obj, "toString", "()Ljava/lang/String;", &[]).unwrap().l().unwrap();
  env.get_string(jstr.into()).expect("Couldn't get java string!").into()
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWallet_fromEnhancedEntropy(
  env: JNIEnv, _: JObject, bytes: jbyteArray, password: JString
) -> jbyteArray {
  let input = env.convert_byte_array(bytes).unwrap();
  let pwd_str: String = env.get_string(password).expect("Couldn't get java string!").into();
  let pwd: &[u8] = pwd_str.as_bytes();
  let mut output = [0 as u8; cardano::hdwallet::XPRV_SIZE];

  wallet_from_enhanced_entropy(input.as_ptr(), input.len(), pwd.as_ptr(), pwd.len(), output.as_mut_ptr());

  env.byte_array_from_slice(&output).unwrap()
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_wallet_fromMasterKey(
  env: JNIEnv, _: JObject, bytes: jbyteArray
) -> jobject {
  let input = env.convert_byte_array(bytes).unwrap();
  let mut output = [0 as u8; MAX_OUTPUT_SIZE];

  let rsz = xwallet_from_master_key(input.as_ptr(), output.as_mut_ptr()) as usize;

  json_string_to_object(&env, &output[0..rsz])
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_wallet_newAccount(
  env: JNIEnv, _: JObject, params: JObject
) -> jobject {
  let string = json_object_to_string(&env, params);
  let input = string.as_bytes();
  let mut output = [0 as u8; MAX_OUTPUT_SIZE];

  let rsz = xwallet_account(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

  json_string_to_object(&env, &output[0..rsz])
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_randomAddressChecker_newChecker(
  env: JNIEnv, _: JObject, pkey: JObject
) -> jobject {
  let string = json_object_to_string(&env, pkey);
  let input = string.as_bytes();
  let mut output = [0 as u8; MAX_OUTPUT_SIZE];

  let rsz = random_address_checker_new(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

  json_string_to_object(&env, &output[0..rsz])
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_randomAddressChecker_checkAddresses(
  env: JNIEnv, _: JObject, params: JObject
) -> jobject {
  let string = json_object_to_string(&env, params);
  let input = string.as_bytes();
  let mut output = [0 as u8; MAX_OUTPUT_SIZE];

  let rsz = random_address_check(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

  json_string_to_array(&env, &output[0..rsz])
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_passwordProtect_encryptWithPassword(
  env: JNIEnv, _: JObject, password: JString, salt: jbyteArray, nonce: jbyteArray, data: jbyteArray
) -> jbyteArray {
  use self::password_encryption_parameter::*;

  let nsalt = env.convert_byte_array(salt).unwrap();
  let nnonce = env.convert_byte_array(nonce).unwrap();

  if nsalt.len() != SALT_SIZE { return ptr::null_mut(); }
  if nnonce.len() != NONCE_SIZE { return ptr::null_mut(); }
  
  let ndata = env.convert_byte_array(data).unwrap();

  let pwd_str: String = env.get_string(password).expect("Couldn't get java string!").into();
  let pwd: &[u8] = pwd_str.as_bytes();

  let result_size = ndata.len() + TAG_SIZE + NONCE_SIZE + SALT_SIZE;

  let mut output = Vec::with_capacity(result_size);

  let rsz = encrypt_with_password(
    pwd.as_ptr(), pwd.len(), nsalt.as_ptr(), nnonce.as_ptr(), ndata.as_ptr(), ndata.len(),
    output.as_mut_ptr()
  ) as usize;

  if rsz != result_size { return ptr::null_mut(); }

  env.byte_array_from_slice(&output).unwrap()
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_passwordProtect_decryptWithPassword(
  env: JNIEnv, _: JObject, password: JString, data: jbyteArray
) -> jbyteArray {
  use self::password_encryption_parameter::*;

  let ndata = env.convert_byte_array(data).unwrap();

  if (ndata.len() <= TAG_SIZE + NONCE_SIZE + SALT_SIZE) {
    return ptr::null_mut();
  }

  let pwd_str: String = env.get_string(password).expect("Couldn't get java string!").into();
  let pwd: &[u8] = pwd_str.as_bytes();

  let result_size = ndata.len() - TAG_SIZE - NONCE_SIZE - SALT_SIZE;

  let mut output = Vec::with_capacity(result_size);

  let rsz = decrypt_with_password(
    pwd.as_ptr(), pwd.len(), ndata.as_ptr(), ndata.len(),
    output.as_mut_ptr()
  ) as usize;

  if rsz != result_size { return ptr::null_mut(); }

  env.byte_array_from_slice(&output).unwrap()
}
