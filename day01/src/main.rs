use std::io::{self, BufRead};

fn main() {
    let dial_max = 100;

    let stdin = io::stdin();

    let mut dial_number = 50;
    let mut zero_count = 0;

    for line in stdin.lock().lines() {
        let line = line.unwrap();
        let distance = line[1..].trim().parse::<i32>().unwrap();

        if line.starts_with("R") {
            // dial_number = (dial_number + distance).rem_euclid(dial_max);
            for _ in 0..distance {
                dial_number = (dial_number + 1_i32).rem_euclid(dial_max);
                if dial_number == 0 {
                    zero_count += 1;
                }
            }
        } else if line.starts_with("L") {
            // dial_number = (dial_number - distance).rem_euclid(dial_max);
            for _ in 0..distance {
                dial_number = (dial_number - 1_i32).rem_euclid(dial_max);
                if dial_number == 0 {
                    zero_count += 1;
                }
            }
        }

        // if dial_number == 0 {
        //     zero_count += 1;
        // }
    }

    println!("{}", zero_count);
}
