extern crate clap;

use clap::{App, Arg};
use std::error::Error;
use std::io::Write;
use std::process::{Command, Stdio};
use std::{
    env,
    fs::{self, DirBuilder, File},
    path::{Path, PathBuf},
};

#[derive(Debug)]
pub struct Config {
    query: Vec<String>,
    out_dir: PathBuf,
    write_proteins: bool,
    closed_ends: bool,
    write_nucls: bool,
    output_format: Option<String>,
    trans_table: Option<String>,
    masked: bool,
    bypass_trainer: bool,
    procedure: Option<String>,
    write_genes: bool,
}

type MyResult<T> = Result<T, Box<dyn Error>>;

// --------------------------------------------------
pub fn get_args() -> MyResult<Config> {
    let matches = App::new("run_prodigal")
        .version("0.1.0")
        .author("Ken Youens-Clark <kycluprocark@email.arizona.edu>")
        .about("Runs Prodigal")
        .arg(
            Arg::with_name("query")
                .short("q")
                .long("query")
                .value_name("FILE_OR_DIR")
                .help("Input files and/or directories")
                .required(true)
                .min_values(1),
        )
        .arg(
            Arg::with_name("write_proteins")
                .short("a")
                .long("proteins")
                .help("Write proteins"),
        )
        .arg(
            Arg::with_name("closed_ends")
                .short("c")
                .long("closed_ends")
                .help("Closed ends"),
        )
        .arg(
            Arg::with_name("write_nucls")
                .short("d")
                .long("write_nucls")
                .help("Write nucleotides"),
        )
        .arg(
            Arg::with_name("output_format")
                .short("f")
                .long("output_format")
                .help("Output format")
                .possible_values(&["gbk", "gff", "sco"])
                .takes_value(true),
        )
        .arg(
            Arg::with_name("trans_table")
                .short("g")
                .long("trans_table")
                .help("Translation table")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("masked")
                .short("m")
                .long("masked")
                .help("Treat runs of N as masked"),
        )
        .arg(
            Arg::with_name("bypass_trainer")
                .short("n")
                .long("bypass_trainer")
                .help("Bypass Shine-Dalgarno trainer"),
        )
        .arg(
            Arg::with_name("procedure")
                .short("p")
                .long("procedure")
                .possible_values(&["single", "meta"])
                .takes_value(true)
                .help("Procedure"),
        )
        .arg(
            Arg::with_name("write_genes")
                .short("s")
                .long("write_genes")
                .help("Write genes"),
        )
        .arg(
            Arg::with_name("out_dir")
                .short("o")
                .long("out_dir")
                .value_name("DIR")
                .help("Output directory"),
        )
        .get_matches();

    let out_dir = match matches.value_of("out_dir") {
        Some(x) => PathBuf::from(x),
        _ => {
            let cwd = env::current_dir()?;
            cwd.join(PathBuf::from("prodigal-out"))
        }
    };

    Ok(Config {
        query: matches.values_of_lossy("query").unwrap(),
        out_dir: out_dir,
        write_proteins: matches.is_present("write_proteins"),
        closed_ends: matches.is_present("closed_ends"),
        write_nucls: matches.is_present("write_nucls"),
        output_format: matches
            .value_of("output_format")
            .and_then(|x| Some(x.to_string())),
        trans_table: matches
            .value_of("trans_table")
            .and_then(|x| Some(x.to_string())),
        masked: matches.is_present("masked"),
        bypass_trainer: matches.is_present("bypass_trainer"),
        procedure: matches
            .value_of("procedure")
            .and_then(|x| Some(x.to_string())),
        write_genes: matches.is_present("write_genes"),
    })
}

// --------------------------------------------------
pub fn run(config: Config) -> MyResult<()> {
    let files = find_files(&config.query)?;

    if files.len() == 0 {
        let msg = format!("No input files from query \"{:?}\"", &config.query);
        return Err(From::from(msg));
    }

    println!(
        "Will process {} file{}",
        files.len(),
        if files.len() == 1 { "" } else { "s" }
    );

    let out_dir = &config.out_dir;
    if !out_dir.is_dir() {
        DirBuilder::new().recursive(true).create(&out_dir)?;
    }

    run_prodigal(&config, &files)?;

    println!("Done, see output in \"{:?}\"", &config.out_dir);

    Ok(())
}

