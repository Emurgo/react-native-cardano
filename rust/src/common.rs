use std::panic;

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