
pub struct SalesmanPath {
    arc_info: Vec<Vec<usize>>,
    path: Vec<usize>,
    cost: usize,
}

impl SalesmanPath {
    pub fn new(arc_info: Vec<Vec<usize>>, start_point: usize) -> SalesmanPath {
        SalesmanPath {
            arc_info: arc_info,
            path: vec![start_point],
            cost: 0
        }
    }

    pub fn add(&mut self, node: usize) {
        self.path.push(node);
    }

    pub fn calc(&self, path: &Vec<usize>, cost: usize) -> usize {
        let mut path_clone = path.clone();

        return match path_clone.pop() {
            Some(prev) => match path_clone.last() {
                Some(next)  => self.calc(&path_clone, cost + self.arc_info[prev][next.to_owned()]),
                None        => cost
            },
            None => 0
        }
    }

    pub fn getPath(&self) -> Vec<usize> {
        self.path.clone()
    }

    pub fn data(&self) {
        println!("arc_info:");
        for line in self.arc_info.iter() {
            for point in line.iter() {
                print!(" {}", point);
            }
            println!("");
        }

        print!("node:");
        for node in self.path.iter() {
            print!(" {}", node);
        }
        println!("");

        println!("cost: {}", self.cost);
    }
}

pub struct PathList {
    list: Vec<SalesmanPath>,
}

impl PathList {
    pub fn new() -> PathList {
        PathList {
            list: Vec::new()
        }
    }

    pub fn add(&mut self, path: SalesmanPath) {
        self.list.push(path);
    }
}
