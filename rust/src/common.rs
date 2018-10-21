use std::panic;

pub fn handle_exception<F: FnOnce() -> R + panic::UnwindSafe, R>(func: F) -> Result<R, String> {
  match panic::catch_unwind(func) {
    Ok(res) => Ok(res),
    Err(err) => Err(format!("{:?}", err))
  }
}