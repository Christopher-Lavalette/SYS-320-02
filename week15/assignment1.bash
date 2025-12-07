# SYS-320-02
# Christopher Lavalette

#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst() {

echo -n "Please Input an Instructor Full Name: "
read instName
echo ""

echo "Courses of $instName :"
grep "$instName" "$courseFile" | awk -F';' '{print $1 " | " $2}'
echo ""

}

function courseCountofInsts() {

echo ""
echo "Course-Instructor Distribution"
awk -F';' '{print $7}' "$courseFile" | \
grep -v "/" | grep -v "\.\.\." | \
sort | uniq -c | sort -nr
echo ""

}

# ================================
# TODO 1 — Display courses in location
# ================================
function displayCoursesInLocation() {

echo -n "Please input a Class Name: "
read loc
echo ""

echo "Courses in $loc:"
grep "$loc" "$courseFile" | awk -F';' '{printf "%s | %s | %s | %s | %s\n", $1, $2, $5, $6, $7}'
echo ""

}

# ===================================
# TODO 2 — Display available courses by subject prefix
# ===================================
function displayAvailableBySubject() {

echo -n "Please input a Subject Prefix (ex: SEC): "
read prefix
echo ""

echo "Available courses of subject $prefix:"
grep "^$prefix" "$courseFile" | awk -F';' '
    $4 > 0 {
        printf "%s | %s | %s | %s | %s | Seats: %s\n",
        $1, $2, $5, $6, $7, $4
    }
'
echo ""

}

# ================================
# Menu
# ================================
while :
do
	echo ""
	echo "Please select and option:"
	echo "[1] Display courses of an instructor"
	echo "[2] Display course count of instructors"
	echo "[3] Display courses of a classroom"
	echo "[4] Display available courses of subject"
	echo "[5] Exit"

	read userInput
	echo ""

	if [[ "$userInput" == "5" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		displayCoursesofInst

	elif [[ "$userInput" == "2" ]]; then
		courseCountofInsts

	elif [[ "$userInput" == "3" ]]; then
		displayCoursesInLocation

	elif [[ "$userInput" == "4" ]]; then
		displayAvailableBySubject

	# ===================================
	# TODO 3 — Invalid input message
	# ===================================
	else
		echo "Invalid option. Please try again."
	fi
done
