# SellClip AI

SellClip AI la ung dung tao clip ban hang bang AI theo kien truc microservice. Repo gom backend Spring Boot, frontend Flutter mobile va MySQL local cho du lieu auth, project, brand kit, template.

## Tinh nang hien co

- Splash, Welcome, Login, Register, Verify Email, Forgot Password, Reset Password.
- Onboarding 5 buoc sau lan dang nhap dau tien.
- Home dashboard voi credits, quick tools, recent projects, render progress va bottom navigation.
- Projects: tao project, list project, tim kiem, folder da luu, filter bang bottom sheet, menu 3 cham.
- Project actions: mo, doi ten, duplicate, dua vao folder, archive, delete.
- Create Project: chon loai project, ty le, brand kit va template.
- Brand Kit: chon/list brand kit, tao brand kit moi, upload/chon logo local, palette, color picker, typography, assets, preview.
- Template: chon template, phan biet Free/Premium, popup nang cap khi chon Premium.
- Animation: page transition toan app, tab transition Home/Projects, animated button/card/selection states.

## Kien truc

```text
backend/
  pom.xml
  services/
    api-gateway/     # Cong vao cho mobile/web client
    auth-service/    # Dang ky, dang nhap, xac minh email, reset password
    clip-service/    # Project, folder, brand kit, template, clip metadata
    ai-service/      # Nen tang job AI/generate clip
frontend/
  sellclip_ai_app/   # Flutter mobile app
infra/
  mysql/init/        # Init database MySQL
```

## Yeu cau

- Java 21+
- Maven 3.9+ hoac Maven Wrapper
- Flutter SDK
- Android Studio + Android Emulator
- Docker Desktop

## Chay MySQL

```powershell
copy .env.example .env
docker compose up -d mysql phpmyadmin
```

MySQL local:

- Host: `localhost`
- Port: `3306`
- User/Password: xem `.env` va tung `application.yml`

phpMyAdmin:

- `http://localhost:8085`

## Chay Backend

Co the chay tung service rieng:

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

Health/API nhanh:

```powershell
curl http://localhost:8081/api/auth/health
curl http://localhost:8082/api/projects?ownerId=1
curl http://localhost:8082/api/projects/folders?ownerId=1
curl http://localhost:8082/api/templates?ownerId=1
curl http://localhost:8082/api/brand-kits?ownerId=1
```

## Chay Flutter Android Emulator

Dung `10.0.2.2` de app Android emulator goi backend tren may host:

```powershell
cd frontend/sellclip_ai_app
flutter pub get
flutter run -d emulator-5554 `
  --dart-define=API_BASE_URL=http://10.0.2.2:8081 `
  --dart-define=CLIP_API_BASE_URL=http://10.0.2.2:8082
```

Build APK debug:

```powershell
cd frontend/sellclip_ai_app
flutter build apk --debug `
  --dart-define=API_BASE_URL=http://10.0.2.2:8081 `
  --dart-define=CLIP_API_BASE_URL=http://10.0.2.2:8082
```

## Verify truoc khi push

```powershell
cd frontend/sellclip_ai_app
flutter analyze

cd ../../backend/services/clip-service
mvn -q -DskipTests compile
```

## Ghi chu phat trien

- FE tach `screens/`, `components/`, `services/` theo dung vai tro.
- BE clip-service tach `controller`, `dto`, `entity`, `repository`, `service`, `serviceimpl`.
- Project/template/brand kit dang luu MySQL thong qua Spring Data JPA.
- Animation dung chung nam o `frontend/sellclip_ai_app/lib/components/motion/sellclip_motion.dart` va duoc gan trong `MaterialApp.pageTransitionsTheme`.
- Khi UI tren emulator khong cap nhat, chay `flutter clean`, build lai, uninstall app cu roi install APK moi.