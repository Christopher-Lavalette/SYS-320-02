prefix="$1"

if [ -z "prefix" ]; then
	echo "Usage: bash IPlist 2.bash <prefix>"
	echo "Prefix example: 10.0.17"
	exit 1
fi
if [ "${#prefix}" -lt 5 ]; then
	echo "prefix length is too short"
	echo "prefix example: 10.0.17"
	exit 1
fi

for i in {1..254}; do
	echo "${prefix}.${i}"
done

