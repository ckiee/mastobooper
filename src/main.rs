use anyhow::Result;
use rand::Rng;
use rodio::{Decoder, OutputStream};
use rodio::{SpatialSink};

use std::io::{Cursor};
use std::time::Duration;
use clap::Parser;

/// Makes mastoboops and nyaas every so often.
#[derive(Parser, Debug)]
#[clap(author, version, about, long_about = None)]
struct Args {
    /// Whether to nyaa instead
    #[clap(short, long)]
    nya: bool,
}

static NYA: &[u8] = include_bytes!("./nya.ogg");
static BOOP: &[u8] = include_bytes!("./boop.ogg");

fn main() -> Result<()> {
    let args = Args::parse();

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
            let file = if args.nya { NYA } else { BOOP };
            let badoop = Decoder::new(Cursor::new(file))?;
            sink.set_emitter_position(rng.gen());
            sink.set_speed(if args.nya {
                rng.gen_range(0.6..1.0)
            } else {
                rng.gen()
            });
            sink.append(badoop);
            sink.sleep_until_end();
        }
        std::thread::sleep(Duration::from_millis(rng.gen_range(50..100000)));
    }
}
