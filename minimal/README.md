# RubyData base stack

This docker image consists of minimal components for data science using Ruby.

## Components in this image

- Based on buildpack-deps:xenial
- Ruby 2.4.1
    - Almost same as docker-library's ruby image
- Python 3.6.2
    - Almost same as docker-library's python image
- OpenBLAS
- CZMQ 4.0.2
- Jupyter Notebook 5.1.x
- [tini](https://github.com/krallin/tini) as the container entrypoint
- Python stack
  - numpy, pandas, matplotlib, scipy, seaborn, bokeh, plotly, holoviews,
    scikit-learn, scikit-image, sympy, gensim, nltk, cython, statsmodel,
    patsy, cloudpickle, dill, numba, xray, pyarrow, tensorflow, keras,
    chainer, xgboost
- Ruby stack
  - pry, iruby, pycall, numpy, pandas, matplotlib, numo-narray, numo-linalg, nmatrix, nmatrix-lapacke, red-arrow, red-arrow-numo-narray, red-arrow-nmatrix, daru, rbplotly, charty

## Basic Usage

This image does not run Jupyter Notebook in default.
The following command runs bash shell on root user.

```
docker run -it --rm rubydata/base
```
