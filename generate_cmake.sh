#!/bin/bash

# generate CMakeLists.txt for *.h/*.hpp and *.cpp/*.cxx/*.cc from current
# directory

echo $0	#the script file
echo $1 #the prooject name 
echo $2 #the project type (lib or exe)
list_h=`ls *.h *.hpp *.hxx`
list_cpp=`ls *.c *.cpp *.cxx *.cc`
# show include files
for i in ${list_h}
do
	echo $i
done
# show source files
for i in ${list_cpp}
do
	echo $i
done
# move include files into include directory
if [ ! -d include ];then
	echo 'include not exists'
	mkdir -p include
fi
mv *.h *.hpp *.hxx ./include
# move source files into source directory
if [ ! -d src ];then
	echo 'src not exists'
	mkdir -p src
fi
mv *.c *.cpp *.cxx *.cc ./src
# create a CMakeLists.txt
if [ -f CMakeLists.txt ];then
	rm CMakeLists.txt
fi
touch CMakeLists.txt
#echo "" >> CMakeLists.txt
echo "cmake_minimum_required(VERSION 2.6 FATAL_ERROR)" >> CMakeLists.txt
echo 'set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)' >> CMakeLists.txt
echo 'set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)' >> CMakeLists.txt
echo "project($1)" >> CMakeLists.txt
echo 'include_directories(include)' >> CMakeLists.txt
if [ "$2" == "lib" ];then
	echo "add_library($1 SHARED" >> CMakeLists.txt
elif [ "$2" == "exe" ];then
	echo "add_executable($1 " >> CMakeLists.txt
else 
	echo 'Error input pararmeters.'
fi
for i in ${list_h}
do
	echo "include/$i" >> CMakeLists.txt
done
for i in ${list_cpp}
do
	echo "src/$i" >> CMakeLists.txt
done
echo ")" >> CMakeLists.txt


