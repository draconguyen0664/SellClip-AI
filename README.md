# SellClip AI

SellClip AI scaffold theo huong microservice:

- `backend/services/api-gateway`: cong vao cho mobile/web client.
- `backend/services/auth-service`: user/auth profile service.
- `backend/services/clip-service`: quan ly clip, metadata, trang thai xu ly.
- `backend/services/ai-service`: nhan job phan tich/generate AI cho clip.
- `frontend/sellclip_ai_app`: Flutter app shell.
- `infra/mysql`: MySQL init scripts.

## Yeu Cau

- Java 21+.
- Maven 3.9+ hoac Maven Wrapper sau khi bo sung wrapper jar.
- Flutter SDK.
- Docker Desktop.

## Chay MySQL

```powershell
copy .env.example .env
docker compose up -d mysql phpmyadmin
```

MySQL:

- Host: `localhost`
- Port: `3306`
- User: `sellclip`
- Password: `sellclip_password`

phpMyAdmin: `http://localhost:8085`

## Chay Backend

Moi service dang duoc cau hinh de doc DB tu bien moi truong. Co the chay rieng tung service:

```powershell
cd backend
.\mvnw.cmd -pl services/auth-service spring-boot:run
.\mvnw.cmd -pl services/clip-service spring-boot:run
.\mvnw.cmd -pl services/ai-service spring-boot:run
.\mvnw.cmd -pl services/api-gateway spring-boot:run
```

Ports mac dinh:

- API Gateway: `8080`
- Auth Service: `8081`
- Clip Service: `8082`
- AI Service: `8083`

Gateway routes:

- `GET http://localhost:8080/api/auth/health`
- `GET http://localhost:8080/api/clips/health`
- `GET http://localhost:8080/api/ai/health`

## Chay Flutter

```powershell
cd frontend/sellclip_ai_app
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

Neu chay Android emulator, dung API base URL `http://10.0.2.2:8080`.

## Cau Truc

```text
backend/
  pom.xml
  services/
    api-gateway/
    auth-service/
    clip-service/
    ai-service/
frontend/
  sellclip_ai_app/
infra/
  mysql/
```
