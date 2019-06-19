set -ex
OPENCV_VERSION=${1:-4.1.0}
COMPILE_DIR=/tmp/opencv
INSTALL_DIR=/opt/opencv-${OPENCV_VERSION}

rm -rf $COMPILE_DIR
mkdir -p $COMPILE_DIR
mkdir -p $INSTALL_DIR
pushd $COMPILE_DIR

curl -sLO https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip -qqo ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} opencv
cd opencv
mkdir build
cd build
cmake \
  -D CMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -D BUILD_LIST=core,imgproc,imgcodecs \
  -D CMAKE_BUILD_TYPE=Release \
  -D OPENCV_GENERATE_PKGCONFIG=YES \
  -D WITH_CSTRIPES=OFF \
  -D WITH_PTHREADS_PF=OFF \
  -D WITH_QT=OFF \
  -D WITH_OPENGL=OFF \
  -D WITH_OPENCL=OFF \
  -D WITH_OPENMP=OFF \
  -D WITH_TBB=ON \
  -D WITH_GDAL=ON \
  -D WITH_XINE=ON \
  -D WITH_WEBP=OFF \
  -D BUILD_PROTOBUF=OFF \
  -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF \
  -D ENABLE_PRECOMPILED_HEADERS=OFF \
  -D WITH_IPP=ON \
  -D CPU_BASELINE=NATIVE \
  -D ENABLE_FAST_MATH=ON \
  .. | tee install_cv4.log
make -j 8 | tee -a install_cv4.log
sudo make install --silent | tee -a install_cv4.log
sudo ldconfig $INSTALL_DIR/lib | tee -a install_cv4.log
sudo ln -s $INSTALL_DIR/lib/pkgconfig/opencv4.pc /usr/lib/pkgconfig/opencv4.pc
rm -f $COMPILE_DIR
popd
