# Hex maze pyramid

[Maze pyramid generator](https://www.thingiverse.com/thing:1269336) is a thing I published at the beginning of 2016. It's based on [Random maze generator](https://www.thingiverse.com/thing:1185425).

One day, I thought... why not making a pyramid based on [Hex maze generator](http://www.thingiverse.com/thing:1836168)?

One thing I have to consider is that hex maze is not a square, but it can be approximated. After carefully calculated, it has a relation of `y_cells = round(0.866 * x_cells - 0.211)`. With a greater `x_cells`, `y_cells` would be a round number for `x_cells`. The width and length of the bottom would be approximately equaled. 

![Hex maze pyramid](http://thingiverse-production-new.s3.amazonaws.com/renders/53/22/c9/3f/9f/0c56dd6b0ca7c2e438fb7c961c3a1e41_preview_featured.jpg)