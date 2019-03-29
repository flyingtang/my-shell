#!/bin/bash
# Linux 下Agent 打包
# 直接打包
# -f 参数 可以打包+刷新253的agen

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

#win包名字
WINTARNAME="win.zip"

VERSIONFILE="${OUTDIR}/version.txt"

#当前目录
CURRDIR=$(pwd)

clearWorkDir(){
	cd ${OUTDIR}
	rm -rf  agent geesunn geesunn-agent geesunn-agent.tar.gz
	ls -lh
}

setVersion(){
	if [ ! -f ${VERSIONFILE} ];then
		echo "请输入版本号："
		read VERSION
		echo "${VERSION}" > ${VERSIONFILE}
	else
		VERSION=`cat ${VERSIONFILE}`
	fi
}

showHelp(){
	echo "
		-h  show help
		-f  刷新本地Agent
		-v  设置版本
		-sv 查看当前版本
		"
}

#重置工作目录
resetWorkDir(){
	rm -rf "${OUTDIR}/agent"
	mkdir -p "${OUTDIR}/agent"
}

targz(){
	cd $OUTDIR
	ls "${OUTDIR}/agent"
	# agent_v3.1.tar.gz
	TARNAME="agent_v${VERSION}.tar.gz"
	tar zcf  $TARNAME agent
	echo "--------------打包完毕 --------------"
}

#Windows Agent包
windows(){
	cd ${CURRDIR}
	if [ ! -f  "${CURRDIR}/${WINTARNAME}" ]; then
		echo "当前目录没有win.zip"
		ls
	else
		echo "开始复制windowsAgent到:${OUTDIR}/agent"
		unzip "${WINTARNAME}" -d "${OUTDIR}/agent"
		cd $OUTDIR
	fi
}

#Linux Agent包
linux(){

	cp /root/geesunn/targz/geesunn-agent.tar.gz $OUTDIR && cd $OUTDIR
	tar zxvf $OUTDIR/geesunn-agent.tar.gz && mv geesunn-agent geesunn

	echo "当前目录 : ${CURRDIR}"

	# 复制Linux包
	for name in  "${SYSNAME[@]}"; do
		c="${OUTDIR}/agent/${name}"
		echo  "创建目录： $c"
		mkdir -p $c
		cp -rf geesunn $c
	done
}

#liux Agent 包编译
linuxBuild(){
	cd  $WORKDIR
	git checkout master && git pull
	./pack.sh targz
}

#刷新本地Agent
refreshLocalAgent(){
		echo "--------------开始刷新本地Agent--------------"
		# ls -l  ${LOCALAGENTDIR}
		rm -rf $LOCALAGENTDIR
		# mkdir -p $LOCALAGENTDIR
		cp -rf "${OUTDIR}/agent" $LOCALAGENTDIR
		# 重启采集器
		gmo restart collect
		echo "--------------结束刷新本地Agent--------------"
}

normal(){
	#清空输出目录
	resetWorkDir
	# 设置版本号
	setVersion
	echo "当前版本号： ${VERSION}"
	# linux 编译
	linuxBuild
	# 格式化linux包到指定目录
	linux
	# 格式化windows包到指定目录
	windows
	#打包
	targz
	# 附加动作

	echo "please check. ${OUTDIR}"
}

extraHanle(){
	case $1 in
		"-h")
			showHelp
			;;
		"-f")
			normal
			refreshLocalAgent
			# 清除无用数据
			clearWorkDir
			;;
		"-v")
			# 设置版本
			echo "请输入版本号："
			read VERSION
			mkdir -p $OUTDIR
			echo "${VERSION}" > ${VERSIONFILE}
			;;
		"-sv")
			# 设置版本
			echo "当前版本：`cat ${VERSIONFILE}`"
			;;
		*)
			normal
			# 清除无用数据
			clearWorkDir

	esac
}


extraHanle $1

#TODO 加入window自动替换



