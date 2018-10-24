use wallet_wasm::*;
use common::*;
use constants::*;

use std::str;

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
use jni::sys::{jbyteArray, jobject, jint};

fn json_string_to_object<'a>(env: &'a JNIEnv, data: &[u8]) -> JObject<'a> {
  let class = env.find_class("org/json/JSONObject").unwrap();
  let string = str::from_utf8(data).unwrap();
  let json = *env.new_string(string).expect("Couldn't create java string!");
  env.new_object(class, "(Ljava/lang/String;)V", &[json.into()]).unwrap()
}

fn json_object_to_string(env: &JNIEnv, obj: JObject) -> String {
  let jstr = env.call_method(obj, "toString", "()Ljava/lang/String;", &[]).unwrap().l().unwrap();
  env.get_string(jstr.into()).expect("Couldn't get java string!").into()
}

fn return_result<'a>(env: &'a JNIEnv, res: Result<JObject<'a>, String>) -> jobject {
  let class = env.find_class("io/crossroad/rncardano/Result").unwrap();
  static METHOD: &str = "(Ljava/lang/Object;Ljava/lang/String;)V";
  match res {
    Ok(res) => env.new_object(class, METHOD, &[res.into(), JObject::null().into()]).unwrap().into_inner(),
    Err(error) => { 
      let jstr = *env.new_string(error).expect("Couldn't create java string!");
      env.new_object(class, METHOD, &[JObject::null().into(), jstr.into()]).unwrap().into_inner()
    }
  }
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_initLibrary(_env: JNIEnv, _: JObject) {
  hide_exceptions();
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWalletFromEnhancedEntropy(
  env: JNIEnv, _: JObject, entropy: jbyteArray, password: JString
) -> jobject {
  return_result(&env, handle_exception(|| {
      let input = env.convert_byte_array(entropy).unwrap();
      let pwd_str: String = env.get_string(password).expect("Couldn't get java string!").into();
      let pwd: &[u8] = pwd_str.as_bytes();
      let mut output = [0 as u8; XPRV_SIZE];

      let res = wallet_from_enhanced_entropy(input.as_ptr(), input.len(), pwd.as_ptr(), pwd.len(), output.as_mut_ptr());

      if res != 0 { panic!("Rust method error. Check entropy size.") }

      JObject::from(env.byte_array_from_slice(&output).unwrap())
    })
  )
}


#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWalletFromSeed(
  env: JNIEnv, _: JObject, seed: jbyteArray
) -> jobject {
  return_result(&env, handle_exception(|| {
      let input = env.convert_byte_array(seed).unwrap();

      if input.len() != SEED_SIZE {
        panic!("Wrong seed len {} should be {}", input.len(), SEED_SIZE);
      }

      let mut output = [0 as u8; XPRV_SIZE];

      wallet_from_seed(input.as_ptr(), output.as_mut_ptr());

      JObject::from(env.byte_array_from_slice(&output).unwrap())
    })
  )
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWalletToPublic(
  env: JNIEnv, _: JObject, pkey: jbyteArray
) -> jobject {
  return_result(&env, handle_exception(|| {
      let input = env.convert_byte_array(pkey).unwrap();

      if input.len() != XPRV_SIZE {
        panic!("Wrong XPrv len {} should be {}", input.len(), XPRV_SIZE);
      }

      let mut output = [0 as u8; XPUB_SIZE];

      wallet_to_public(input.as_ptr(), output.as_mut_ptr());

      JObject::from(env.byte_array_from_slice(&output).unwrap())
    })
  )
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWalletDerivePrivate(
  env: JNIEnv, _: JObject, pkey: jbyteArray, index: jint
) -> jobject {
  return_result(&env, handle_exception(|| {
      let input = env.convert_byte_array(pkey).unwrap();

      if input.len() != XPRV_SIZE {
        panic!("Wrong XPrv len {} should be {}", input.len(), XPRV_SIZE);
      }

      let mut output = [0 as u8; XPRV_SIZE];

      wallet_derive_private(input.as_ptr(), index as u32, output.as_mut_ptr());

      JObject::from(env.byte_array_from_slice(&output).unwrap())
    })
  )
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWalletDerivePublic(
  env: JNIEnv, _: JObject, pubKey: jbyteArray, index: jint
) -> jobject {
  return_result(&env, handle_exception(|| {
      let input = env.convert_byte_array(pubKey).unwrap();

      if input.len() != XPUB_SIZE {
        panic!("Wrong XPub len {} should be {}", input.len(), XPUB_SIZE);
      }

      if (index as u32) >= 0x80000000 {
        panic!("Cannot do public derivation with hard index");
      }

      let mut output = [0 as u8; XPUB_SIZE];

      let res = wallet_derive_public(input.as_ptr(), index as u32, output.as_mut_ptr());

      if !res {
        panic!("Can't derive public key");
      }

      JObject::from(env.byte_array_from_slice(&output).unwrap())
    })
  )
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_hdWalletSign(
  env: JNIEnv, _: JObject, pkey: jbyteArray, data: jbyteArray
) -> jobject {
  return_result(&env, handle_exception(|| {
      let xprv = env.convert_byte_array(pkey).unwrap();

      if xprv.len() != XPRV_SIZE {
        panic!("Wrong XPrv len {} should be {}", xprv.len(), XPRV_SIZE);
      }

      let input = env.convert_byte_array(data).unwrap();
      let mut output = [0 as u8; SIGNATURE_SIZE];

      wallet_sign(xprv.as_ptr(), input.as_ptr(), input.len(), output.as_mut_ptr());

      JObject::from(env.byte_array_from_slice(&output).unwrap())
    })
  )
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletFromMasterKey(
  env: JNIEnv, _: JObject, bytes: jbyteArray
) -> jobject {
  return_result(&env, handle_exception(|| {
    let input = env.convert_byte_array(bytes).unwrap();
    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = xwallet_from_master_key(input.as_ptr(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletFromDaedalusMnemonic(
  env: JNIEnv, _: JObject, mnemonics: JString
) -> jobject {
  return_result(&env, handle_exception(|| {
    let mstr: String = env.get_string(mnemonics).expect("Couldn't get java string!").into();
    let input: &[u8] = mstr.as_bytes();
    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = xwallet_create_daedalus_mnemonic(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletNewAccount(
  env: JNIEnv, _: JObject, params: JObject
) -> jobject {
  return_result(&env, handle_exception(|| {
    let string = json_object_to_string(&env, params);
    let input = string.as_bytes();
    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = xwallet_account(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletGenerateAddresses(
  env: JNIEnv, _: JObject, params: JObject
) -> jobject {
  return_result(&env, handle_exception(|| {
    let string = json_object_to_string(&env, params);
    let input = string.as_bytes();
    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = xwallet_addresses(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletCheckAddress(
  env: JNIEnv, _: JObject, address: JString
) -> jobject {
  return_result(&env, handle_exception(|| {
    let addr_str: String = env.get_string(address).expect("Couldn't get java string!").into();
    let addr: &[u8] = addr_str.as_bytes();

    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = xwallet_checkaddress(addr.as_ptr(), addr.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletSpend(
  env: JNIEnv, _: JObject, params: JObject, ilen: jint, olen: jint
) -> jobject {
  return_result(&env, handle_exception(|| {
    let string = json_object_to_string(&env, params);
    let input = string.as_bytes();

    let OUTPUT_SIZE = ((ilen as usize) + (olen as usize) + 1) * 4096;
    let mut output = Vec::with_capacity(OUTPUT_SIZE);

    let rsz = xwallet_spend(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_walletMove(
  env: JNIEnv, _: JObject, params: JObject, ilen: jint
) -> jobject {
  return_result(&env, handle_exception(|| {
    let string = json_object_to_string(&env, params);
    let input = string.as_bytes();

    let OUTPUT_SIZE = ((ilen as usize) + 1) * 4096;
    let mut output = Vec::with_capacity(OUTPUT_SIZE);

    let rsz = xwallet_spend(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_randomAddressCheckerNewChecker(
  env: JNIEnv, _: JObject, pkey: JString
) -> jobject {
  return_result(&env, handle_exception(|| {
    let string: String = env.get_string(pkey).expect("Couldn't get java string!").into();
    let input: &[u8] = string.as_bytes();
    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = random_address_checker_new(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_randomAddressCheckerCheckAddresses(
  env: JNIEnv, _: JObject, params: JObject
) -> jobject {
  return_result(&env, handle_exception(|| {
    let string = json_object_to_string(&env, params);
    let input = string.as_bytes();
    let mut output = [0 as u8; MAX_OUTPUT_SIZE];

    let rsz = random_address_check(input.as_ptr(), input.len(), output.as_mut_ptr()) as usize;

    json_string_to_object(&env, &output[0..rsz])
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_passwordProtectEncryptWithPassword(
  env: JNIEnv, _: JObject, password: JString, salt: jbyteArray, nonce: jbyteArray, data: jbyteArray
) -> jobject {
  return_result(&env, handle_exception(|| {
    let nsalt = env.convert_byte_array(salt).unwrap();
    let nnonce = env.convert_byte_array(nonce).unwrap();

    if nsalt.len() != SALT_SIZE { panic!("Wrong salt len {} should be {}", nsalt.len(), SALT_SIZE); }
    if nnonce.len() != NONCE_SIZE { panic!("Wrong nonce len {} should be {}", nnonce.len(), NONCE_SIZE) }
    
    let ndata = env.convert_byte_array(data).unwrap();

    let pwd_str: String = env.get_string(password).expect("Couldn't get java string!").into();
    let pwd: &[u8] = pwd_str.as_bytes();

    let result_size = ndata.len() + TAG_SIZE + NONCE_SIZE + SALT_SIZE;

    let mut output = Vec::with_capacity(result_size);

    let rsz = encrypt_with_password(
      pwd.as_ptr(), pwd.len(), nsalt.as_ptr(), nnonce.as_ptr(), ndata.as_ptr(), ndata.len(),
      output.as_mut_ptr()
    ) as usize;

    if rsz != result_size { panic!("Size mismatch {} should be {}", rsz, result_size) }

    JObject::from(env.byte_array_from_slice(&output).unwrap())
  }))
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern fn Java_io_crossroad_rncardano_Native_passwordProtectDecryptWithPassword(
  env: JNIEnv, _: JObject, password: JString, data: jbyteArray
) -> jobject {
  return_result(&env, handle_exception(|| {
    let ndata = env.convert_byte_array(data).unwrap();

    if ndata.len() <= TAG_SIZE + NONCE_SIZE + SALT_SIZE { 
      panic!("Wrong data len {} should be at least {}", ndata.len(), TAG_SIZE + NONCE_SIZE + SALT_SIZE + 1);
    }

    let pwd_str: String = env.get_string(password).expect("Couldn't get java string!").into();
    let pwd: &[u8] = pwd_str.as_bytes();

    let result_size = ndata.len() - TAG_SIZE - NONCE_SIZE - SALT_SIZE;

    let mut output = Vec::with_capacity(result_size);

    let rsz = decrypt_with_password(
      pwd.as_ptr(), pwd.len(), ndata.as_ptr(), ndata.len(),
      output.as_mut_ptr()
    ) as usize;

    if rsz != result_size { panic!("Size mismatch {} should be {}", rsz, result_size) }

    JObject::from(env.byte_array_from_slice(&output).unwrap())
  }))
}
