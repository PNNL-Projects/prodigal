extern crate run_prodigal;
use std::process;

fn main() {
    let config = match run_prodigal::get_args() {
        Ok(c) => c,
        Err(e) => {
            println!("Error: {}", e);
            process::exit(1);
        }
    };

    if let Err(e) = run_prodigal::run(config) {
        println!("Error: {}", e);
        process::exit(1);
    }
}
