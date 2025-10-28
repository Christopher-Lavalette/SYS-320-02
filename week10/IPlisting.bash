[ $# -lt 1 ] && echo "usage: bash IPlist.bash <prefix>" && exit 1

prefix=$1

for i in {1..254}
do
	echo "$prefix,$i"
done
