#!/bin/bash

#源码目录
WORKDIR=$GOPATH/src/agent
#输出目录
OUTDIR=/home/xg/agent

#各系统版名字数组
SYSNAME=("Centos_64位" "Kylin_64位" "linux" "Ubuntu_64位")

#目标压缩包名称
TARNAME="agent.tar.gz"

#本地系统agent目录
LOCALAGENTDIR=/geesunn/resource/agent


cd  $WORKDIR
git checkout dev && git pull
./pack.sh targz

#清空输出目录
rm -rf $OUTDIR
mkdir -p $OUTDIR

cp /root/geesunn/targz/geesunn-agent.tar.gz $OUTDIR && cd $OUTDIR

tar zxvf $OUTDIR/geesunn-agent.tar.gz && mv geesunn-agent geesunn

echo "current directoy is : $(pwd)"
for name in  "${SYSNAME[@]}"; do
	c="${OUTDIR}/agent/${name}"
	echo  "create directoy $c"
	mkdir -p $c
	cp -rf geesunn $c
done

#压缩
tar zcf  $TARNAME agent


echo "--------------targz all agent --------------"

ls



if [ ! -n "$1" ];then
	echo "!!! no refresh local agent"
elif [ "$1" == "-f" ];then
	echo "--------------start refresh agent--------------"
	for name in "${SYSNAME[@]}";do
		c="${OUTDIR}/agent/${name}"
		d="${LOCALAGENTDIR}/${name}"
		echo "clear ${d} rigth now \n next line should be empty, be carefully!!!"
		rm -rf "${d}"
		cp -rf "${c}" "${LOCALAGENTDIR}"
	done
	
	ls -l  ${LOCALAGENTDIR}
	echo "--------------finish refresh agent--------------"

fi




# 清除无用数据
rm -rf  agent geesunn geesunn-agent.tar.gz
cd "${OUTDIR}"
echo "please check. ${OUTDIR}"
ls -lh



