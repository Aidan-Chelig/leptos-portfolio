use leptos::*;

#[component]
pub fn HomePage(cx: Scope) -> impl IntoView {
	// creates a reactive value to update the button
	view! { cx,
		<h1>"HomePage"</h1>
	}
}
