mod PathList;

fn main() {
    let arc_info = vec![vec![0, 3, 8, 4, 6, 1],
                        vec![3, 0, 6, 3, 3, 3],
                        vec![8, 6, 0, 4, 3, 9],
                        vec![4, 3, 4, 0, 1, 4],
                        vec![6, 3, 3, 1, 0, 5],
                        vec![1, 3, 9, 4, 5, 0]];

    let mut test_path = PathList::SalesmanPath::new(arc_info, 0);
    let mut test_list = PathList::PathList::new();

    for i in 1..6 {
        test_path.add(i);
    }

    for node in test_path.getPath().iter() {
            println!(" {}", node);
    }
}
