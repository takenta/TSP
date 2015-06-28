use std::fmt;

#[derive(Clone)]
pub struct SalesmanPath {
    arc_info: Vec<Vec<usize>>,
    salesman_path: Vec<usize>,
}

impl SalesmanPath {
    pub fn new(arc_info: &Vec<Vec<usize>>, start_point: usize) -> SalesmanPath {
        SalesmanPath {
            arc_info: arc_info.clone(),
            salesman_path: vec![start_point],
        }
    }

    pub fn add(&mut self, node: usize) {
        self.salesman_path.push(node);
    }

    pub fn cost(&self) -> usize {
        let mut sum = 0;
        for win in self.salesman_path.windows(2) {
            sum += self.arc_info[win[0]][win[1]];
        }
        return sum;
    }

    pub fn close(&mut self) -> SalesmanPath {
        let start_node = self.salesman_path[0].clone();
        self.salesman_path.push(start_node);
        self.clone()
    }
}

impl fmt::Display for SalesmanPath {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let path = self.salesman_path.clone();
        let len = path.len();

        for (count, node) in path.iter().enumerate() {
            if count < len - 1 { try!(write!(f, "{} ", node)); }
        }
        write!(f, "{}", path[len - 1])
    }
}



pub struct PathList {
    arc_info: Vec<Vec<usize>>,
}

impl PathList {
    pub fn new(arc_info: &Vec<Vec<usize>>) -> PathList {
        PathList {
            arc_info: arc_info.clone()
        }
    }

    pub fn generate(&self, prev_path: &mut SalesmanPath, unused_nodes: &mut Vec<usize>) -> Vec<SalesmanPath> {
        let mut buffer:Vec<SalesmanPath> = Vec::new();
        match (*unused_nodes).is_empty() {
            true => {
                buffer.push(prev_path.close());
            },
            false => {
                // take out a element from `unused_nodes`.
                for node in unused_nodes.iter() {
                    // Generate a path that the node has be added.
                    let mut path = prev_path.clone();
                    path.add(*node);

                    // Generate a array of usize that the node has be removed.
                    let mut nodes = unused_nodes.clone();
                    nodes.retain(|&x| x != *node);

                    // Call self.generate(prev_path, unused_nodes) by the path and the array.
                    let list = self.generate(&mut path, &mut nodes);
                    for temp in list {
                        buffer.push(temp);
                    }
                }
            }
        }
        buffer.clone()
    }

    pub fn all_enumerate(&self) -> SalesmanPath {
        // Get list that contained all paths.
        let list = self.generate(&mut SalesmanPath::new(&self.arc_info, 0), &mut vec![1,2,3,4,5]);

        // Search a optimal-path in the list.
        // memo) max_by() is unstable.
        let mut min = list.first().unwrap();
        for path in list.iter() {
            if min.cost() > path.cost() { min = path; }
        }
        min.clone()
    }
}

impl fmt::Display for PathList {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let list = self.generate(&mut SalesmanPath::new(&self.arc_info, 0), &mut vec![1,2,3,4,5]);
        let len = list.len();

        for (count, path) in list.iter().enumerate() {
            if count < len - 1 { try!(write!(f, "Path: {} ({})\n", path, path.cost())) }
        }
        write!(f, "Path: {} ({})", list[len - 1], list[len - 1].cost())
    }
}
