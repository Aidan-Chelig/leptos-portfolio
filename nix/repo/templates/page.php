<?php $pagename = $argv[1]; ?>
use leptos::*;

#[component]
pub fn <?php echo $pagename; ?>() -> impl IntoView {

	view! {
		<h1>"<?php echo $pagename; ?>"</h1>
	}
}

