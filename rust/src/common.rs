use std::panic;
use cardano::util::{base58, hex};

pub fn handle_exception<F: FnOnce() -> R + panic::UnwindSafe, R>(func: F) -> Result<R, String> {
  match panic::catch_unwind(func) {
    Ok(res) => Ok(res),
    Err(err) => {
      if let Some(string) = err.downcast_ref::<String>() {
        return Err(string.clone());
      } else if let Some(string) = err.downcast_ref::<&'static str>() {
        return Err(string.to_string());
      }
      return Err(format!("Error: {:?}", err));
    }
  }
}

pub fn hide_exceptions() {
  panic::set_hook(Box::new(|_| {}));
}

pub fn convert_address_base58(addr: &str) -> String {
  let decoded = base58::decode(&addr).expect("Couldn't decode base58");
  format!("\"{}\"", hex::encode(&decoded))
}