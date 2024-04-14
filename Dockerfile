# # ###################
# # # 로컬 development 단계
# # ###################
# # docker의 이미지를 정의, 해당 프로젝트에서 node 18 버전을 사용
# # alpine 이미지 사용 시, 1/3 SIZE축소
# #FROM node:18-alpine
# FROM node:18-alpine As development

# # /app 이라는 폴더에서 프로젝트를 실행할 예정이므로 mkdir 명령어로 폴더를 생성
# RUN mkdir -p /var/app

# # /app 이라는 폴더에서 프로젝트를 실행 : 도커는 리눅스 기반이므로 디렉토리 생성 필요
# # WORKDIR /usr/src/app
# # WORKDIR /var/app
# WORKDIR /var/app

# # nest-cli설치 (--slient 옵션 : 로그 없이 설치)
# RUN npm i -g @nestjs/cli

# # Dockerfile이 위치한 폴더의 모든 내용을 /app으로 복사
# # COPY할 때, flag값을 더해 정확한 명령어 COPY 수행 여부 확인
# # COPY . .
# # COPY package*.json ./ 필요 디펜던시 목록 복사 (node module복사가 아닌 목록 가져오기)
# COPY --chown=node:node package*.json ./

# # 프로젝트에서 사용한 패키지를 package.json 을 통하여 모두 설치
# # 종속성 설치 : 배포 및 자동화 시, npm install보다 npm ci 권장
# # (--slient 옵션 : 로그 없이 설치)
# RUN npm ci

# # Bundle app source : 현재 디렉토리(dockerfile이 있는곳)에 있는 파일을 만든 저장소에 복사. WORKDIR의 소스 카피
# COPY . .

# # # root 유저가 아닌 이미지의 node user 사용
# # USER 특정하지 않을 경우, 이미지는 root 권한 사용→ 보안 문제 상, USER 명령어 지정 
# USER node

# # 프로젝트를 빌드 : dist 폴더를 프로덕션 빌드로 만든다
# RUN npm run build

# # 프로젝트에서 8080번 포트를 사용한다는 의미 : main.ts에 설정된 포트를 열어주기
# EXPOSE 8080

# # 빌드 이후에 dist라는 폴더에 main.js가 컴파일되어 생성되므로 해당 파일을 실행
# CMD [ "node", "dist/main.js" ]
