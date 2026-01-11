FROM m.daocloud.io/docker.io/library/nginx:1.25-alpine


RUN rm /etc/nginx/conf.d/default.conf

# 拷贝自定义 nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 拷贝前端文件
COPY index.html /usr/share/nginx/html/
COPY main.js /usr/share/nginx/html/
