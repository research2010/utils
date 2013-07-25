#!/bin/bash

# generate CMakeLists.txt for *.h and *.cpp from current
# directory

echo $0	#the script file
echo $1	#the extension of include files
echo $2 #the extension of source files
echo $3 #the prooject name 
echo $4 #the project type (lib or exe)
ext1=*.$1
ext2=*.$2
list1=`ls ${ext1}`
list2=`ls ${ext2}`
# show include files
for i in ${list1}
do
	echo $i
done
# show source files
for i in ${list2}
do
	echo $i
done
# move include files into include directory
if [ ! -d include ];then
	echo 'include not exists'
	mkdir -p include
fi
mv ${ext1} ./include
# move source files into source directory
if [ ! -d src ];then
	echo 'src not exists'
	mkdir -p src
fi
mv ${ext2} ./src
# create a CMakeLists.txt
if [ -f CMakeLists.txt ];then
	rm CMakeLists.txt
fi
touch CMakeLists.txt
#echo "" >> CMakeLists.txt
echo "cmake_minimum_required(VERSION 2.6 FATAL_ERROR)" >> CMakeLists.txt
echo 'set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)' >> CMakeLists.txt
echo 'set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)' >> CMakeLists.txt
echo "project($3)" >> CMakeLists.txt
echo 'include_directories(include)' >> CMakeLists.txt
if [ "$4" == "lib" ];then
	echo "add_library($3 SHARED" >> CMakeLists.txt
elif [ "$4" == "exe" ];then
	echo "add_executable($3 " >> CMakeLists.txt
else 
	echo 'Error input pararmeters.'
fi
for i in ${list1}
do
	echo "include/$i" >> CMakeLists.txt
done
for i in ${list2}
do
	echo "src/$i" >> CMakeLists.txt
done
echo ")" >> CMakeLists.txt


