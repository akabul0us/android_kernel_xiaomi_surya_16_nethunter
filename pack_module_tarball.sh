#!/usr/bin/env bash
datenow="$(date '+%Y%m%d-%H%M')"
tarname="surya_nethunter_modules_$datenow.tar"
if [ ! -d modules ]; then
	mkdir -p modules
fi
list="$(find . -name *.ko)"
while IFS= read -r line; do 
	cp "$line" modules
done <<< "$list"
cd modules
tar cvf $tarname *.ko
gzip -9 $tarname
mv $tarname.gz ../
echo "Module tarball packed at $tarname.gz"
