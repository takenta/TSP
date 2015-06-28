use std::fmt;

#[derive(Clone)]
pub struct SalesmanPath {
    arc_info: Vec<Vec<usize>>,
    salesman_path: Vec<usize>,
}

impl SalesmanPath {
    pub fn new(arc_info: &Vec<Vec<usize>>, start_node: usize) -> SalesmanPath {
        SalesmanPath {
            arc_info: arc_info.clone(),
            salesman_path: vec![start_node],
        }
    }

    pub fn path(&self) -> Vec<usize> {
        self.salesman_path.clone()
    }

    pub fn cost(&self) -> usize {
        let mut sum = 0;
        for win in self.salesman_path.windows(2) {
            sum += self.arc_info[win[0]][win[1]];
        }
        return sum;
    }

    pub fn len(&self) -> usize {
        self.salesman_path.len()
    }

    pub fn add(&mut self, node: usize) {
        self.salesman_path.push(node);
    }

    pub fn insert(&mut self, index: usize, element: usize) {
        self.salesman_path.insert(index, element);
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
    start_node: usize,
}

impl PathList {
    pub fn new(arc_info: &Vec<Vec<usize>>, start_node: usize) -> PathList {
        PathList {
            arc_info: arc_info.clone(),
            start_node: start_node
        }
    }

    pub fn generate_all(&self, prev_path: &mut SalesmanPath, unused_nodes: &Vec<usize>) -> Vec<SalesmanPath> {
        let mut buffer:Vec<SalesmanPath> = Vec::new();
        match unused_nodes.is_empty() {
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

                    // Call self.generate_all(prev_path, unused_nodes) by the path and the array.
                    let list = self.generate_all(&mut path, &mut nodes);
                    for temp in list {
                        buffer.push(temp);
                    }
                }
            }
        }
        buffer.clone()
    }

    pub fn generate_optimal(&self, mode: &str) -> SalesmanPath {
        match mode {
            "AE" => {
                self.all_enumerate().clone()
            },
            "NA" => {
                // Create unused_nodes.
                let mut unused_nodes = self.nodes();
                unused_nodes.retain(|&x| x != self.start_node);

                self.nearest_addition(&mut SalesmanPath::new(&self.arc_info, self.start_node).close(), &unused_nodes).clone()
            },
            _ => {
                println!("The method don't exists");
                SalesmanPath::new(&self.arc_info, self.start_node).clone()
            }
        }
    }

    pub fn all_enumerate(&self) -> SalesmanPath {
        // Create unused_nodes.
        let mut unused_nodes = self.nodes();
        unused_nodes.retain(|&x| x != self.start_node);

        // Create list that contained all paths.
        let path_list = self.generate_all(&mut SalesmanPath::new(&self.arc_info, self.start_node), &unused_nodes);

        // Search a optimal-path in the list.
        // memo) max_by() is unstable.
        let mut min = path_list.first().unwrap();
        for path in path_list.iter() {
            if min.cost() > path.cost() { min = path; }
        }
        min.clone()
    }

    pub fn nearest_addition(&self, prev_path: &mut SalesmanPath, unused_nodes: &Vec<usize>) -> SalesmanPath {
        match unused_nodes.is_empty() {
            true => {
                prev_path.clone()
            },
            false => {
                let path = prev_path.path();
                let mut min_arc = (0, path.first().unwrap(), unused_nodes.first().unwrap());

                // take out a node from `unused_nodes`
                for (index, prev_node) in path.iter().enumerate() {
                    for next_node in unused_nodes.iter() {
                        if self.arc_info[*prev_node][*next_node] < self.arc_info[*min_arc.1][*min_arc.2] {
                            min_arc = (index, prev_node, next_node);
                        }
                    }
                }

                let mut path = prev_path.clone();
                path.insert(min_arc.0 + 1, *min_arc.2);

                let mut nodes = unused_nodes.clone();
                nodes.retain(|&x| x != *min_arc.2);

                self.nearest_addition(&mut path, &nodes)
            }
        }
    }

    fn nodes(&self) -> Vec<usize> {
        let mut nodes: Vec<usize> = Vec::new();
        for node in 0..self.arc_info.len() {
            nodes.push(node);
        }
        nodes.clone()
    }
}

impl fmt::Display for PathList {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let list = self.generate_all(&mut SalesmanPath::new(&self.arc_info, 0), &mut vec![1,2,3,4,5]);
        let len = list.len();

        for (count, path) in list.iter().enumerate() {
            if count < len - 1 { try!(write!(f, "Path: {} ({})\n", path, path.cost())) }
        }
        write!(f, "Path: {} ({})", list[len - 1], list[len - 1].cost())
    }
}
