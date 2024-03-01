pub mod pages;
use leptos::{leptos_dom::logging::console_log, *};
use leptos_meta::*;
use leptos_portfolio::simulation;
use leptos_router::*;
use pages::*;

#[component]
pub fn App() -> impl IntoView {
	// Provides context that manages stylesheets, titles, meta tags, etc.
	provide_meta_context();

	console_log("asdasasdasdsd");

	view! {
	  // injects a stylesheet into the document <head>
	  // id=leptos means cargo-leptos will hot-reload this stylesheet
	  //<Stylesheet id="leptos" href="style/tailwind.css"/>

	  // sets the document title
	  <Title text="Welcome to Leptos"/>

	  // content for this welcome page
	  <Router>
	  <main class="w-screen h-screen">
	  <Routes>
	  <Route path="" view=Home/>
	  <Route path="/*any" view=NotFound/>
	  </Routes>
	  </main>
	  </Router>
	}
}
