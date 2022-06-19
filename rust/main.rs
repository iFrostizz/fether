use inquire::Select;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs::File;
use std::io::BufReader;
// use std::process::Command;
// use std::env;

#[derive(Serialize, Deserialize)]
struct Level {
    name: String,
    description: String,
    difficulty: u8,
}

fn main() {
    let options = vec![
        "Quit",
        "0. Hello Fether",
        "1. Fallback",
        "2. Fallout",
        "3. Coin Flip",
        "4. Telephone",
        "5. Token",
        "6. Delegation",
        "7. Force",
        "8. Vault",
        "9. King",
        "10. Re-entrancy",
        "11. Elevator",
        "12. Privacy",
        "13. Gatekeeper One",
        "14. Gatekeeper Two",
        "15. Naught Coin",
        "16. Preservation",
        "17. Recovery",
        "18. MagicNumber",
        "19. Aline Coder",
        "20. Denial",
        "21. Shop",
        "22. Dex",
        "23. Dex Two",
        "24. Puzzle Wallet",
        "25. Motorbike",
        "26. DoubleEntryPoint",
    ];

    let ans = Select::new("Choose a level", options)
        .with_vim_mode(true)
        .prompt();

    match ans {
        Ok(choice) => {
            if choice == "Quit" {
                return;
            }
            handle_level(choice)
        }
        Err(_) => println!("There was an error, please try again"),
    }
}

fn handle_level(level: &str) {
    let ans = Select::new(
        "Chose an action",
        vec!["Read description", "Hack it", "Get an hint", "Quit"],
    )
    .with_vim_mode(true)
    .prompt();

    match ans {
        Ok(choice) => handle_action(level, choice),
        Err(_) => println!("There was an error, please try again"),
    }

    /*let path = env::current_dir().expect("Coudn't retrieve the current directory");
    let path_str: String = path.display().to_string();
    println!("The current directory is {}", path_str);*/

    // Command::new("cd ".to_owned() + &path_str + "/src/" + &file_result[choice].name).spawn().expect(&*("cd ".to_owned() + &path_str + "/src/" + &file_result[choice].name + " doesn't exists"));
}

fn handle_action(level: &str, action: &str) {
    let file: File = File::open("./rust/descriptions.json").unwrap();
    let reader: BufReader<File> = BufReader::new(file);
    let file_result: HashMap<String, Level> =
        serde_json::from_reader(reader).expect("couldn't parse file");

    // println!("Name: {}", file_result[level].name);
    // println!("difficulty: {}/10\n", file_result[level].difficulty);

    match action {
        "Read description" => println!("Description: {}\n", file_result[level].description),
        "Hack it" => hack_level(),
        "Get an hint" => get_hint(),
        "Quit" => return,
        _ => panic!("This choice doesn't exist"),
    }

    handle_level(level);
}

fn hack_level() {
    println!("Let's hack it!\n");
}

fn get_hint() {
    println!("Let's get an hint!\n");
}

