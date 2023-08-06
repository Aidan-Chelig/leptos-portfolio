use leptos::*;

#[component]
pub fn HomePage(cx: Scope) -> impl IntoView {
	// Creates a reactive value to update the button
	let (count, set_count) = create_signal(cx, 1f64);
	let on_click = move |_| set_count.update(|count| *count += *count - 2.);

	view! { cx,
		<h1>"homepage"</h1>
	}
}
