use anyhow::Result;
use rand::Rng;
use rodio::{source::Source, Decoder, OutputStream};
use rodio::{Sink, SpatialSink};
use std::fs::File;
use std::io::{BufReader, Cursor};
use std::time::Duration;

fn main() -> Result<()> {
    let (_stream, stream_handle) = OutputStream::try_default()?;
    let sink = SpatialSink::try_new(
        &stream_handle,
        [0.0, 0.0, 0.0],
        [-1.0, -1.0, 0.0],
        [1.0, 1.0, 0.0],
    )?;

    let mut rng = rand::thread_rng();
    loop {
        let badoops_this_time = rng.gen_range(1..25);
        for _ in 1..badoops_this_time {
            let badoop = Decoder::new(Cursor::new(&include_bytes!("./boop.ogg")[..]))?;
            sink.set_emitter_position(rng.gen());
            sink.set_speed(rng.gen());
            sink.append(badoop);
            sink.sleep_until_end();
        }
        std::thread::sleep(Duration::from_millis(rng.gen_range(50..100000)));
    }
}
