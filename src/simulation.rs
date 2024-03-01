use leptos_workers;

#[worker(MyChannelWorker)]
pub fn worker(
	rx: leptos_workers::Receiver<MyRequest>,
	tx: leptos_workers::Sender<MyResponse>,
) {
}