// --------------------------------------------------
fn find_files(paths: &Vec<String>) -> Result<Vec<String>, Box<dyn Error>> {
    let mut files = vec![];
    for path in paths {
        let meta = fs::metadata(path)?;
        if meta.is_file() {
            files.push(path.to_owned());
        } else {
            for entry in fs::read_dir(path)? {
                let entry = entry?;
                let meta = entry.metadata()?;
                if meta.is_file() {
                    files.push(entry.path().display().to_string());
                }
            }
        };
    }

    if files.len() == 0 {
        return Err(From::from("No input files"));
    }

    Ok(files)
}

// --------------------------------------------------
fn run_prodigal(config: &Config, files: &Vec<String>) -> MyResult<()> {
    let mut opts: Vec<String> = vec![];

    if config.closed_ends {
        opts.push("-c".to_string());
    }

    if let Some(val) = &config.output_format {
        opts.push(format!("-f {}", val));
    }

    if let Some(val) = &config.trans_table {
        opts.push(format!("-g {}", val));
    }

    if config.masked {
        opts.push("-m".to_string());
    }

    if config.bypass_trainer {
        opts.push("-n".to_string());
    }

    if let Some(val) = &config.procedure {
        opts.push(format!("-p {}", val));
    }

    let mut jobs: Vec<String> = vec![];
    for file in files.iter() {
        if let Some(basename) = Path::new(file).file_name() {
            let mut out_files = vec![];
            let base = basename.to_string_lossy().to_string();

            out_files.push(format!(
                "-o {}.out",
                &config.out_dir.join(&base).display()
            ));

            if config.write_proteins {
                out_files.push(format!(
                    "-a {}.proteins",
                    &config.out_dir.join(&base).display()
                ));
            }

            if config.write_nucls {
                out_files.push(format!(
                    "-d {}.nucleotides",
                    &config.out_dir.join(&base).display()
                ));
            }

            if config.write_genes {
                out_files.push(format!(
                    "-s {}.genes",
                    &config.out_dir.join(&base).display()
                ));
            }

            jobs.push(format!(
                "prodigal -q -i {} {} {}",
                file,
                opts.join(" "),
                out_files.join(" "),
            ));
        }
    }

    run_jobs(&jobs, "Running prodigal", 8)?;

    Ok(())
}

// --------------------------------------------------
fn run_jobs(
    jobs: &Vec<String>,
    msg: &str,
    num_concurrent: u32,
) -> MyResult<()> {
    let num_jobs = jobs.len();

    if num_jobs > 0 {
        println!(
            "{} (# {} job{} @ {})",
            msg,
            num_jobs,
            if num_jobs == 1 { "" } else { "s" },
            num_concurrent
        );

        run_parallel(&jobs, &num_concurrent).or_else(|_| run_shell(&jobs))?;
    }

    Ok(())
}

// --------------------------------------------------
fn run_parallel(jobs: &Vec<String>, num_concurrent: &u32) -> MyResult<()> {
    let mut process = Command::new("parallel")
        .arg("-j")
        .arg(num_concurrent.to_string())
        .arg("--halt")
        .arg("soon,fail=1")
        .stdin(Stdio::piped())
        .stdout(Stdio::null())
        .spawn()?;

    {
        let stdin = process.stdin.as_mut().expect("Failed to open stdin");
        stdin
            .write_all(jobs.join("\n").as_bytes())
            .expect("Failed to write to stdin");
    }

    let result = process.wait()?;
    if !result.success() {
        return Err(From::from("Failed to run jobs in parallel"));
    }

    Ok(())
}

// --------------------------------------------------
fn run_shell(jobs: &Vec<String>) -> MyResult<()> {
    let cwd = env::current_dir()?;
    let jobs_file = cwd.join(PathBuf::from("jobs.txt"));

    {
        let mut fh = File::create(&jobs_file)?;
        fh.write_all(jobs.join("\n").as_bytes())?;
    }

    if Path::new(&jobs_file).exists() {
        let mut process = Command::new("bash").arg(&jobs_file).spawn()?;
        let result = process.wait()?;
        if !result.success() {
            return Err(From::from("Failed to run jobs in shell"));
        }
        fs::remove_file(jobs_file)?;
    }

    Ok(())
}
