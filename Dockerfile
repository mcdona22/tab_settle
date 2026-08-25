# Stage 1: Build Flutter Web app
FROM ghcr.io/cirrusci/flutter:stable AS build-stage

ARG GEMINI_API_KEY

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY

# Stage 2: Serve via Nginx
FROM nginx:alpine
COPY --from=build-stage /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]