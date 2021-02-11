FROM ubuntu:20.04
ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Basic apt update
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales ca-certificates &&  rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
      apt-get -y install sudo

# Get the requirements
RUN apt-get update && \
        apt-get -y install \
        git \
        unzip \
        wget \
        make \
        curl \
	xxd
#clone tensorflow 
RUN git clone --depth 1 https://github.com/tensorflow/tensorflow.git
### run each make command and create folders for each one
# normal tensorflow lite micro
RUN cd tensorflow && \
	make -f tensorflow/lite/micro/tools/make/Makefile generate_hello_world_make_project -j8; exit 0 && \
	#run twice not sure why
	make -f tensorflow/lite/micro/tools/make/Makefile generate_hello_world_make_project -j8 && \
	cd ../ && \
	# make new library folder
	mkdir tflite-micro && \
	# copy tensorflow and thirdparty
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/tensorflow tflite-micro/ && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/third_party tflite-micro/ && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/README_MAKE.md tflite-micro/readme.md && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/LICENSE tflite-micro/LICENSE && \
	## clean up the tensorflow
	cd tensorflow && \
	make -f tensorflow/lite/micro/tools/make/Makefile clean && \
	make -f tensorflow/lite/micro/tools/make/Makefile clean_downloads

# cmsis-nn version
RUN cd tensorflow && \
        make -f tensorflow/lite/micro/tools/make/Makefile OPTIMIZED_KERNEL_DIR=cmsis_nn generate_hello_world_make_project -j8 && \
        #run twice not sure why
        make -f tensorflow/lite/micro/tools/make/Makefile OPTIMIZED_KERNEL_DIR=cmsis_nn generate_hello_world_make_project -j8 && \
        cd ../ && \
	# make the library folder
	mkdir tflite-micro-cmsis && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/tensorflow tflite-micro-cmsis/ && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/third_party tflite-micro-cmsis/ && \ 
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/README_MAKE.md tflite-micro-cmsis/readme.md && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/linux_x86_64_default/prj/hello_world/make/LICENSE tflite-micro-cmsis/LICENSE && \
	## get all the cmsis third party information
	mkdir tflite-micro-cmsis/cmsis && \
	cp tensorflow/tensorflow/lite/micro/tools/make/downloads/cmsis/LICENSE.txt tflite-micro-cmsis/cmsis/ && \
	cp tensorflow/tensorflow/lite/micro/tools/make/downloads/cmsis/README.md tflite-micro-cmsis/cmsis/ && \
	mkdir -p tflite-micro-cmsis/cmsis/CMSIS/Core && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/downloads/cmsis/CMSIS/Core/Include tflite-micro-cmsis/cmsis/CMSIS/Core/ && \
	mkdir -p tflite-micro-cmsis/cmsis/CMSIS/DSP && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/downloads/cmsis/CMSIS/DSP/Include/ tflite-micro-cmsis/cmsis/CMSIS/DSP/ && \
	mkdir -p tflite-micro-cmsis/cmsis/CMSIS/NN/ && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/downloads/cmsis/CMSIS/NN/Include/ tflite-micro-cmsis/cmsis/CMSIS/NN/ && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/downloads/cmsis/CMSIS/NN/Source/ tflite-micro-cmsis/cmsis/CMSIS/NN/ && \
	cd tflite-micro-cmsis && \
	find . -name "CMakeLists.txt" -delete && \
	cd ../tensorflow && \
        make -f tensorflow/lite/micro/tools/make/Makefile clean && \
        make -f tensorflow/lite/micro/tools/make/Makefile clean_downloads

RUN cd tensorflow && \
        make -f tensorflow/lite/micro/tools/make/Makefile TARGET=cortex_m_generic TARGET_ARCH=cortex-m55  OPTIMIZED_KERNEL_DIR=cmsis_nn CO_PROCESSOR=ethos_u generate_hello_world_make_project -j8 && \
        #run twice not sure why
        make -f tensorflow/lite/micro/tools/make/Makefile TARGET=cortex_m_generic TARGET_ARCH=cortex-m55  OPTIMIZED_KERNEL_DIR=cmsis_nn CO_PROCESSOR=ethos_u generate_hello_world_make_project -j8 && \
	cd ../ && \
	mkdir tflite-micro-ethosu && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/cortex_m_generic_cortex-m55_default/prj/hello_world/make/third_party tflite-micro-ethosu/ && \
        cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/cortex_m_generic_cortex-m55_default/prj/hello_world/make/tensorflow tflite-micro-ethosu/ && \ 
        cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/cortex_m_generic_cortex-m55_default/prj/hello_world/make/README_MAKE.md tflite-micro-ethosu/readme.md && \
        cp -r tensorflow/tensorflow/lite/micro/tools/make/gen/cortex_m_generic_cortex-m55_default/prj/hello_world/make/LICENSE tflite-micro-ethosu/LICENSE && \
	cp -r tflite-micro-cmsis/third_party/CMSIS tflite-micro-ethosu/third_party/ && \
	cp -r tensorflow/tensorflow/lite/micro/tools/make/downloads/ethosu tflite-micro-ethosu/third_party/ && \
	rm -rf tflite-micro-ethosu/third_party/ethosu/CMakeLists.txt
