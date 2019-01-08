echo "当前位置："`pwd`
echo "当前用户："`whoami`

# 环境变量ps:我本地的docker在snap中，如果没有这句话下面docker命令找不到
export PATH=$PATH:/snap/bin

# 定义变量
WORKHOME=$1
BUILD_NUMBER=$2
API_NAME="datacollect"
API_VERSION="1.0"
API_PORT=8081
DOCKER_REGISTRY="registry.cn-hangzhou.aliyuncs.com/zhangchx/test"
IMAGE_NAME="$API_NAME:$BUILD_NUMBER"
CONTAINER_NAME=$API_NAME-$API_VERSION
docker --version

# 进入target 目录复制Dockerfile 文件
#cd $WORKSPACE/target
#cp classes/Dockerfile .
cd $WORKHOME

#构建docker 镜像
docker build -t $IMAGE_NAME .

#推送docker镜像
docker push $DOCKER_REGISTRY$IMAGE_NAME

#删除同名docker容器
cid=$(docker ps -a| grep "$CONTAINER_NAME" | awk '{print $1}')
if [ "$cid" != "" ]; then
   docker rm -f $cid
fi

#启动docker 容器
docker run -d -p $API_PORT:8080 --name $CONTAINER_NAME $IMAGE_NAME

#删除 Dockerfile 文件
#rm -f Dockerfile
