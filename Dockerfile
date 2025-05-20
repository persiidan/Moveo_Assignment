FROM nginx:alpine
RUN echo "yo this is nginx" > /usr/share/nginx/html/index.html
