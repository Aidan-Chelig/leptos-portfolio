use leptos::*;
use rand::Rng;

const PHRASES: &'static [&'static str] = &[
	"What are you looking for?",
	"Wrong way!",
	"Alone, alone, alone, alone, alone, alone...",
	"https://en.wikipedia.org/wiki/HTTP_404",
	"Like watching paint dry",
	"?",
	"Nothing here",
	"Out of bounds!",
	"What are you doing back here?",
	"Employees only",
];

#[component]
pub fn NotFound() -> impl IntoView {
	let mut rng = rand::thread_rng();

	let phraseNum: usize = rng.gen();
	let bumpNum: usize = rng.gen();
	drop(rng);

	const PHRASES: &'static [&'static str] = &[
		"What are you looking for?",
		"Wrong way!",
		"Alone, alone, alone, alone, alone, alone...",
		"https://en.wikipedia.org/wiki/HTTP_404",
		"Like watching paint dry",
		"?",
		"Nothing here",
		"Out of bounds!",
	];

	let image = "/assets/404-bumpers/".to_string()
		+ &(bumpNum % 10).to_string()
		+ ".jpg";

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
		  <h2>{PHRASES[phraseNum % PHRASES.len()]}</h2>
	  </div>
	}
}
