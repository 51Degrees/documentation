# To build the CSS files and put them in the local build dir use:
#   docker build --output=build .
FROM node:10 AS build
WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .
RUN npx gulp sass-change

FROM scratch
COPY --from=build /app/source/css/*.css /
