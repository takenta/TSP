mod path_list;

fn main() {
    let arc_info = vec![vec![0, 3, 8, 4, 6, 1],
                        vec![3, 0, 6, 3, 3, 3],
                        vec![8, 6, 0, 4, 3, 9],
                        vec![4, 3, 4, 0, 1, 4],
                        vec![6, 3, 3, 1, 0, 5],
                        vec![1, 3, 9, 4, 5, 0]];
    let start_point: usize = 0;

    let test_list = path_list::PathList::new(&arc_info, start_point);

    println!("===============");
    println!("All Path List");
    println!("{}", test_list);

    let mut optimal_path = test_list.all_enumerate();
    println!("===============");
    println!("All Enumerate Method");
    println!("Optimal Path: [{}] ({})", optimal_path, optimal_path.cost());

    optimal_path = test_list.generate_optimal("NA");
    println!("===============");
    println!("Nearest Addtion Method");
    println!("Optimal Path: [{}] ({})", optimal_path, optimal_path.cost());
}
