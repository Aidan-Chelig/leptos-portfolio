use leptos::*;

#[component]
pub fn Home() -> impl IntoView {
	// Creates a reactive value to update the button
	let (count, set_count) = create_signal(0);
	let on_click = move |_| set_count.update(|count| *count += 1);

	view! {
		<h1 class="bg-red-300">"Welcome to Leptos!"</h1>
		<button on:click=on_click>"Click ntohign: " {count}</button>
	}
}
