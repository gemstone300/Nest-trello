# ###################
# # 로컬 development 단계
# ###################
# docker의 이미지를 정의, 해당 프로젝트에서 node 18 버전을 사용
# alpine 이미지 사용 시, 1/3 SIZE축소
#FROM node:18-alpine
FROM node:18-alpine As development

# /app 이라는 폴더에서 프로젝트를 실행할 예정이므로 mkdir 명령어로 폴더를 생성
RUN mkdir -p home/ubuntu

# /app 이라는 폴더에서 프로젝트를 실행
# WORKDIR /usr/src/app
WORKDIR home/ubuntu

# Dockerfile이 위치한 폴더의 모든 내용을 /app으로 복사
# COPY할 때, flag값을 더해 정확한 명령어 COPY 수행 여부 확인
# COPY . .
# COPY package*.json ./
COPY --chown=node:node package*.json ./

# 프로젝트에서 사용한 패키지를 package.json 을 통하여 모두 설치
# 종속성 설치 : 배포 및 자동화 시, npm install보다 npm ci 권장
RUN npm ci

# Bundle app source
COPY . .

# # root 유저가 아닌 이미지의 node user 사용
# USER 특정하지 않을 경우, 이미지는 root 권한 사용→ 보안 문제 상, USER 명령어 지정 
USER node

# 프로젝트를 빌드 : dist 폴더를 프로덕션 빌드로 만든다
RUN npm run build

# 프로젝트에서 5000번 포트를 사용한다는 의미
EXPOSE 8080

# 빌드 이후에 dist라는 폴더에 main.js가 생성되므로 해당 파일을 프로덕션 빌드로 실행
CMD [ "node", "dist/main.js" ]
