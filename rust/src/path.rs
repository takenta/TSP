struct Salesman_path {
    arc_info: Vec<Vec<usize>>,
    path: Vec<usize>,
    cost: usize,
}

impl Salesman_path {
    fn new(arc_info: &Vec<&Vec<>>, start_point: usize) -> Salesman_path {
        Salesman_path {
            arc_info: arc_info,
            path: vec![start_point],
            cost: 0,
        }
    },

    fn add(&self, node: usize) {
        self.path.push(node);
    },

    fn calc(&self, path: Vec<usize>, cost: usize) -> usize {
        let prev = path.pop();
        let next = path.last();

        if next == None {
            return cost;
        } else {
            return self.calf(path, cost + self.arc_info[prev][next])
        }
    }
}

struct Path_list {
    list: Vec!<Path>,
}

impl path_list {
    fn add(&self, path: Salesman_path) {
        self.list.push(path);
    },

    fn calc(&self) {
        // add code here
    },
}
