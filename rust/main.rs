use inquire::Select;

fn main() {
    let options = vec![
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

    let ans = Select::new("Choose a level", options).prompt();

    match ans {
        Ok(choice) => handle_level(choice),
        Err(_) => println!("There was an error, please try again"),
    }
}

fn handle_level (choice: &str) {
    println!("You chose {}!", choice)
}