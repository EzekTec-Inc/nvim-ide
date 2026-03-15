fn main() {
    let new_world = "New World! <insert world icon here>";

    let res = new_world.chars().split(|c| c == ' ').collect::<Vec<char>>();

    println!("Hello, world!");
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_dummy() {
        assert_eq!(1, 1);
    }

    #[test]
    fn test_dummy2() {
        println!("dummy test 2");
        assert_eq!(1, 1);
    }
}
