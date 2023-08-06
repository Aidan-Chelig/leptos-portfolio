<?php $pagename = $argv[1]; ?>
use leptos::*;

#[component]
pub fn <?php echo $pagename; ?>(cx: Scope) -> impl IntoView {
	// creates a reactive value to update the button
	view! { cx,
		<h1>"<?php echo $pagename; ?>"</h1>
	}
}
