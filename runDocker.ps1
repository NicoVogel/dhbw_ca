
function Path-For-Docker-Toolbox($PATH){
    $PATH=(($PATH -replace "\\","/") -replace ":","").Trim("/")

    [regex]$regex='^[a-zA-Z]/'
    $PATH=$regex.Replace($PATH, {$args[0].Value.ToLower()})

    $PATH="//$PATH"
    return $PATH
}
function Path-For-Docker($PATH){
    $PATH=(($PATH -replace "\\","/") -replace ":","").Trim("/")

    [regex]$regex='^[a-zA-Z]/'
    $PATH=$regex.Replace($PATH, {$args[0].Value.ToLower()})

    $PATH="/host_mnt/$PATH"
    return $PATH
}

$MOUNT_PATH=""
if($args[0] -Match "t"){
    $MOUNT_PATH = Path-For-Docker-Toolbox -Path ${pwd}
}else{
    $MOUNT_PATH = Path-For-Docker -Path ${pwd}
}

$IMAGE_NAME="birddock/computer-architecture"
$CONTAINER_NAME="computer-architecture"

$CONTAINER_ID=docker ps -q -f name=$CONTAINER_NAME

if(($args[0] -Match "r") -And ($CONTAINER_ID)){
  docker rm -vf $CONTAINER_ID
  $CONTAINER_ID=""
}


if($CONTAINER_ID){
  docker start $CONTAINER_ID
}
else{
  docker run -d -p 5900:5900 -v $MOUNT_PATH/dosbox:/dosbox -v $MOUNT_PATH/verilog:/verilog --name $CONTAINER_NAME $IMAGE_NAME
}