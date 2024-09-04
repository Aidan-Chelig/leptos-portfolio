use leptos::*;

const ROLES: &'static [&'static str] = &[
	"Frontend",
	"Backend",
	"game dev",
	"digital signage",
	"nix consultant",
	"dev ops",
];

#[component]
pub fn Home() -> impl IntoView {
	// Creates a reactive value to update the button
	let (count, set_count) = create_signal(0);
	let on_click = move |_| set_count.update(|count| *count += 1);

	view! {
	   <div class="bg-black rounded-lg w-100% m-2 h-2/3 flex justify-items-center justify-center items-center">
		   <div>
			   <h1 class="text-4xl">Aidan Chelig</h1>
			   <hr class="mt-1"/>
			   <div>
	{ROLES.iter()
		 .intersperse( &" \u{2022} " )
			 .map(|role| {view! { <span class="uppercase">{*role}</span>}})
			 .collect_view()}
			   </div>
		   </div>
	   </div>
	   <button on:click=on_click>"Click to increment: " {count}</button>
	 }
}
