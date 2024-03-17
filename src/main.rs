#![feature(iter_intersperse)]
use leptos::*;
use leptos_portfolio::app::*;
use wasm_bindgen::prelude::wasm_bindgen;

pub fn main() {
	// a client-side main function is required for using `trunk serve`
	// prefer using `cargo leptos serve` instead
	// to run: `trunk serve --open --features csr`
	console_error_panic_hook::set_once();

	leptos::mount_to_body(App);
}
