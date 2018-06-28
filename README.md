# Ubuntu Desktop Dockerfile

此分支用于部署至Heroku

# 如何使用

**1. 安装heroku命令行（此处以ubuntu为例）** \
`wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh`



**2. 登录heroku** \
`docker login --username=_ --password=$(heroku auth:token) registry.heroku.com`

**3. pull最新镜像并修改tag** \
`docker pull winstonpro/ubuntu-desktop:heroku` \
`docker tag winstonpro/ubuntu-desktop:heroku registry.heroku.com/<app_name>/web`

**4. push至heroku平台** \
`docker push registry.heroku.com/<app_name>/web`

打开浏览器，键入`https://<app_name>.herokuapp.com` .

VNC密码为 `password`.

**更多内容请参考官方文档：https://devcenter.heroku.com/articles/container-registry-and-runtime**
