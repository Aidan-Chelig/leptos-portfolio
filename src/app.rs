pub mod pages;
use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use pages::*;
use rand::Rng;

#[component]
pub fn App() -> impl IntoView {
	// Provides context that manages stylesheets, titles, meta tags, etc.
	provide_meta_context();

	view! {
	  // injects a stylesheet into the document <head>
	  // id=leptos means cargo-leptos will hot-reload this stylesheet
	  //<Stylesheet id="leptos" href="style/tailwind.css"/>

	  // sets the document title
	  <Title text="Welcome to Leptos"/>

	  // content for this welcome page
	  <Router>
	  <main>
	  <Routes>
	  <Route path="" view=Home/>
	  <Route path="/*any" view=NotFound/>
	  </Routes>
	  </main>
	  </Router>
	}
}

/// 404 - Not Found
#[component]
fn NotFound() -> impl IntoView {
	// set an HTTP status code 404
	// this is feature gated because it can only be done during
	// initial server-side rendering
	// if you navigate to the 404 page subsequently, the status
	// code will not be set because there is not a new HTTP request
	// to the server
	//

	let mut rng = rand::thread_rng();

	let phraseNum: usize = rng.gen();
	let bumpNum: usize = rng.gen();
	const PHRASES: &'static [&'static str] = &[
		"What are you looking for?",
		"Wrong way!",
		"Alone, alone, alone, alone, alone, alone...",
		"https://en.wikipedia.org/wiki/HTTP_404",
		"Like watching paint dry",
		"?",
		"Nothing here",
	];

	let image = "/assets/404-bumpers/".to_string()
		+ &(bumpNum % 10).to_string()
		+ ".jpg";

	drop(rng);

	#[cfg(feature = "ssr")]
	{
		// this can be done inline because it's synchronous
		// if it were async, we'd use a server function
		let resp = expect_context::<leptos_actix::ResponseOptions>();
		resp.set_status(actix_web::http::StatusCode::NOT_FOUND);
	}

	view! {
	  <div class="h-screen flex flex-col items-center">
		  <h1>404</h1>
		  <img class="h-1/2 w-max" src=image />
		  <h2>{{PHRASES[phraseNum % PHRASES.len()]}}</h2>
	  </div>
	}
}
