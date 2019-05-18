# Selecting an Image

We have two Docker images:

1. `rubydata/minimal-notebook`
2. `rubydata/datascience-notebook`

## Ruby

These two images contain the same Ruby component for data science:

- pry
- iruby
- pycall
- numpy
- pandas
- matplotlib
- numo-narray
- numo-linalg
- nmatrix
- nmatrix-lapacke
- red-arrow
- red-arrow-numo-narray
- red-arrow-nmatrix
- daru
- rbplotly

## `rubydata/minimal-notebook`

`rubydata/minimal-notebook` consists of minimal components for data science using Ruby and Python.
This image also contains everything in [`jupyter/scipy-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook) and its ancestor images.

## `rubydata/datascience-notebook`

`rubydata/datascience-notebook` includes libraries for data analysis from the Julia, Python, and R libraries.
This image also contains everything in [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) and its ancestor images.
