#/bin/sh

version=$1


major=`echo $version | cut -d. -f1`
minor=`echo $version | cut -d. -f2`
revision=`echo $version | cut -d. -f3`

if [ -z "$major" ]; then 
	echo "No valid major version string given"
	exit 1
fi

if [ -z "$minor" ]; then
	echo "No valid minor version string given"
	exit 1
fi

use_major_version=$major
use_minor_version=$minor

find_matching_directory() {
	local root=$1
	local min_version=$2
	local candidate=""

	for subdir in `find $root -maxdepth 1 -mindepth 1 -type d -printf '%f\n'`
	do	
		# is subdirectory a numer
		if [ -n "$subdir" ] && [ "$subdir" -eq "$subdir" ] 2>/dev/null; then
			if [ "$min_version" -ge "$subdir" ]; then
				candidate=$subdir
			fi
		fi
	done

	if [ -z "${candidate}" ]; then
		echo "Could not find any Dockerfile directory candidate for version part '$min_version' in root directory $root"
		exit 200
	fi

	echo $candidate

}

parent_directory=$(find_matching_directory . $major)

if [ $? -ne 0 ]; then
	echo $parent_directory
	exit 2
fi

child_directory=$(find_matching_directory ./$parent_directory $minor)

if [ $? -ne 0 ]; then
	echo $child_directory
	exit 3
fi

use_directory=$parent_directory/$child_directory

if [ ! -d "$use_directory" ]; then
	echo "Directory with Docker images at $use_directory does not exist"
	exit 4
fi

if [ ! -e "$use_directory/Dockerfile" ]; then
	echo "No Dockerfile found in $use_directory"
	exit 5
fi

echo $use_directory
exit 0
