for file in *.txt; do
echo $file
	mv "$file" "${file%..txt}.txt"
done
