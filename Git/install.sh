#!/bin/sh

export PYTHON_BIN_PATH=$(which python)
export USE_DEFAULT_PYTHON_LIB_PATH=1
export TF_NEED_JEMALLOC=1
export TF_NEED_KAFKA=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_AWS=0
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_S3=0
export TF_ENABLE_XLA=1
export TF_NEED_GDR=0
export TF_NEED_VERBS=0
export TF_NEED_OPENCL=0
export TF_NEED_MPI=0
export TF_NEED_TENSORRT=0
export TF_NEED_NGRAPH=0
export TF_NEED_IGNITE=0
export TF_NEED_ROCM=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_DOWNLOAD_CLANG=0
export TF_NCCL_VERSION=2.4
export NCCL_INSTALL_PATH=/usr
export TF_IGNORE_MAX_BAZEL_VERSION=1
export CC_OPT_FLAGS="-march=haswell"
export TF_NEED_CUDA=1
export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
export HOST_CXX_COMPILER_PATH=/usr/bin/gcc
export TF_CUDA_CLANG=0
# export CLANG_CUDA_COMPILER_PATH=/usr/bin/clang
export CUDA_TOOLKIT_PATH=/opt/cuda
export TF_CUDA_VERSION=$($CUDA_TOOLKIT_PATH/bin/nvcc --version | sed -n 's/^.*release \(.*\),.*/\1/p')
export CUDNN_INSTALL_PATH=/usr/lib
export TF_CUDNN_VERSION=$(sed -n 's/^#define CUDNN_MAJOR\s*\(.*\).*/\1/p' /usr/include/cudnn.h)
export TF_CUDA_COMPUTE_CAPABILITIES=3.5,3.7,5.0,5.2,5.3,6.0,6.1,6.2,7.0,7.2,7.5

pkgver=1.13.1

wget https://github.com/tensorflow/tensorflow/archive/v${pkgver}.tar.gz
tar -xvzf v${pkgver}.tar.gz

patch -d tensorflow-${pkgver} -Np1 -i "$(pwd)/protobuf_temp_fix_cuda10.1_apply.patch"
cp "$(pwd)/protobuf_temp_fix_cuda10.1.patch" tensorflow-${pkgver}/third_party/

cd tensorflow-${pkgver}
./configure
bazel build --config=opt --config=cuda --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package tmp/tensorflow_pkg

bazel shutdown
